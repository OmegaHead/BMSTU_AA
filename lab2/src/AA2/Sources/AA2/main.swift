import Foundation
import Darwin

class MatrixMultiply {

    // MARK: - Private

    private enum Constants {
        static let standartMultiply = "Standart Multiply"
        static let vinogradMultiply = "Vinograd Multiply"
        static let vinogradOptimized = "Vinograd Optimized Multiply"
    }

    private enum Welcome {
        static let enterNumberOfRows = "Enter number of rows"
        static let enterNumberOfColumns = "Enter number of columns"
        static let enterFirstMatrix = "Enter the first matrix:"
        static let enterSecondMatrix = "Enter the second matrix:"
    }

    private enum Processing {
        static let calculatingMultiplication = "Performing multiplication:"
        static let measuringTime = "Measuring CPU time for algorithms:"
    }

    private enum Errors {
        static let invalidNumberInput = "Invalid input. Please enter a valid value."
        static let invalidOptionInput = "Invalid input. Please enter a valid option."
        static let belowZero = "Enter positive number"
        static let invalidChoice = "Invalid choice. Please try again."
        static let incorrectSize = "Incorrect size of matrices"
    }
    
    private static func inputMatrix() -> [[Int]]? {
        print(Welcome.enterNumberOfRows)
        let numRows = Int(readLine()!)
        guard let numRows else {
            print(Errors.invalidNumberInput)
            return nil
        }
        guard numRows > 0 else {
            print(Errors.belowZero)
            return nil
        }

        print(Welcome.enterNumberOfColumns)
        let numCols = Int(readLine()!)
        guard let numCols else {
            print(Errors.invalidNumberInput)
            return nil
        }
        guard numCols > 0 else {
            print(Errors.belowZero)
            return nil
        }

        var matrix = Array(repeating: Array(repeating: 0, count: numCols), count: numRows)
        for i in 0..<numRows {
            for j in 0..<numCols {
                print("Enter element at row \(i + 1), column \(j + 1): ")
                var value = Int(readLine()!)
                guard let value else {
                    print(Errors.invalidNumberInput)
                    return nil
                }
                matrix[i][j] = value
            }
        }

        return matrix
    }
    
    private static func printMatrix(_ matrix: [[Int]]) {
        for row in matrix {
            for element in row {
                let formattedElement = String(format: "%4d", element)
                print(formattedElement, terminator: " ")
            }
            print()
        }
    }

    private static func printMenu() {
        print("\nMenu:")
        print("1. Multiply matrices")
        print("2. Measure CPU time")
        print("3. Draw graphs")
        print("0. Exit")
        print("\nChoose Menu option: ", terminator: "")
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
                
                print(Welcome.enterFirstMatrix)
                var matrix1 = inputMatrix()
                guard let matrix1 else { continue }
                print(Welcome.enterSecondMatrix)
                var matrix2 = inputMatrix()
                guard let matrix2 else { continue }
                guard matrix1[0].count == matrix2.count else {
                    print(Errors.incorrectSize)
                    continue
                }
                
                print(Processing.calculatingMultiplication)
                
                let result1 = Algorithms.execute(.standartMultiply(matrix1, matrix2))
                let result2 = Algorithms.execute(.vinogradMultiply(matrix1, matrix2))
                let result3 = Algorithms.execute(.vinogradOptimizedMultiply(matrix1, matrix2))
                                                 
                print(Constants.standartMultiply)
                printMatrix(result1)
                print(Constants.vinogradMultiply)
                printMatrix(result2)
                print(Constants.vinogradOptimized)
                printMatrix(result3)

            case 2:
                print(Welcome.enterFirstMatrix)
                var matrix1 = inputMatrix()
                guard let matrix1 else { continue }
                print(Welcome.enterSecondMatrix)
                var matrix2 = inputMatrix()
                guard let matrix2 else { continue }
                guard matrix1[0].count == matrix2.count else {
                    print(Errors.incorrectSize)
                    continue
                }

                print(Processing.measuringTime)
                CPUTimeMeasure().measureCPUTime(matrix1, matrix2)

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

MatrixMultiply.execute()
