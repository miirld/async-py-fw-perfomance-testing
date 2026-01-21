TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RUN_DIR="./results/run_${TIMESTAMP}"

SERVICES=("fastapi" "tornado" "sanic" "aiohttp" "litestar")
TEST_TYPES=("warmup" "get-cpu" "get-io_work" "get-io_stress" "get-io_soak")

for SVC in "${SERVICES[@]}"; do
    echo ">>> Тестируем $SVC..."
    docker compose up -d $SVC
    sleep 30 
    mkdir -p "$RUN_DIR/$SVC"

    for TEST in "${TEST_TYPES[@]}"; do
        echo "  > Запуск теста: $TEST"
        TEST_DIR="$RUN_DIR/$SVC/$TEST"
        mkdir -p "$TEST_DIR/report"
        chmod -R 777 "$TEST_DIR"

        STATS_LOG="$TEST_DIR/resource_usage.log"
        ./monitor.sh "${SVC}-benchmark" "$STATS_LOG" 3 &
        MONITOR_PID=$!

        docker run --name jmeter-test --rm \
          --network shared-benchmark-net \
          --cpuset-cpus="6-9" \
          --memory="4g" \
          --memory-reservation="4g" \
          --memory-swap="4g" \
          -e _JAVA_OPTIONS="-Xms3g -Xmx3g -XX:ActiveProcessorCount=4 -XX:ParallelGCThreads=2 -XX:ConcGCThreads=1 -XX:+UseG1GC" \
          -v $(pwd):/tests \
          alpine/jmeter:5.6.3 -n \
          -t "/tests/${TEST}.jmx" \
          -Jtarget_host="${SVC}-benchmark" \
          -l "/tests/$TEST_DIR/results.jtl" \

        kill $MONITOR_PID 2>/dev/null

        docker run --name jmeter-reporter --rm \
          -v $(pwd):/tests \
          alpine/jmeter:5.6.3 -g "/tests/$TEST_DIR/results.jtl" -o "/tests/$TEST_DIR/report"

        ./analyzer.sh "$STATS_LOG" "$TEST_DIR/resource_summary.txt"

        sleep 15
    done

    docker compose stop $SVC
    docker compose rm -f $SVC
    sleep 15
done