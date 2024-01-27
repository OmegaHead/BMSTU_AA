import Foundation
import SwiftPlot
import SVGRenderer

public class GraphRenderer {

    // MARK: - Private
    
    private enum Constants {
        static let pancakeSort = "Pancake sort"
        static let radixSort = "Radix sort"
        static let treeSort = "Binary tree sort"
    }

    private let x: [Double] = Array(stride(from: 1.0, to: 1000, by: 100.0))

    private var timeMeasure: CPUTimeMeasure
    
    func saveDataToCSV(x: [Double], y: [[Double]], filePath: String) {
        var csvText = "len,pancake,radix,tree\n"
        
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
            lineGraph.addSeries(x[i], y[i], label: names[i], color: colors[i])
        }

        lineGraph.plotTitle.title = "Умножение матриц"
        lineGraph.plotLabel.xLabel = "Количество элементов"
        lineGraph.plotLabel.yLabel = "Время, мкс"
        lineGraph.plotLineThickness = 3.0
        guard let projectDirectory = FileManager.default.currentDirectoryPath as NSString? else {
            print("Unable to determine the project directory.")
            return
        }

        do {
            try lineGraph.drawGraphAndOutput(fileName: filename, renderer: svg_renderer)
        } catch {
            print(error)
        }
    }
    
    private func generateRandomArray(len: Int, minValue: Int = 0, maxValue: Int = 1000) -> [Int] {
        var arr = [Int]()
        
        for _ in 0..<len {
            let randomValue = Int(arc4random_uniform(UInt32(maxValue - minValue + 1))) + minValue
            arr.append(randomValue)
        }
        
        return arr
    }

    // MARK: - Public

    public func drawGraphs() {
        let x: [[Double]] = Array(repeating: self.x, count: 3)
        var yRandom: [[Double]] = Array(repeating: [], count: 3)

        let runsCount = timeMeasure.getNumberOfRuns()

        for number in self.x {
            print("Current size = \(number)")
            let arr = generateRandomArray(len: Int(number))
            yRandom[0].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .pancakeSort, arr, runsCount: runsCount))
            yRandom[1].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .radixSort, arr, runsCount: runsCount))
            yRandom[2].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .binaryTreeSort, arr, runsCount: runsCount))
            print("Current result: \(String(describing: yRandom[0].last)), \(String(describing: yRandom[1].last)), \(String(describing: yRandom[2].last))")
        }
        
        saveDataToCSV(x: self.x, y: yRandom, filePath: "/Users/omega/Desktop/BMSTU/SEM5/AA/lab3git/chmd21u350/src/AA3/Sources/AA3/random.csv")

        saveSVG(x, yRandom, [
            Constants.pancakeSort,
            Constants.radixSort,
            Constants.treeSort,
        ], colors: [
            .blue,
            .gold,
            .red,
        ], filename: "/Users/omega/Desktop/BMSTU/SEM5/AA/lab3git/chmd21u350/src/AA3/Sources/AA3/random")
        
        var ySorted: [[Double]] = Array(repeating: [], count: 3)

        for number in self.x {
            print("Current size = \(number)")
            let arr: [Int] = Array(stride(from: 0, to: Int(number), by: 1))
            ySorted[0].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .pancakeSort, arr, runsCount: runsCount))
            ySorted[1].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .radixSort, arr, runsCount: runsCount))
            ySorted[2].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .binaryTreeSort, arr, runsCount: runsCount))
            print("Current result: \(String(describing: ySorted[0].last)), \(String(describing: ySorted[1].last)), \(String(describing: ySorted[2].last))")
        }
        
        saveDataToCSV(x: self.x, y: ySorted, filePath: "/Users/omega/Desktop/BMSTU/SEM5/AA/lab3git/chmd21u350/src/AA3/Sources/AA3/sorted.csv")

        saveSVG(x, ySorted, [
            Constants.pancakeSort,
            Constants.radixSort,
            Constants.treeSort,
        ], colors: [
            .blue,
            .gold,
            .red,
        ], filename: "/Users/omega/Desktop/BMSTU/SEM5/AA/lab3git/chmd21u350/src/AA3/Sources/AA3/sorted")
        
        var yBackSorted: [[Double]] = Array(repeating: [], count: 3)

        for number in self.x {
            print("Current size = \(number)")
            let arr: [Int] = Array(stride(from: Int(number), to: 0, by: -1))
            yBackSorted[0].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .pancakeSort, arr, runsCount: runsCount))
            yBackSorted[1].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .radixSort, arr, runsCount: runsCount))
            yBackSorted[2].append(timeMeasure.measureCPUTimeFunc(Algorithms.execute, .binaryTreeSort, arr, runsCount: runsCount))
            print("Current result: \(String(describing: yBackSorted[0].last)), \(String(describing: yBackSorted[1].last)), \(String(describing: yBackSorted[2].last))")
        }
        
        saveDataToCSV(x: self.x, y: yBackSorted, filePath: "/Users/omega/Desktop/BMSTU/SEM5/AA/lab3git/chmd21u350/src/AA3/Sources/AA3/backSorted.csv")

        saveSVG(x, yBackSorted, [
            Constants.pancakeSort,
            Constants.radixSort,
            Constants.treeSort,
        ], colors: [
            .blue,
            .gold,
            .red,
        ], filename: "/Users/omega/Desktop/BMSTU/SEM5/AA/lab3git/chmd21u350/src/AA3/Sources/AA3/backSorted")
    }

    // MARK: - LifeCycle

    public init(_ timeMeasure: CPUTimeMeasure = CPUTimeMeasure(50)) {
        self.timeMeasure = timeMeasure
    }
}
