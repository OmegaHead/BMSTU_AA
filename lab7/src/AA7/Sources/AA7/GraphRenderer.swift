import Foundation
import SwiftPlot
import SVGRenderer

public class GraphRenderer {

    // MARK: - Private

    func generateHexCode(length: Int) -> String {
        var hexCode = ""

        for _ in 0..<length {
            let randomValue = Int(arc4random_uniform(16)) // Генерируем случайное число от 0 до 15
            let hexDigit = String(format: "%X", randomValue) // Преобразуем число в шестнадцатеричное представление
            hexCode += hexDigit
        }

        return hexCode
    }

    private enum Constants {
        static let standartSearch = "Стандартный поиск"
        static let boyerMooreSearch = "Поиск с использованием алгоритма Бойера-Мура"
    }


    private let x: [Double] = [pow(2, 8), pow(2, 10), pow(2, 12), pow(2, 14), pow(2, 16)]
    private let substringLengths: [Double] = [2, 4, 16, pow(2, 6), pow(2, 8)]
    private var timeMeasure: CPUTimeMeasure
    
    func saveDataToCSV(x: [Double], y: [[Double]], filePath: String) {
        var csvText = "len,standard,boyermoore\n"
        
        for i in 0..<x.count {
            let row = "\(x[i]),\(y[0][i]),\(y[1][i])\n"
            csvText.append(row)
        }
        
        do {
            try csvText.write(toFile: filePath, atomically: true, encoding: .utf8)
            print("Данные сохранены в файл: \(filePath)")
        } catch {
            print("Ошибка записи в файл: \(error)")
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

    // MARK: - Public

    public func drawGraphs() {
        var y: [[Double]] = Array(repeating: [], count: 2)
        let xAxis: [[Double]] = Array(repeating: x, count: 2)
        let runsCount = timeMeasure.getNumberOfRuns()

        for number in x {
            print("Текущая длина = \(number)")
            let string = generateHexCode(length: Int(number))
            let substring = String(repeating: "q", count: 128)

            y[0].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .standartSearch(substring, string), runsCount: runsCount))
            y[1].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .boyerMooreSearch(substring, string), runsCount: runsCount))

            print("Текущее время: \(String(describing: y[0].last)), \(String(describing: y[1].last))")
        }
        
        saveDataToCSV(x: x, y: y, filePath: "/Users/mishachupahin/Desktop/BMSTU/BMSTU_sem5/AA/lab7git/chmd21u350/docs/csv/data_worst.csv")

        var ybest: [[Double]] = Array(repeating: [], count: 2)

        for number in x {
            print("Текущая длина = \(number)")
            let string = generateHexCode(length: Int(number))
            let substring = String(string.prefix(128))

            ybest[0].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .standartSearch(substring, string), runsCount: runsCount))
            ybest[1].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .boyerMooreSearch(substring, string), runsCount: runsCount))

            print("Текущее время: \(String(describing: ybest[0].last)), \(String(describing: ybest[1].last))")
        }

        saveDataToCSV(x: x, y: ybest, filePath: "/Users/mishachupahin/Desktop/BMSTU/BMSTU_sem5/AA/lab7git/chmd21u350/docs/csv/data_best.csv")

        var yavg: [[Double]] = Array(repeating: [], count: 2)

        for number in x {
            print("Текущая длина = \(number)")
            let string = generateHexCode(length: Int(number))
            let substring = generateHexCode(length: 128)

            yavg[0].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .standartSearch(substring, string), runsCount: runsCount))
            yavg[1].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .boyerMooreSearch(substring, string), runsCount: runsCount))

            print("Текущее время: \(String(describing: yavg[0].last)), \(String(describing: yavg[1].last))")
        }

        saveDataToCSV(x: x, y: yavg, filePath: "/Users/mishachupahin/Desktop/BMSTU/BMSTU_sem5/AA/lab7git/chmd21u350/docs/csv/data_avg.csv")
    }

    // MARK: - LifeCycle

    public init(_ timeMeasure: CPUTimeMeasure = CPUTimeMeasure(4)) {
        self.timeMeasure = timeMeasure
    }
}
