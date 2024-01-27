import Foundation

public class CPUTimeMeasure {

    // MARK: - Private

    private enum Constants {
        static let pancakeSort = "Pancake sort"
        static let radixSort = "Radix sort"
        static let treeSort = "Binary tree sort"

        static let cpuTime = "CPU time"
    }

    private var numberOfRuns: Int

    // MARK: - Public

    public func setNumberOfRuns(_ numberOfRuns: Int) {
        self.numberOfRuns = numberOfRuns
    }

    public func getNumberOfRuns() -> Int {
        return numberOfRuns
    }

    public func measureCPUTimeFunc(_ function: (AlgorithmType, inout [Int]) -> (), _ type: AlgorithmType,_ arr: [Int], runsCount: Int = 1) -> Double {
        var startTime = timespec()
        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &startTime)
        for _ in 0..<runsCount {
            var arr1 = arr
            function(type, &arr1)
        }
        var endTime = timespec()
        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &endTime)

        return (Double(endTime.tv_sec - startTime.tv_sec) * 1e9 + Double(endTime.tv_nsec - startTime.tv_nsec)) / (Double(runsCount) * 1e3)
    }

    public func measureCPUTime(_ arr: [Int]) {
        let time1 = measureCPUTimeFunc(Algorithms.execute, .pancakeSort, arr)
        let time2 = measureCPUTimeFunc(Algorithms.execute, .radixSort, arr)
        let time3 = measureCPUTimeFunc(Algorithms.execute, .binaryTreeSort, arr)

        print("Result time. The number of runs for each method equals \(numberOfRuns)")
        print(Constants.pancakeSort, Constants.cpuTime, "      : \(time1) µs")
        print(Constants.radixSort, Constants.cpuTime, "         : \(time2) µs")
        print(Constants.treeSort, Constants.cpuTime, ": \(time3) µs")
    }

    // MARK: - LifeCycle

    public init(_ numberOfRuns: Int = 100000) {
        self.numberOfRuns = numberOfRuns
    }
}
