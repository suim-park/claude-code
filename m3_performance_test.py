#!/usr/bin/env python3
"""
M3 성능 테스트 스크립트
Apple Silicon M3의 성능을 다양한 방법으로 테스트합니다.
"""

import time
import numpy as np
import platform
import subprocess
import sys
from datetime import datetime


def print_header(title):
    """헤더 출력"""
    print("\n" + "=" * 60)
    print(f" {title}")
    print("=" * 60)


def get_system_info():
    """시스템 정보 출력"""
    print_header("시스템 정보")
    print(f"플랫폼: {platform.platform()}")
    print(f"아키텍처: {platform.machine()}")
    print(f"프로세서: {platform.processor()}")
    print(f"Python 버전: {platform.python_version()}")

    # M3 특화 정보
    try:
        result = subprocess.run(
            ["sysctl", "-n", "machdep.cpu.brand_string"], capture_output=True, text=True
        )
        if result.returncode == 0:
            print(f"CPU 브랜드: {result.stdout.strip()}")
    except:
        pass


def test_numpy_performance():
    """NumPy 성능 테스트"""
    print_header("NumPy 성능 테스트")

    # 대용량 배열 생성 테스트
    sizes = [1000, 5000, 10000]

    for size in sizes:
        print(f"\n{size}x{size} 배열 테스트:")

        # 배열 생성 시간
        start_time = time.time()
        arr = np.random.rand(size, size)
        creation_time = time.time() - start_time
        print(f"  배열 생성: {creation_time:.4f}초")

        # 행렬 곱셈 시간
        start_time = time.time()
        result = np.dot(arr, arr)
        multiplication_time = time.time() - start_time
        print(f"  행렬 곱셈: {multiplication_time:.4f}초")

        # 총 시간
        total_time = creation_time + multiplication_time
        print(f"  총 시간: {total_time:.4f}초")


def test_memory_operations():
    """메모리 작업 테스트"""
    print_header("메모리 작업 테스트")

    # 대용량 데이터 생성 및 처리
    print("1GB 데이터 생성 및 처리 테스트:")

    start_time = time.time()

    # 약 1GB의 데이터 생성 (float64 기준)
    size = int(1e9 // 8)  # 1GB / 8 bytes per float64
    data = np.random.rand(size)

    creation_time = time.time() - start_time
    print(f"  데이터 생성: {creation_time:.4f}초")

    # 데이터 처리
    start_time = time.time()
    processed = np.sort(data)
    sort_time = time.time() - start_time
    print(f"  정렬: {sort_time:.4f}초")

    # 통계 계산
    start_time = time.time()
    mean_val = np.mean(data)
    std_val = np.std(data)
    stats_time = time.time() - start_time
    print(f"  통계 계산: {stats_time:.4f}초")

    total_time = creation_time + sort_time + stats_time
    print(f"  총 시간: {total_time:.4f}초")
    print(f"  평균: {mean_val:.6f}")
    print(f"  표준편차: {std_val:.6f}")


def test_parallel_operations():
    """병렬 작업 테스트"""
    print_header("병렬 작업 테스트")

    import multiprocessing as mp

    def worker_function(n):
        """작업자 함수"""
        result = 0
        for i in range(n):
            result += i**2
        return result

    # CPU 코어 수 확인
    cpu_count = mp.cpu_count()
    print(f"CPU 코어 수: {cpu_count}")

    # 단일 프로세스 테스트
    print("\n단일 프로세스 테스트:")
    start_time = time.time()
    result_single = worker_function(10000000)
    single_time = time.time() - start_time
    print(f"  시간: {single_time:.4f}초")
    print(f"  결과: {result_single}")

    # 멀티프로세스 테스트
    print(f"\n{cpu_count}개 프로세스 테스트:")
    start_time = time.time()

    with mp.Pool(processes=cpu_count) as pool:
        results = pool.map(worker_function, [10000000 // cpu_count] * cpu_count)

    multi_time = time.time() - start_time
    total_result = sum(results)
    print(f"  시간: {multi_time:.4f}초")
    print(f"  결과: {total_result}")
    print(f"  속도 향상: {single_time/multi_time:.2f}x")


def test_claude_code_integration():
    """Claude Code 통합 테스트"""
    print_header("Claude Code 통합 테스트")

    try:
        # Node.js 버전 확인
        result = subprocess.run(["node", "--version"], capture_output=True, text=True)
        if result.returncode == 0:
            print(f"Node.js 버전: {result.stdout.strip()}")

        # Claude Code 버전 확인
        result = subprocess.run(["claude", "--version"], capture_output=True, text=True)
        if result.returncode == 0:
            print(f"Claude Code 버전: {result.stdout.strip()}")

        print("✅ Claude Code가 정상적으로 설치되어 있습니다!")

    except Exception as e:
        print(f"❌ Claude Code 테스트 실패: {e}")


def benchmark_comparison():
    """벤치마크 비교"""
    print_header("M3 벤치마크 비교")

    # 간단한 벤치마크
    print("간단한 계산 벤치마크:")

    # 반복 계산
    iterations = 10000000
    start_time = time.time()

    result = 0
    for i in range(iterations):
        result += i * 2 + 1

    end_time = time.time()
    calculation_time = end_time - start_time

    print(f"  {iterations:,}회 반복 계산: {calculation_time:.4f}초")
    print(f"  결과: {result}")
    print(f"  계산 속도: {iterations/calculation_time:,.0f} ops/sec")


def main():
    """메인 함수"""
    print("🚀 M3 성능 테스트 시작")
    print(f"테스트 시작 시간: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

    try:
        # 시스템 정보
        get_system_info()

        # NumPy 성능 테스트
        test_numpy_performance()

        # 메모리 작업 테스트
        test_memory_operations()

        # 병렬 작업 테스트
        test_parallel_operations()

        # Claude Code 통합 테스트
        test_claude_code_integration()

        # 벤치마크 비교
        benchmark_comparison()

        print_header("테스트 완료")
        print("✅ 모든 테스트가 성공적으로 완료되었습니다!")
        print("🎯 M3의 성능을 확인했습니다.")

    except Exception as e:
        print(f"❌ 테스트 중 오류 발생: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
