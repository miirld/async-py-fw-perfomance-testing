# ./monitor.sh <container_name> <log_file> <interval>
echo "timestamp;cpu_percent;mem_usage" > "$2"
sleep "$3"
while true; do
  docker stats "$1" --no-stream --format "$(date +%H:%M:%S);{{.CPUPerc}};{{.MemUsage}}" >> "$2"
  sleep "$3"
done
