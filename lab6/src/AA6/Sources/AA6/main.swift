import Foundation
import Darwin

class TSPSolver {

    // MARK: - Private
    
    private static func inputMatrix() -> [[Int]]? {
        print(Welcome.enterNumberOfCities)
        let numCities = Int(readLine()!)
        guard let numCities else {
            print(Errors.invalidNumberInput)
            return nil
        }
        guard numCities > 0 else {
            print(Errors.belowZero)
            return nil
        }

        var matrix = Array(repeating: Array(repeating: 0, count: numCities), count: numCities)
        for i in 0..<numCities {
            for j in 0..<numCities {
                print("Введите элемент \(i + 1) строки, \(j + 1) столбца: ")
                let value = Int(readLine()!)
                guard let value else {
                    print(Errors.invalidNumberInput)
                    return nil
                }
                matrix[i][j] = value
            }
        }

        return matrix
    }
    
    private static func printMenu() {
        print("\nМеню:")
        print("1. Решение задачи коммивояжёра")
        print("2. Измерить время")
        print("3. Построить графики")
        print("0. Выйти")
        print("\nВыберите пункт меню: ", terminator: "")
    }
    
    private static func inputParams() -> Params? {
        let matrix = inputMatrix()
        guard let matrix else { return nil }
        
//        print(Welcome.enterNumberOfAnts)
//        let numberOfAnts = Int(readLine()!)
//        guard let numberOfAnts else {
//            print(Errors.invalidNumberInput)
//            return nil
//        }
        print(Welcome.enterEvaporationRate)
        let evaporationRate = Double(readLine()!)
        guard let evaporationRate else {
            print(Errors.invalidNumberInput)
            return nil
        }
        print(Welcome.enterAlpha)
        let alpha = Double(readLine()!)
        guard let alpha else {
            print(Errors.invalidNumberInput)
            return nil
        }
//        print(Welcome.enterBeta)
//        let beta = Double(readLine()!)
//        guard let beta else {
//            print(Errors.invalidNumberInput)
//            return nil
//        }
        print(Welcome.enterEliteMultiplier)
        let elitePheromoneMultiplier = Double(readLine()!)
        guard let elitePheromoneMultiplier else {
            print(Errors.invalidNumberInput)
            return nil
        }
        print(Welcome.enterIterations)
        let iterations = Int(readLine()!)
        guard let iterations else {
            print(Errors.invalidNumberInput)
            return nil
        }
        
        return Params(distanceMatrix: matrix, numberOfAnts: 10, evaporationRate: evaporationRate, alpha: alpha, beta: 1 - alpha, elitePheromoneMultiplier: elitePheromoneMultiplier, iterations: iterations)
    }

    // MARK: - Public

    public static func execute() {
        while true {
            printMenu()
            guard let choice = readLine(), let option = Int(choice) else { 
                print(Errors.invalidOptionInput)
                continue
            }
            switch option {
            case 1:
                guard let params = inputParams() else {
                    print(Errors.invalidNumberInput)
                    continue
                }
                
                let result1 = Algorithms.execute(.bruteForce(params: params))
                let result2 = Algorithms.execute(.antAlgorithm(params: params))
                
                guard let result1, let result2 else { continue }
                
                print(Constants.bruteForce)
                print("Расстояние: \(result1.distance), путь: \(result1.path)")
                print(Constants.antAlgorithm)
                print("Расстояние: \(result2.distance), путь: \(result2.path)")

            case 2:
                guard let params = inputParams() else {
                    print(Errors.invalidNumberInput)
                    continue
                }

                print(Processing.measuringTime)
                CPUTimeMeasure().measureCPUTime(params)

            case 3:
                GraphRenderer().drawGraphs()

            case 0:
                return

            default:
                print(Errors.invalidChoice)
            }
        }
    }
}

extension TSPSolver {
    private enum Constants {
        static let bruteForce = "Полный перебор"
        static let antAlgorithm = "Муравьиный алгоритм"
    }
    
    private enum Welcome {
        static let inputMatrix = "Введите матрицу смежности:"
        static let enterNumberOfCities = "Введите количество городов"
        static let enterNumberOfAnts = "Введите количество муравьев"
        static let enterEvaporationRate = "Введите коэффициент испарения ферамонов"
        static let enterAlpha = "Введите коэффициент alpha"
        static let enterBeta = "Введите коэффициент beta"
        static let enterEliteMultiplier = "Введите коэффициент усиления элитным муравьем"
        static let enterIterations = "Введите количество дней"
    }
    
    private enum Processing {
        static let measuringTime = "Измеряется время работы алгоритмов:"
    }

    private enum Errors {
        static let invalidNumberInput = "Некорректный ввод."
        static let invalidOptionInput = "Некорректный ввод. Введите корректный вариант"
        static let belowZero = "Введите положительное число"
        static let invalidChoice = "Некорректный ввод, попробуйте еще раз."
    }
}

TSPSolver.execute()
