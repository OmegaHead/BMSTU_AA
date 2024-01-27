import Foundation

public enum AlgorithmType {
    case standartSearch(_ substring: String, _ string: String)
    case boyerMooreSearch(_ substring: String, _ string: String)
}

public class Algorithms {

    // MARK: - Private

    private static func standartSearch(of substring: String, in string: String) -> [Int] {
        var occurrences: [Int] = []
        let stringArray = Array(string)
        let stringCount = string.count
        let substringCount = substring.count

        guard stringCount >= substringCount else {
            return occurrences
        }

        for i in 0...(stringCount - substringCount) {
            let currentSubstring = String(stringArray[i..<(i+substringCount)])

            if currentSubstring == substring {
                occurrences.append(i)
            }
        }

        return occurrences
    }

    private static func boyerMooreSearch(of pattern: String, in text: String) -> [Int] {
        let m = pattern.count
        let n = text.count

        guard m > 0 && n >= m else {
            return []
        }

        var resultIndices: [Int] = []

        // Создаем таблицу сдвигов
        var badCharacterTable: [Character: Int] = [:]
        for (i, char) in pattern.enumerated() {
            badCharacterTable[char] = max(1, m - i - 1)
        }

        // Находим суффикс-префикс массив
        var suffixTable = Array(repeating: 0, count: m)
        var i = m - 1
        var j = m - 2

        while i >= 0 {
            while j >= 0 && pattern[pattern.index(pattern.startIndex, offsetBy: i)] !=
                pattern[pattern.index(pattern.startIndex, offsetBy: j)] {
                j -= 1
            }

            suffixTable[i] = m - 1 - j
            i -= 1
            j = m - 2
        }

        // Поиск
        var iText = m - 1

        while iText < n {
            var iPattern = m - 1
            var k = iText

            while iPattern >= 0 && pattern[pattern.index(pattern.startIndex, offsetBy: iPattern)] ==
                text[text.index(text.startIndex, offsetBy: k)] {
                iPattern -= 1
                k -= 1
            }

            if iPattern < 0 {
                // Найдено совпадение
                resultIndices.append(k + 1)
                iText += m
            } else {
                // Сдвигаем паттерн
                let badCharShift = badCharacterTable[text[text
                    .index(text.startIndex, offsetBy: k)]] ?? m
                let suffixShift = suffixTable[iPattern]
                iText += max(badCharShift, suffixShift)
            }
        }

        return resultIndices
    }

    // MARK: - Public

    public static func execute(_ algorithm: AlgorithmType) -> [Int] {
        switch algorithm {
        case .standartSearch(let substring, let string):
            return standartSearch(of: substring, in: string)
        case .boyerMooreSearch(let substring, let string):
            return boyerMooreSearch(of: substring, in: string)
        }
    }
}
