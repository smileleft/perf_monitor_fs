#!/bin/bash

# C 프로그램 컴파일
echo "Compiling test_file_operations.c..."
gcc test_file_operations.c -o test_file_operations
if [ $? -ne 0 ]; then
    echo "Compilation failed."
    exit 1
fi
echo "Compilation successful."

echo "---------------------------------------------------"
echo "Starting perf monitoring for filesystem events..."
echo "---------------------------------------------------"

# perf record를 사용하여 파일시스템 관련 트레이스 포인트 기록
# -e 'syscalls:sys_enter_open' : open 시스템 콜 진입 추적
# -e 'syscalls:sys_exit_open'  : open 시스템 콜 종료 추적
# -e 'syscalls:sys_enter_write' : write 시스템 콜 진입 추적
# -e 'syscalls:sys_exit_write'  : write 시스템 콜 종료 추적
# -e 'syscalls:sys_enter_read' : read 시스템 콜 진입 추적
# -e 'syscalls:sys_exit_read'  : read 시스템 콜 종료 추적
# -e 'syscalls:sys_enter_unlink' : unlink 시스템 콜 진입 추적
# -e 'syscalls:sys_exit_unlink'  : unlink 시스템 콜 종료 추적
# -a : 시스템 전체 추적 (전역적 파일시스템 활동을 보려면 유용)
# --call-graph dwarf : 함수 호출 그래프를 생성 (더 자세한 정보를 위해)
# -o perf.data : 결과를 perf.data 파일에 저장
sudo perf record -e 'syscalls:sys_enter_open,syscalls:sys_exit_open,syscalls:sys_enter_write,syscalls:sys_exit_write,syscalls:sys_enter_read,syscalls:sys_exit_read,syscalls:sys_enter_unlink,syscalls:sys_exit_unlink' \
                 -a --call-graph dwarf -o perf.data \
                 ./test_file_operations

echo "---------------------------------------------------"
echo "perf monitoring completed. Analyzing results..."
echo "---------------------------------------------------"

# perf report를 사용하여 기록된 데이터 분석
# -g : 호출 그래프 표시
sudo perf report -g

echo "---------------------------------------------------"
echo "Done."
echo "---------------------------------------------------"

# 생성된 실행 파일 및 데이터 파일 정리 (선택 사항)
# rm test_file_operations perf.data
