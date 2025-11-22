#!/bin/bash

COMPUTERS_FILE="/home/shiro/Desktop/PingLogs/computers.txt"
LOG_DIR="/home/shiro/Desktop/PingLogs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/ping_results.log"

if [ ! -f "$COMPUTERS_FILE" ]; then
cat > "$COMPUTERS_FILE" <<EOF
# One host per line
localhost
8.8.8.8

EOF
echo "Created sample $COMPUTERS_FILE. Edit it then rerun."; exit 1
fi

echo "Started $(date '+%Y-%m-%d %H:%M:%S')" > "$LOG_FILE"
ok=0; fail=0; total=0

while IFS= read -r h || [ -n "$h" ]; do
  h="$(echo "$h" | xargs)"
  [ -z "$h" ] && continue
  [[ "$h" =~ ^# ]] && continue
  total=$((total+1))
  if ping -c 1 -W 2 "$h" >/dev/null 2>&1; then
    ok=$((ok+1))
    echo "$(date '+%Y-%m-%d %H:%M:%S') UP   $h" >> "$LOG_FILE"
    echo "UP   $h"
  else
    fail=$((fail+1))
    echo "$(date '+%Y-%m-%d %H:%M:%S') DOWN $h" >> "$LOG_FILE"
    echo "DOWN $h"
  fi
done < "$COMPUTERS_FILE"

{
echo "Finished $(date '+%Y-%m-%d %H:%M:%S')"
echo "Totals: $total hosts, $ok up, $fail down"
} >> "$LOG_FILE"

echo "Log written to $LOG_FILE"
echo "=======================================" | tee -a "$LOG_FILE"
