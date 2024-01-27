import Foundation
import SwiftPlot
import SVGRenderer

public class GraphRenderer {

    // MARK: - Private
    
    private enum Constants {
        static let standartMultiply = "Standart Multiply"
        static let vinogradMultiply = "Vinograd Multiply"
        static let vinogradOptimized = "Vinograd Optimized Multiply"
    }


    private let xEven: [Double] = Array(stride(from: 4.0, to: 100.1, by: 6.0))
    private let xOdd: [Double] = Array(stride(from: 5.0, to: 102.1, by: 6.0))

    private var timeMeasure: CPUTimeMeasure
    
    func saveDataToCSV(x: [Double], y: [[Double]], filePath: String) {
        var csvText = "len,standard,vinograd,opt_vinograd\n"
        
        for i in 0..<x.count {
            let row = "\(x[i]),\(y[0][i]),\(y[1][i]),\(y[2][i])\n"
            csvText.append(row)
        }
        
        do {
            try csvText.write(toFile: filePath, atomically: true, encoding: .utf8)
            print("Data saved to CSV file: \(filePath)")
        } catch {
            print("Error writing to CSV file: \(error)")
        }
    }


    private func saveSVG(_ x: [[Double]], _ y: [[Double]], _ names: [String], colors: [Color], filename: String) {

        let svg_renderer: SVGRenderer = SVGRenderer()
        var lineGraph = LineGraph<Double,Double>(enablePrimaryAxisGrid: true)
        
        for i in 0..<x.count {
            lineGraph.addSeries(x[i].map({$0 * $0}), y[i], label: names[i], color: colors[i])
        }

        lineGraph.plotTitle.title = "Умножение матриц"
        lineGraph.plotLabel.xLabel = "Количество элементов"
        lineGraph.plotLabel.yLabel = "Время, мкс"
        lineGraph.plotLineThickness = 3.0
        guard let projectDirectory = FileManager.default.currentDirectoryPath as NSString? else {
            print("Unable to determine the project directory.")
            return
        }
        let filePath = projectDirectory.appendingPathComponent("/\(filename)/")

        do {
            try lineGraph.drawGraphAndOutput(fileName: filePath, renderer: svg_renderer)
        } catch {
            print(error)
        }
    }
    
    private func generateRandomMatrix(rows: Int, columns: Int, minValue: Int, maxValue: Int) -> [[Int]] {
        var matrix = [[Int]]()
        
        for _ in 0..<rows {
            var row = [Int]()
            for _ in 0..<columns {
                let randomValue = Int(arc4random_uniform(UInt32(maxValue - minValue + 1))) + minValue
                row.append(randomValue)
            }
            matrix.append(row)
        }
        
        return matrix
    }

    // MARK: - Public

    public func drawGraphs() {
        var xAxisEven: [[Double]] = Array(repeating: xEven, count: 3)
        var yAxisEven: [[Double]] = Array(repeating: [], count: 3)

        let runsCount = timeMeasure.getNumberOfRuns()
        
        var xAxisOdd: [[Double]] = Array(repeating: xEven, count: 3)
        var yAxisOdd: [[Double]] = Array(repeating: [], count: 3)

        for number in xOdd {
            print("Odd measure. Current matrix size = \(number)")
            let matrix1 = generateRandomMatrix(rows: Int(number), columns: Int(number), minValue: 0, maxValue: 1000)
            let matrix2 = generateRandomMatrix(rows: Int(number), columns: Int(number), minValue: 0, maxValue: 1000)
            yAxisOdd[0].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .standartMultiply(matrix1, matrix2), runsCount: runsCount))
            yAxisOdd[1].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .vinogradMultiply(matrix1, matrix2), runsCount: runsCount))
            yAxisOdd[2].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .vinogradOptimizedMultiply(matrix1, matrix2), runsCount: runsCount))
            print("Current result: \(String(describing: yAxisOdd[0].last)), \(String(describing: yAxisOdd[1].last)), \(String(describing: yAxisOdd[2].last))")
        }
        
        saveDataToCSV(x: xOdd, y: yAxisOdd, filePath: "dataOdd.csv")

        saveSVG(xAxisOdd, yAxisOdd, [
            Constants.standartMultiply,
            Constants.vinogradMultiply,
            Constants.vinogradOptimized,
        ], colors: [
            .blue,
            .gold,
            .red,
        ], filename: "graphOdd")
        
        
        for number in xEven {
            print("Even measure. Current matrix size = \(number)")
            let matrix1 = generateRandomMatrix(rows: Int(number), columns: Int(number), minValue: 0, maxValue: 1000)
            let matrix2 = generateRandomMatrix(rows: Int(number), columns: Int(number), minValue: 0, maxValue: 1000)
            yAxisEven[0].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .standartMultiply(matrix1, matrix2), runsCount: runsCount))
            yAxisEven[1].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .vinogradMultiply(matrix1, matrix2), runsCount: runsCount))
            yAxisEven[2].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .vinogradOptimizedMultiply(matrix1, matrix2), runsCount: runsCount))
            print("Current result: \(String(describing: yAxisEven[0].last)), \(String(describing: yAxisEven[1].last)), \(String(describing: yAxisEven[2].last))")
        }
        
        saveDataToCSV(x: xEven, y: yAxisEven, filePath: "dataEven.csv")

        saveSVG(xAxisEven, yAxisEven, [
            Constants.standartMultiply,
            Constants.vinogradMultiply,
            Constants.vinogradOptimized,
        ], colors: [
            .blue,
            .gold,
            .red,
        ], filename: "graphEven")
    }

    // MARK: - LifeCycle

    public init(_ timeMeasure: CPUTimeMeasure = CPUTimeMeasure(50)) {
        self.timeMeasure = timeMeasure
    }
}
