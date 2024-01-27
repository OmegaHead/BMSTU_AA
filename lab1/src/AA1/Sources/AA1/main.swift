import Foundation
import Darwin

class LevenshteinDistance {

    // MARK: - Private

    private enum Constants {
        static let nonRecursiveDamerauLevenshteinDistance = "Non Recursive Damerau-Levenshtein Distance Algorithm"
        static let recursiveDamerauLevenshteinDistance = "Recursive Damerau-Levenshtein Distance Algorithm"
        static let recursiveCacheDamerauLevenshteinDistance = "Recursive Cache Damerau-Levenshtein Distance Algorithm"
        static let nonRecursiveLevenshteinDistance = "Non recursive Levenshtein Distance Algorithm"
    }

    private enum Welcome {
        static let enterFirstString = "Enter the first string:"
        static let enterSecondString = "Enter the second string:"
    }

    private enum Processing {
        static let calculatingDistances = "Calculating Levenshtein distances:"
        static let measuringTime = "Measuring CPU time for algorithms:"
    }

    private enum Errors {
        static let invalidStringInput = "Invalid input. Please enter a valid string."
        static let invalidOptionInput = "Invalid input. Please enter a valid option."
        static let invalidChoice = "Invalid choice. Please try again."
    }

    private static func printMenu() {
        print("\nMenu:")
        print("1. Calculate Levenshtein distance")
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
                print(Welcome.enterFirstString)
                let s1 = readLine() ?? ""
                print(Welcome.enterSecondString)
                let s2 = readLine() ?? ""
                print(Processing.calculatingDistances)
                
                let distance1 = Algorithms.execute(.nonRecursiveDamerauLevenshteinDistance(s1, s2, print: true))
                let distance2 = Algorithms.execute(.recursiveDamerauLevenshteinDistance(s1, s2))
                let distance3 = Algorithms.execute(.recursiveCacheDamerauLevenshteinDistance(s1, s2, print: true))
                let distance4 = Algorithms.execute(.nonRecursiveLevenshteinDistance(s1, s2, print: true))

                print(Constants.nonRecursiveDamerauLevenshteinDistance, "  : \(distance1)")
                print(Constants.recursiveDamerauLevenshteinDistance, "      : \(distance2)")
                print(Constants.recursiveCacheDamerauLevenshteinDistance, ": \(distance3)")
                print(Constants.nonRecursiveLevenshteinDistance, "          : \(distance4)")

            case 2:
                print(Welcome.enterFirstString)
                let s1 = readLine() ?? ""
                print(Welcome.enterSecondString)
                let s2 = readLine() ?? ""

                print(Processing.measuringTime)
                CPUTimeMeasure().measureCPUTime(s1, s2)

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

LevenshteinDistance.execute()
