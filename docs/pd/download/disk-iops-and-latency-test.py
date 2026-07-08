#!/usr/bin/env python3
"""
Disk Write IOPS and Latency Tester for Linux
Tests random write performance with configurable parameters
"""

import os
import sys
import time
import statistics

def test_disk_performance(filename, iterations=1000, block_size=4096, use_direct_io=True):
    """
    Test disk write IOPS and latency
    
    Args:
        filename: Path to test file
        iterations: Number of write operations
        block_size: Size of each write in bytes (default 4KB)
        use_direct_io: Use O_DIRECT to bypass cache (default True)
    """
    latencies = []
    
    # Open file with appropriate flags
    flags = os.O_WRONLY | os.O_CREAT | os.O_TRUNC
    if use_direct_io:
        flags |= os.O_DIRECT | os.O_SYNC
    
    try:
        fd = os.open(filename, flags)
    except OSError as e:
        print(f"Error opening file: {e}")
        print("Note: O_DIRECT may require block-aligned I/O or may not be supported on all filesystems")
        return
    
    # Prepare data buffer (must be aligned for O_DIRECT)
    data = b'x' * block_size
    
    print("Testing disk write performance...")
    print(f"File: {filename}")
    print(f"Block size: {block_size} bytes")
    print(f"Iterations: {iterations}")
    print(f"Direct I/O: {use_direct_io}")
    print("\nRunning test...\n")
    
    # Measure total time and individual write latencies
    start_time = time.perf_counter()
    
    for i in range(iterations):
        write_start = time.perf_counter()
        try:
            os.write(fd, data)
        except OSError as e:
            print(f"Write error at iteration {i}: {e}")
            break
        write_end = time.perf_counter()
        latencies.append((write_end - write_start) * 1000)  # Convert to ms
        
        # Progress indicator every 100 iterations
        # if (i + 1) % 100 == 0:
        #     print(f"Progress: {i + 1}/{iterations} writes completed")
    
    total_time = time.perf_counter() - start_time
    os.close(fd)
    
    # Calculate metrics
    if not latencies:
        print("No successful writes completed")
        return
    
    iops = len(latencies) / total_time
    avg_latency = statistics.mean(latencies)
    median_latency = statistics.median(latencies)
    stdev_latency = statistics.stdev(latencies) if len(latencies) > 1 else 0
    min_latency = min(latencies)
    max_latency = max(latencies)
    
    # Calculate percentiles
    sorted_latencies = sorted(latencies)
    p50 = sorted_latencies[int(len(sorted_latencies) * 0.50)]
    p95 = sorted_latencies[int(len(sorted_latencies) * 0.95)]
    p99 = sorted_latencies[int(len(sorted_latencies) * 0.99)]
    p999 = sorted_latencies[int(len(sorted_latencies) * 0.999)]
    
    # Calculate throughput
    total_bytes = len(latencies) * block_size
    throughput_mbs = (total_bytes / (1024 * 1024)) / total_time
    
    # Print results
    print("="*60)
    print("DISK WRITE PERFORMANCE RESULTS")
    print("="*60)
    print("\nIOPS Metrics:")
    print(f"  Write IOPS:           {iops:,.2f} ops/sec")
    print(f"  Throughput:           {throughput_mbs:.2f} MB/s")
    print(f"  Total operations:     {len(latencies):,}")
    print(f"  Total time:           {total_time:.2f} seconds")
    print(f"  Total data written:   {total_bytes / (1024*1024):.2f} MB")
    
    print("\nLatency Metrics (milliseconds):")
    print(f"  Average:              {avg_latency:.3f} ms")
    print(f"  Median (P50):         {median_latency:.3f} ms")
    print(f"  Std Deviation:        {stdev_latency:.3f} ms")
    print(f"  Minimum:              {min_latency:.3f} ms")
    print(f"  Maximum:              {max_latency:.3f} ms")
    
    print("\nLatency Percentiles:")
    print(f"  P50 (median):         {p50:.3f} ms")
    print(f"  P95:                  {p95:.3f} ms")
    print(f"  P99:                  {p99:.3f} ms")
    print(f"  P99.9:                {p999:.3f} ms")
    print("="*60)
    
    # Cleanup
    try:
        os.remove(filename)
        print(f"\nTest file removed: {filename}")
    except OSError:
        print(f"\nWarning: Could not remove test file: {filename}")

def main():
    # Parse command line arguments
    if len(sys.argv) < 2:
        print("Usage: python3 disk_test.py <test_file_path> [iterations] [block_size]")
        print("\nExample:")
        print("  python3 disk_test.py /tmp/test_file 1000 4096")
        print("\nArguments:")
        print("  test_file_path: Path where test file will be created")
        print("  iterations:     Number of write operations (default: 1000)")
        print("  block_size:     Size of each write in bytes (default: 4096)")
        print("  use_direct_io:  Specify 0 to disable use Direct IO (default: 1)")
        sys.exit(1)
    
    filename = sys.argv[1]
    iterations = int(sys.argv[2]) if len(sys.argv) > 2 else 1000
    block_size = int(sys.argv[3]) if len(sys.argv) > 3 else 4096
    use_direct_io = int(sys.argv[4]) if len(sys.argv) > 4 else 1
    if use_direct_io == 1:
        use_direct_io = True
    else:
        use_direct_io = False
    
    # Run the test
    test_disk_performance(filename, iterations, block_size, use_direct_io)

if __name__ == "__main__":
    main()
