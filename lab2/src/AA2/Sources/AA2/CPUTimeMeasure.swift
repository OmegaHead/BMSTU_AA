import Foundation

public class CPUTimeMeasure {

    // MARK: - Private

    private enum Constants {
        static let standartMultiply = "Standart Multiply"
        static let vinogradMultiply = "Vinograd Multiply"
        static let vinogradOptimized = "Vinograd Optimized Multiply"

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

    public func measureCPUTimeFunc(_ function: (AlgorithmType) -> [[Int]], _ type: AlgorithmType, runsCount: Int = 1) -> Double {
        var startTime = timespec()
        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &startTime)
        for _ in 0..<runsCount { let _ = function(type) }
        var endTime = timespec()
        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &endTime)

        return (Double(endTime.tv_sec - startTime.tv_sec) * 1e9 + Double(endTime.tv_nsec - startTime.tv_nsec)) / (Double(runsCount) * 1e3)
    }

    public func measureCPUTime(_ matrix1: [[Int]], _ matrix2: [[Int]]) {
        let time1 = measureCPUTimeFunc(Algorithms.execute, .standartMultiply(matrix1, matrix2))
        let time2 = measureCPUTimeFunc(Algorithms.execute, .vinogradMultiply(matrix1, matrix2))
        let time3 = measureCPUTimeFunc(Algorithms.execute, .vinogradOptimizedMultiply(matrix1, matrix2))

        print("Result time. The number of runs for each method equals \(numberOfRuns)")
        print(Constants.standartMultiply, Constants.cpuTime, "      : \(time1) µs")
        print(Constants.vinogradMultiply, Constants.cpuTime, "         : \(time2) µs")
        print(Constants.vinogradOptimized, Constants.cpuTime, ": \(time3) µs")
    }

    // MARK: - LifeCycle

    public init(_ numberOfRuns: Int = 1000) {
        self.numberOfRuns = numberOfRuns
    }
}
