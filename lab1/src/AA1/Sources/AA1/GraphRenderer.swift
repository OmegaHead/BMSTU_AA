import Foundation
import SwiftPlot
import SVGRenderer

public class GraphRenderer {

    // MARK: - Private

    private let x: [Double] = Array(stride(from: 1.0, to: 10.5, by: 1.0))

    private enum Constants {
        static let nonRecursiveDamerauLevenshteinDistanceGraph = "nonRecursiveDamerauLevenshteinDistance"
        static let recursiveDamerauLevenshteinDistanceGraph = "recursiveDamerauLevenshteinDistance"
        static let recursiveCacheDamerauLevenshteinDistanceGraph = "recursiveCacheDamerauLevenshteinDistance"
        static let nonRecursiveLevenshteinDistanceGraph = "nonRecursiveLevenshteinDistance"

        static let test1_1: String = "a"
        static let test1_2: String = "b"
        static let test2_1: String = "ab"
        static let test2_2: String = "ca"
        static let test3_1: String = "abc"
        static let test3_2: String = "cab"
        static let test4_1: String = "abcd"
        static let test4_2: String = "cabd"
        static let test5_1: String = "abcde"
        static let test5_2: String = "acdef"
        static let test6_1: String = "abcdef"
        static let test6_2: String = "acdeff"
        static let test7_1: String = "abcdefg"
        static let test7_2: String = "abwdegf"
        static let test8_1: String = "abcdefgh"
        static let test8_2: String = "abwdegfh"
        static let test9_1: String = "abcdefghi"
        static let test9_2: String = "abdceegih"
        static let test10_1: String = "abcdefghij"
        static let test10_2: String = "abdceegihj"
    }

    private var timeMeasure: CPUTimeMeasure

    private func saveSVG(_ x: [[Double]], _ y: [[Double]], _ names: [String], colors: [Color]) {

        let svg_renderer: SVGRenderer = SVGRenderer()
        var lineGraph = LineGraph<Double,Double>(enablePrimaryAxisGrid: true)

        for i in 0..<x.count {
            lineGraph.addSeries(x[i], y[i], label: names[i], color: colors[i])
        }

        lineGraph.plotTitle.title = "SINGLE SERIES"
        lineGraph.plotLabel.xLabel = "Length"
        lineGraph.plotLabel.yLabel = "Time, µs"
        lineGraph.plotLineThickness = 3.0
        guard let projectDirectory = FileManager.default.currentDirectoryPath as NSString? else {
            print("Unable to determine the project directory.")
            return
        }
        let filePath = projectDirectory.appendingPathComponent("/graphs/")

        do {
            try lineGraph.drawGraphAndOutput(fileName: filePath, renderer: svg_renderer)
        } catch {
            print(error)
        }
    }

    private func setupDataNonRecursiveDamerauLevenshtein() -> ([Double], [Double]) {
        var y = [Double]()
        let runsCount = timeMeasure.getNumberOfRuns()
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveDamerauLevenshteinDistance(Constants.test1_1, Constants.test1_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveDamerauLevenshteinDistance(Constants.test2_1, Constants.test2_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveDamerauLevenshteinDistance(Constants.test3_1, Constants.test3_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveDamerauLevenshteinDistance(Constants.test4_1, Constants.test4_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveDamerauLevenshteinDistance(Constants.test5_1, Constants.test5_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveDamerauLevenshteinDistance(Constants.test6_1, Constants.test6_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveDamerauLevenshteinDistance(Constants.test7_1, Constants.test7_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveDamerauLevenshteinDistance(Constants.test8_1, Constants.test8_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveDamerauLevenshteinDistance(Constants.test9_1, Constants.test9_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveDamerauLevenshteinDistance(Constants.test10_1, Constants.test10_2), runsCount: runsCount))

        return (x, y)
    }

    private func setupDataRecursiveDamerauLevenshtein() -> ([Double], [Double]) {
        var y = [Double]()
        let runsCount = timeMeasure.getNumberOfRuns()

        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveDamerauLevenshteinDistance(Constants.test1_1, Constants.test1_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveDamerauLevenshteinDistance(Constants.test2_1, Constants.test2_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveDamerauLevenshteinDistance(Constants.test3_1, Constants.test3_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveDamerauLevenshteinDistance(Constants.test4_1, Constants.test4_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveDamerauLevenshteinDistance(Constants.test5_1, Constants.test5_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveDamerauLevenshteinDistance(Constants.test6_1, Constants.test6_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveDamerauLevenshteinDistance(Constants.test7_1, Constants.test7_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveDamerauLevenshteinDistance(Constants.test8_1, Constants.test8_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveDamerauLevenshteinDistance(Constants.test9_1, Constants.test9_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveDamerauLevenshteinDistance(Constants.test10_1, Constants.test10_2), runsCount: runsCount))
        
        return (x, y)
    }

    private func setupDataRecursiveCacheDamerauLevenshtein() -> ([Double], [Double]) {
        var y = [Double]()
        let runsCount = timeMeasure.getNumberOfRuns()

        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveCacheDamerauLevenshteinDistance(Constants.test1_1, Constants.test1_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveCacheDamerauLevenshteinDistance(Constants.test2_1, Constants.test2_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveCacheDamerauLevenshteinDistance(Constants.test3_1, Constants.test3_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveCacheDamerauLevenshteinDistance(Constants.test4_1, Constants.test4_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveCacheDamerauLevenshteinDistance(Constants.test5_1, Constants.test5_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveCacheDamerauLevenshteinDistance(Constants.test6_1, Constants.test6_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveCacheDamerauLevenshteinDistance(Constants.test7_1, Constants.test7_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveCacheDamerauLevenshteinDistance(Constants.test8_1, Constants.test8_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveCacheDamerauLevenshteinDistance(Constants.test9_1, Constants.test9_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .recursiveCacheDamerauLevenshteinDistance(Constants.test10_1, Constants.test10_2), runsCount: runsCount))

        return (x, y)
    }

    private func setupDataRecursiveLevenshtein() -> ([Double], [Double]) {
        var y = [Double]()
        let runsCount = timeMeasure.getNumberOfRuns()

        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveLevenshteinDistance(Constants.test1_1, Constants.test1_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveLevenshteinDistance(Constants.test2_1, Constants.test2_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveLevenshteinDistance(Constants.test3_1, Constants.test3_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveLevenshteinDistance(Constants.test4_1, Constants.test4_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveLevenshteinDistance(Constants.test5_1, Constants.test5_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveLevenshteinDistance(Constants.test6_1, Constants.test6_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveLevenshteinDistance(Constants.test7_1, Constants.test7_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveLevenshteinDistance(Constants.test8_1, Constants.test8_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveLevenshteinDistance(Constants.test9_1, Constants.test9_2), runsCount: runsCount))
        y.append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .nonRecursiveLevenshteinDistance(Constants.test10_1, Constants.test10_2), runsCount: runsCount))

        return (x, y)
    }

    // MARK: - Public

    public func drawGraphs() {
        var x = [[Double]]()
        var y = [[Double]]()

        // print("setupDataNonRecursiveDamerauLevenshtein\n")
        // var result = setupDataNonRecursiveDamerauLevenshtein()
        // x.append(result.0)
        // y.append(result.1)
        // print("setupDataRecursiveDamerauLevenshtein\n")
        // result = setupDataRecursiveDamerauLevenshtein()
        // x.append(result.0)
        // y.append(result.1)
        // print("setupDataRecursiveCacheDamerauLevenshtein\n")
        // result = setupDataRecursiveCacheDamerauLevenshtein()
        // x.append(result.0)
        // y.append(result.1)
        // print("setupDataRecursiveLevenshtein\n")
        // result = setupDataRecursiveLevenshtein()
        // x.append(result.0)
        // y.append(result.1)

        let values = [
            [5.34, 6.36, 9.77, 14.53, 20.01, 27.45, 37.65, 41.71, 53.43, 60.68],
            [2.07, 10.5, 56.51, 260.07, 1326.0, 7144.42, 40259.13, 216130.7, 1222987.56, 6645267.38],
            [2.35, 7.48, 17.92, 34.84, 59.86, 95.41, 139.13, 196.03, 259.02, 336.62],
            [3.28, 5.16, 7.67, 11.41, 14.91, 19.84, 25.9, 30.66, 37.63, 46.45]
        ]

        for i in 0..<4 {
            x.append(self.x)
            y.append(values[i])
        }

        saveSVG(x, y, [
            Constants.nonRecursiveDamerauLevenshteinDistanceGraph,
            Constants.recursiveDamerauLevenshteinDistanceGraph,
            Constants.recursiveCacheDamerauLevenshteinDistanceGraph,
            Constants.nonRecursiveLevenshteinDistanceGraph
        ], colors: [
            .blue,
            .gold,
            .red,
            .green
        ])
    }

    // MARK: - LifeCycle

    public init(_ timeMeasure: CPUTimeMeasure = CPUTimeMeasure(100)) {
        self.timeMeasure = timeMeasure
    }
}