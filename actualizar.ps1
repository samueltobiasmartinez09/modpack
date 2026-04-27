    # Configuración Final (Solución de Ruta GitHub)
    $RepoURL = "https://raw.githubusercontent.com/samueltobiasmartinez09/modpack/main"
    $JarFile = "$PSScriptRoot\packwiz-installer-bootstrap.jar"
    $RuntimeDir = "$PSScriptRoot\runtime"

    Write-Host "--- Sincronizando Instancia con Optimización G1GC ---" -ForegroundColor Cyan

    # 1. Ajustes de RAM y Flags Anti-Lag
    $TotalRamGB = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
    # Asignamos 3GB para PCs de 4-5GB, y 6GB para PCs de 8GB+
    $AsignarRAM = if ($TotalRamGB -le 5) { 3072 } else { 6144 }
    $JvmArgs = "-XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=50 -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:G1HeapRegionSize=32M -XX:+AlwaysPreTouch"

    $CfgPath = "$PSScriptRoot\instance.cfg"
    if (Test-Path $CfgPath) {
        $Cfg = Get-Content $CfgPath
        $Cfg = $Cfg -replace "MinMem=.*", "MinMem=$AsignarRAM"
        $Cfg = $Cfg -replace "MaxMem=.*", "MaxMem=$AsignarRAM"
        $Cfg = $Cfg -replace "JvmArgs=.*", "JvmArgs=$JvmArgs"
        $Cfg = $Cfg -replace "OverrideJava=.*", "OverrideJava=true"
        $Cfg = $Cfg -replace "JavaPath=.*", "JavaPath=runtime/bin/java.exe"
        $Cfg = $Cfg -replace "ExternalJavaCheck=.*", "ExternalJavaCheck=true"
        $Cfg = $Cfg -replace "IgnoreJavaCompatibility=.*", "IgnoreJavaCompatibility=true"
        $Cfg | Set-Content $CfgPath
    }

    # 3. Packwiz
    Set-Location $PSScriptRoot
    & "$RuntimeDir\bin\java.exe" -jar "$JarFile" "$RepoURL/pack.toml"

    Write-Host "--- Sincronización Exitosa (6GB Asignados) ---" -ForegroundColor Green