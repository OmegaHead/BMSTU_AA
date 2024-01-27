import Foundation

public class CPUTimeMeasure {

    // MARK: - Private

    private var numberOfRuns: Int

    // MARK: - Public

    public func setNumberOfRuns(_ numberOfRuns: Int) {
        self.numberOfRuns = numberOfRuns
    }

    public func getNumberOfRuns() -> Int {
        return numberOfRuns
    }

    public func measureCPUTimeFunc(_ type: AlgorithmType, runsCount: Int = 1) -> Double {
        let startTime = Date()
        for _ in 0..<runsCount {
            let _ = Algorithms.execute(type)
        }
        let endTime = Date()
        return endTime.timeIntervalSince(startTime) * 1000
    }

    public func measureCPUTime(_ params: Params) {
        let time1 = measureCPUTimeFunc(.bruteForce(params: params))
        let time2 = measureCPUTimeFunc(.antAlgorithm(params: params))

        print("Время выполнения представлено ниже. Количество измерений равно \(numberOfRuns)")
        print(Constants.bruteForce, Constants.time, "      : \(time1) мс")
        print(Constants.antAlgorithm, Constants.time, "         : \(time2) мс")
    }

    // MARK: - LifeCycle

    public init(_ numberOfRuns: Int = 100000) {
        self.numberOfRuns = numberOfRuns
    }
}

extension CPUTimeMeasure {
    private enum Constants {
        static let bruteForce = "Полный перебор"
        static let antAlgorithm = "Муравьиный алгоритм"

        static let time = "Измерение времени"
    }
}
