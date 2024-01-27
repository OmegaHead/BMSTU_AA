import Foundation

public class CPUTimeMeasure {

    // MARK: - Private

    private enum Constants {
        static let nonRecursiveDamerauLevenshteinDistance = "Non Recursive Damerau-Levenshtein Distance Algorithm"
        static let recursiveDamerauLevenshteinDistance = "Recursive Damerau-Levenshtein Distance Algorithm"
        static let recursiveCacheDamerauLevenshteinDistance = "Recursive Cache Damerau-Levenshtein Distance Algorithm"
        static let nonRecursiveLevenshteinDistance = "Non recursive Levenshtein Distance Algorithm"

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

    public func measureCPUTimeFunc(_ function: (AlgorithmType) -> Int, _ type: AlgorithmType, runsCount: Int = 1) -> Double {
        var startTime = timespec()
        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &startTime)
        for _ in 0..<runsCount { let _ = function(type) }
        var endTime = timespec()
        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &endTime)

        return (Double(endTime.tv_sec - startTime.tv_sec) * 1e9 + Double(endTime.tv_nsec - startTime.tv_nsec)) / (Double(runsCount) * 1e3)
    }

    public func measureCPUTime(_ s1: String, _ s2: String) {
        let time1 = measureCPUTimeFunc(Algorithms.execute, .nonRecursiveDamerauLevenshteinDistance(s1, s2, print: false), runsCount: numberOfRuns)
        let time2 = measureCPUTimeFunc(Algorithms.execute, .recursiveDamerauLevenshteinDistance(s1, s2), runsCount: numberOfRuns)
        let time3 = measureCPUTimeFunc(Algorithms.execute, .recursiveCacheDamerauLevenshteinDistance(s1, s2, print: false), runsCount: numberOfRuns)
        let time4 = measureCPUTimeFunc(Algorithms.execute, .nonRecursiveLevenshteinDistance(s1, s2), runsCount: numberOfRuns)

        print("Result time. The number of runs for each method equals \(numberOfRuns)")
        print(Constants.nonRecursiveDamerauLevenshteinDistance, Constants.cpuTime, "  : \(time1) µs")
        print(Constants.recursiveDamerauLevenshteinDistance, Constants.cpuTime, "      : \(time2) µs")
        print(Constants.recursiveCacheDamerauLevenshteinDistance, Constants.cpuTime, ": \(time3) µs")
        print(Constants.nonRecursiveLevenshteinDistance, Constants.cpuTime, "          : \(time4) µs")
    }

    // MARK: - LifeCycle

    public init(_ numberOfRuns: Int = 1000) {
        self.numberOfRuns = numberOfRuns
    }
}
