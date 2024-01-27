import Foundation
import Darwin

class MatrixMultiply {

    // MARK: - Private

    private enum Constants {
        static let pancakeSort = "Pancake sort"
        static let radixSort = "Radix sort"
        static let treeSort = "Binary tree sort"
    }
    
    private enum Welcome {
        static let inputArray = "Enter a list of integers (separated by spaces):"
    }
    
    private enum Processing {
        static let performingSort = "Performing sort:"
        static let measuringTime = "Measuring CPU time for algorithms:"
    }

    private enum Errors {
        static let invalidNumberInput = "Invalid input. Please enter a valid value."
        static let invalidOptionInput = "Invalid input. Please enter a valid option."
        static let belowZero = "Enter positive number"
        static let invalidChoice = "Invalid choice. Please try again."
    }
    
    private static func inputArray() -> [Int] {
        var numbers: [Int] = []

        print(Welcome.inputArray)

        if let input = readLine() {
            let numberStrings = input.split(separator: " ")
            
            for numberString in numberStrings {
                if let number = Int(numberString) {
                    numbers.append(number)
                } else {
                    print(Errors.invalidNumberInput)
                }
            }
        }

        return numbers
    }
    
    private static func printMenu() {
        print("\nMenu:")
        print("1. Sort array")
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
                
                let arr = inputArray()
                guard !arr.isEmpty else { continue }
                
                print(Processing.performingSort)
                
                var arr1 = arr
                var arr2 = arr
                var arr3 = arr
                
                Algorithms.execute(.pancakeSort, &arr1)
                Algorithms.execute(.radixSort, &arr2)
                Algorithms.execute(.binaryTreeSort, &arr3)
                                                 
                print(Constants.pancakeSort)
                print(arr1)
                print(Constants.radixSort)
                print(arr2)
                print(Constants.treeSort)
                print(arr3)

            case 2:
                let arr = inputArray()
                guard !arr.isEmpty else { continue }

                print(Processing.measuringTime)
                CPUTimeMeasure().measureCPUTime(arr)

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
