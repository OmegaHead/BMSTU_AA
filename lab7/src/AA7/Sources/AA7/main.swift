import Foundation
import Darwin

class Main {

    // MARK: - Private

    private enum Constants {
        static let standartSearch = "Стандартный поиск"
        static let boyerMooreSearch = "Поиск с использованием алгоритма Бойера-Мура"
    }

    private enum Welcome {
        static let enterString = "Введите строку"
        static let enterSubstring = "Введите подстроку"
    }

    private enum Processing {
        static let performingSearch = "Выполняется поиск:"
        static let measuringTime = "Измеряется время: "
    }

    private enum Errors {
        static let invalidOptionInput = "Некорректный ввод. Введите существующую команду."
    }

    private static func printMenu() {
        print("\nМеню:")
        print("1. Выполнить поиск подстроки в строке")
        print("2. Построить графики")
        print("0. Выйти")
        print("\nВыберите команду: ", terminator: "")
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
                print(Welcome.enterString)
                let string = readLine()
                guard let string else { continue }
                print(Welcome.enterSubstring)
                let substring = readLine()
                guard let substring else { continue }
                
                print(Processing.performingSearch)
                
                let result1 = Algorithms.execute(.standartSearch(substring, string))
                let result2 = Algorithms.execute(.boyerMooreSearch(substring, string))
                                                 
                print(Constants.standartSearch)
                print(result1)
                print(Constants.boyerMooreSearch)
                print(result2)

            case 2:
                GraphRenderer().drawGraphs()

            case 0:
                return

            default:
                print(Errors.invalidOptionInput)
            }
        }
    }
}

Main.execute()
