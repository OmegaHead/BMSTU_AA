import Foundation
import SwiftPlot
import SVGRenderer

public class GraphRenderer {

    // MARK: - Private
    
    private let testDistanceMatrix1: [[Int]] = [
        [0, 29, 20, 21, 16, 31, 100, 12, 4, 31],
        [29, 0, 15, 35, 29, 28, 40, 21, 29, 41],
        [20, 15, 0, 18, 26, 14, 43, 21, 39, 40],
        [21, 35, 18, 0, 17, 31, 38, 26, 36, 27],
        [16, 29, 26, 17, 0, 23, 45, 32, 19, 21],
        [31, 28, 14, 31, 23, 0, 27, 15, 25, 37],
        [100, 40, 43, 38, 45, 27, 0, 39, 16, 18],
        [12, 21, 21, 26, 32, 15, 39, 0, 22, 23],
        [4, 29, 39, 36, 19, 25, 16, 22, 0, 26],
        [31, 41, 40, 27, 21, 37, 18, 23, 26, 0]
    ]
    
    private let largeTestDistanceMatrix: [[Int]] = [
        [0, 8200, 6500, 7300, 4800, 9100, 10000, 3200, 4200, 8900],
        [8200, 0, 4500, 9500, 8100, 7900, 9200, 6600, 8600, 9700],
        [6500, 4500, 0, 6700, 7800, 6400, 9300, 5200, 9100, 9400],
        [7300, 9500, 6700, 0, 6200, 8300, 9600, 7400, 8400, 9300],
        [4800, 8100, 7800, 6200, 0, 7200, 9800, 8500, 5500, 5700],
        [9100, 7900, 6400, 8300, 7200, 0, 7900, 6300, 7300, 8600],
        [10000, 9200, 9300, 9600, 9800, 7900, 0, 9700, 6400, 6700],
        [3200, 6600, 5200, 7400, 8500, 6300, 9700, 0, 6800, 7200],
        [4200, 8600, 9100, 8400, 5500, 7300, 6400, 6800, 0, 7500],
        [8900, 9700, 9400, 9300, 5700, 8600, 6700, 7200, 7500, 0]
    ]

    private let x: [Double] = Array(stride(from: 1.0, to: 8.1, by: 1))

    private var timeMeasure: CPUTimeMeasure
    
    func saveDataToCSV(x: [Double], y: [[Double]], filePath: String) {
        var csvText = "len,bruteforce,ant\n"
        
        for i in 0..<x.count {
            let row = "\(x[i]),\(y[0][i]),\(y[1][i])\n"
            csvText.append(row)
        }
        
        do {
            try csvText.write(toFile: filePath, atomically: true, encoding: .utf8)
            print("Данные сохранены в файл: \(filePath)")
        } catch {
            print("Ошибка во время записи в файл: \(error)")
        }
    }
    
    func testParamsSaveDataToCSV(data: [[Double]], filePath: String) {
        var csvText = "alpha,r,days,elite,distance,mistake\n"
        
        for i in 0..<data.count {
            let row = "\(String(format: "%.2f", data[i][0])),\(String(format: "%.2f", data[i][1])),\(String(format: "%.2f", data[i][2])),\(String(format: "%.2f", data[i][3])),\(String(format: "%.2f", data[i][4])),\(String(format: "%.2f", data[i][5]))\n"
            csvText.append(row)
        }
        
        do {
            try csvText.write(toFile: filePath, atomically: true, encoding: .utf8)
            print("Данные сохранены в файл: \(filePath)")
        } catch {
            print("Ошибка во время записи в файл: \(error)")
        }
    }


    private func saveSVG(_ x: [[Double]], _ y: [[Double]], _ names: [String], colors: [Color], filename: String) {

        let svg_renderer: SVGRenderer = SVGRenderer()
        var lineGraph = LineGraph<Double,Double>(enablePrimaryAxisGrid: true)

        for i in 0..<x.count {
            lineGraph.addSeries(x[i], y[i], label: names[i], color: colors[i])
        }

        lineGraph.plotTitle.title = "Умножение матриц"
        lineGraph.plotLabel.xLabel = "Количество элементов"
        lineGraph.plotLabel.yLabel = "Время, мкс"
        lineGraph.plotLineThickness = 3.0
        guard (FileManager.default.currentDirectoryPath as NSString?) != nil else {
            print("Unable to determine the project directory.")
            return
        }

        do {
            try lineGraph.drawGraphAndOutput(fileName: filename, renderer: svg_renderer)
        } catch {
            print(error)
        }
    }
    
    func generateRandomDistanceMatrix(size: Int) -> [[Int]] {
        var matrix: [[Int]] = []

        for _ in 0..<size {
            var row: [Int] = []
            for _ in 0..<size {
                row.append(Int.random(in: 1...100))
            }
            matrix.append(row)
        }

        return matrix
    }

    // MARK: - Public

    public func drawGraphs() {
        let x: [[Double]] = Array(repeating: self.x, count: 2)
        var y: [[Double]] = Array(repeating: [], count: 2)

        let runsCount = timeMeasure.getNumberOfRuns()

        for number in self.x {
            print("Текущий размер матрицы равен \(number)")
            let distanceMatrix = generateRandomDistanceMatrix(size: Int(number))
            let params = Params(distanceMatrix: distanceMatrix, numberOfAnts: 10, evaporationRate: 0.5, alpha: 0.5, beta: 0.5, elitePheromoneMultiplier: 2, iterations: 10)
            y[0].append(timeMeasure.measureCPUTimeFunc(.bruteForce(params: params), runsCount: runsCount))
            y[1].append(timeMeasure.measureCPUTimeFunc(.antAlgorithm(params: params), runsCount: runsCount))
            print("Текущий результат равен: \(String(describing: y[0].last)), \(String(describing: y[1].last))")
        }
        
        saveDataToCSV(x: self.x, y: y, filePath: "/Users/omega/Desktop/BMSTU/SEM5/AA/lab6/docs/img/data.csv")

        saveSVG(x, y, [
            Constants.bruteForce,
            Constants.antAlgorithm,
        ], colors: [
            .blue,
            .gold,
        ], filename: "/Users/omega/Desktop/BMSTU/SEM5/AA/lab6/docs/img/graph")
        
        let params = Params(distanceMatrix: largeTestDistanceMatrix, numberOfAnts: 10, evaporationRate: 0.5, alpha: 1, beta: 2, elitePheromoneMultiplier: 2, iterations: 10)
        let expectedResult = Algorithms.execute(.bruteForce(params: params))
        guard let expectedResult else { return }
        var paramsData: [[Double]] = []
        
        for alpha in Array(stride(from: 0, through: 1.01, by: 0.1)) {
            for evaporationRate in Array(stride(from: 0, through: 0.701, by: 0.1)) {
                for days in [1, 5, 10, 50, 100] {
                    for elite in Array(stride(from: 0, through: 2.01, by: 0.1)) {
                        print("alpha: \(alpha) / 1.0, r: \(evaporationRate) / 0.7, days: \(days) / 100, elite: \(elite) / 2.0", terminator: "\r")
                        let testParams = Params(distanceMatrix: largeTestDistanceMatrix, numberOfAnts: 10, evaporationRate: evaporationRate, alpha: alpha, beta: 1 - alpha, elitePheromoneMultiplier: elite, iterations: days)
                        let result = Algorithms.execute(.antAlgorithm(params: testParams))
                        let row: [Double] = [alpha, evaporationRate, Double(days), elite, Double(result?.distance ?? 0), Double(expectedResult.distance - (result?.distance ?? 0))]
                        if expectedResult.distance - (result?.distance ?? 0) == 0 {
                            paramsData.append(row)
                        }
                    }
                }
            }
        }
        testParamsSaveDataToCSV(data: paramsData, filePath: "/Users/omega/Desktop/BMSTU/SEM5/AA/lab6/docs/csv/paramsdata2best.csv")
    }

    // MARK: - LifeCycle

    public init(_ timeMeasure: CPUTimeMeasure = CPUTimeMeasure(50)) {
        self.timeMeasure = timeMeasure
    }
}


extension GraphRenderer {
    private enum Constants {
        static let bruteForce = "Полный перебор"
        static let antAlgorithm = "Муравьиный алгоритм"
    }
}
