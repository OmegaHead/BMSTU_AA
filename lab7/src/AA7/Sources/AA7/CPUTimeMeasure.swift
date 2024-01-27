import Foundation

public class CPUTimeMeasure {

    // MARK: - Private

    private enum Constants {
        static let standartSearch = "Стандартный поиск"
        static let boyerMooreSearch = "Поиск с использованием алгоритма Бойера-Мура"

        static let cpuTime = "время"
    }

    private var numberOfRuns: Int

    // MARK: - Public

    public func setNumberOfRuns(_ numberOfRuns: Int) {
        self.numberOfRuns = numberOfRuns
    }

    public func getNumberOfRuns() -> Int {
        return numberOfRuns
    }

    public func measureCPUTimeFunc(_ function: (AlgorithmType) -> [Int], _ type: AlgorithmType, runsCount: Int = 1) -> Double {
        var startTime = timespec()
        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &startTime)
        for _ in 0..<runsCount { let _ = function(type) }
        var endTime = timespec()
        clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &endTime)

        return (Double(endTime.tv_sec - startTime.tv_sec) * 1e9 + Double(endTime.tv_nsec - startTime.tv_nsec)) / (Double(runsCount) * 1e3)
    }

    public func measureCPUTime(_ string: String, _ substring: String) {
        let time1 = measureCPUTimeFunc(Algorithms.execute, .standartSearch(substring, string))
        let time2 = measureCPUTimeFunc(Algorithms.execute, .boyerMooreSearch(substring, string))

        print("Полученное время. Количество запусков для каждого алгоритма равно \(numberOfRuns)")
        print(Constants.standartSearch, Constants.cpuTime, "      : \(time1) µs")
        print(Constants.boyerMooreSearch, Constants.cpuTime, "         : \(time2) µs")
    }

    // MARK: - LifeCycle

    public init(_ numberOfRuns: Int = 1000) {
        self.numberOfRuns = numberOfRuns
    }
}
