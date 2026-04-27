#!/bin/bash
REPO_URL="https://raw.githubusercontent.com/samueltobiasmartinez09/modpack/main"
INST_DIR="$(dirname "$(readlink -f "$0")")"

echo "--- Sincronizando Instancia (Linux) ---"

# 1. RAM e Instance.cfg (Flags G1GC optimizados)
total_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
total_gb=$((total_kb / 1024 / 1024))

if [ "$total_gb" -le 5 ]; then asignar_ram=3072; else asignar_ram=6144; fi
jvm_args="-XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=50 -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:G1HeapRegionSize=32M -XX:+AlwaysPreTouch"

sed -i "s/MinMem=.*/MinMem=$asignar_ram/" "$INST_DIR/instance.cfg"
sed -i "s/MaxMem=.*/MaxMem=$asignar_ram/" "$INST_DIR/instance.cfg"
sed -i "s/JvmArgs=.*/JvmArgs=$jvm_args/" "$INST_DIR/instance.cfg"
sed -i "s/OverrideJava=.*/OverrideJava=true/" "$INST_DIR/instance.cfg"
sed -i "s/JavaPath=.*/JavaPath=runtime\/bin\/java/" "$INST_DIR/instance.cfg"
sed -i "s/ExternalJavaCheck=.*/ExternalJavaCheck=true/" "$INST_DIR/instance.cfg"
sed -i "s/IgnoreJavaCompatibility=.*/IgnoreJavaCompatibility=true/" "$INST_DIR/instance.cfg"

# 3. Packwiz
cd "$INST_DIR"
"$INST_DIR/runtime/bin/java" -jar "$INST_DIR/packwiz-installer-bootstrap.jar" "$REPO_URL/pack.toml"