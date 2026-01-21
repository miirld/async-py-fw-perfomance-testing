# ./analyzer.sh <log_file> <summary_file>
CLEAN_DATA=$(head -n -1 "$1" | sed 's/%//g; s/\/.*//g; s/iB//g')

read avg_cpu max_cpu max_mem avg_mem <<< $(echo "$CLEAN_DATA" | awk -F';' 'NR > 1 {
    cpu = $2; 
    mem_val = $3;
    
    gsub(/[ \t]+/, "", mem_val);
    
    if (mem_val ~ /G/) { 
        sub(/G/, "", mem_val); 
        mem_val *= 1024 
    } else { 
        sub(/M/, "", mem_val) 
    }
    
    mem = mem_val;
    sum_cpu += cpu; 
    sum_mem += mem;
    if(cpu > max_c) max_c = cpu; 
    if(mem > max_m) max_m = mem; 
    count++
} END { 
    if(count > 0) printf "%.2f %.2f %.2f %.2f", sum_cpu/count, max_c, max_m, sum_mem/count; 
    else print "0 0 0 0" 
}')


{
    echo "Average CPU: $avg_cpu %"
    echo "Max CPU: $max_cpu %"
    echo "Average RAM: $avg_mem MiB"
    echo "Max RAM (Peak): $max_mem MiB"
} > "$2"
