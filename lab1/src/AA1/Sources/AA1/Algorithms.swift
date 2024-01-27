import Foundation

public enum AlgorithmType {
    case nonRecursiveDamerauLevenshteinDistance(_ s1: String, _ s2: String, print: Bool = false)
    case recursiveDamerauLevenshteinDistance(_ s1: String, _ s2: String)
    case recursiveCacheDamerauLevenshteinDistance(_ s1: String, _ s2: String, print: Bool = false)
    case nonRecursiveLevenshteinDistance(_ s1: String, _ s2: String, print: Bool = false)
}

public class Algorithms {

    // MARK: - Private

    private enum Constants {
        static let nonRecursiveDamerauLevenshteinMatrix = "Non Recursive Damerau-Levenshtein Distance Algorithm Matrix:"
        static let recursiveCacheDamerauLevenshteinMatrix = "Recursive Damerau-Levenshtein Distance Algorithm with cache matrix:"
        static let nonRecursiveLevenshteinMatrix = "Non Recursive Levenshtein Distance Algorithm Matrix:"
    }

    private static func outputMatrix(matrix: [[Int]], s1: String, s2: String) {
        let len1 = s1.count
        let len2 = s2.count 

        let s1 = Array(s1)
        let s2 = Array(s2)

        print("   |   |", terminator: "")
        for char in s2 {
            print(" \(char) |", terminator: "")
        }
        print()

        print("---|---|", terminator: "")
        for _ in s2 {
            print("---|", terminator: "")
        }
        print()

        for i in 0...len1 {
            if i == 0 {
                print("   |", terminator: "")
            } else {
                print(" \(s1[i - 1]) |", terminator: "")
            }

            for j in 0...len2 {
                print(String(format: "%3d|", matrix[i][j]), terminator: "")
            }
            print()
        }
        print()
    }

    private static func nonRecursiveDamerauLevenshteinDistance(_ s1: String, _ s2: String, print isPrinted: Bool = false) -> Int {
        let len1 = s1.count
        let len2 = s2.count

        guard len1 > 0 else { return len2 }
        guard len2 > 0 else { return len1 }

        let s1Array = Array(s1)
        let s2Array = Array(s2)

        var matrix = Array(repeating: Array(repeating: 0, count: len2 + 1), count: len1 + 1)

        for i in 0...len1 {
            matrix[i][0] = i
        }

        for j in 0...len2 {
            matrix[0][j] = j
        }

        for i in 1...len1 {
            for j in 1...len2 {
                let cost = s1Array[i - 1] == s2Array[j - 1] ? 0 : 1

                matrix[i][j] = min(
                    matrix[i - 1][j] + 1,         // Deletion
                    matrix[i][j - 1] + 1,         // Insertion
                    matrix[i - 1][j - 1] + cost   // Replacement
                )

                if i > 1 && j > 1 && s1Array[i - 1] == s2Array[j - 2] && s1Array[i - 2] == s2Array[j - 1] {
                    matrix[i][j] = min(matrix[i][j], matrix[i - 2][j - 2] + cost)  // Transposition
                }
            }
        }

        if isPrinted { 
            print(Constants.nonRecursiveDamerauLevenshteinMatrix)
            outputMatrix(matrix: matrix, s1: s1, s2: s2) 
        }

        return matrix[len1][len2]
    }

    private static func recursiveDamerauLevenshteinDistance(_ s1: [Character], _ s2: [Character], _ len1: Int, _ len2: Int) -> Int {
        guard len1 > 0 else { return len2 }
        guard len2 > 0 else { return len1 }

        let cost = s1[len1 - 1] == s2[len2 - 1] ? 0 : 1

        let deletion = recursiveDamerauLevenshteinDistance(s1, s2, len1 - 1, len2) + 1
        let insertion = recursiveDamerauLevenshteinDistance(s1, s2, len1, len2 - 1) + 1
        let replacement = recursiveDamerauLevenshteinDistance(s1, s2, len1 - 1, len2 - 1) + cost

        var transposition = Int.max

        if len1 > 1 && len2 > 1 && s1[len1 - 1] == s2[len2 - 2] && s1[len1 - 2] == s2[len2 - 1] {
            transposition = recursiveDamerauLevenshteinDistance(s1, s2, len1 - 2, len2 - 2) + cost
        }

        return min(deletion, insertion, replacement, transposition)
    }

    private static func recursiveCacheDamerauLevenshteinDistance(_ s1: [Character], _ s2: [Character], _ len1: Int, _ len2: Int, _ memo: inout [[Int]]) -> Int {

        guard len1 > 0 else { 
            memo[len1][len2] = len2
            return len2 
        }
        guard len2 > 0 else { 
            memo[len1][len2] = len1
            return len1
        }

        guard memo[len1][len2] == -1 else { return memo[len1][len2] }

        let cost = s1[len1 - 1] == s2[len2 - 1] ? 0 : 1

        let deletion = recursiveCacheDamerauLevenshteinDistance(s1, s2, len1 - 1, len2, &memo) + 1
        let insertion = recursiveCacheDamerauLevenshteinDistance(s1, s2, len1, len2 - 1, &memo) + 1
        let substitution = recursiveCacheDamerauLevenshteinDistance(s1, s2, len1 - 1, len2 - 1, &memo) + cost

        var transposition = Int.max

        if len1 > 1 && len2 > 1 && s1[len1 - 1] == s2[len2 - 2] && s1[len1 - 2] == s2[len2 - 1] {
            transposition = recursiveCacheDamerauLevenshteinDistance(s1, s2, len1 - 2, len2 - 2, &memo) + cost
        }

        memo[len1][len2] = min(deletion, insertion, substitution, transposition)

        return memo[len1][len2]
    }

    private static func recursiveCacheDamerauLevenshteinDistance(_ s1: String, _ s2: String, print isPrinted: Bool = false) -> Int {
        let len1 = s1.count
        let len2 = s2.count
        let s1Array: [Character] = Array(s1)
        let s2Array: [Character] = Array(s2)
        var memo = Array(repeating: Array(repeating: -1, count: len2 + 1), count: len1 + 1)
        
        let distance = recursiveCacheDamerauLevenshteinDistance(s1Array, s2Array, s1.count, s2.count, &memo)
        if isPrinted { 
            print(Constants.recursiveCacheDamerauLevenshteinMatrix)
            outputMatrix(matrix: memo, s1: s1, s2: s2) }

        return distance
    }


    private static func nonRecursiveLevenshteinDistance(_ s1: String, _ s2: String, print isPrinted: Bool = false) -> Int {
        let len1 = s1.count
        let len2 = s2.count

        guard len1 > 0 else { return len2 }
        guard len2 > 0 else { return len1 }

        let s1Array = Array(s1)
        let s2Array = Array(s2)

        var matrix = Array(repeating: Array(repeating: 0, count: len2 + 1), count: len1 + 1)

        for i in 0...len1 {
            matrix[i][0] = i
        }

        for j in 0...len2 {
            matrix[0][j] = j
        }

        for i in 1...len1 {
            for j in 1...len2 {
                let cost = s1Array[i - 1] == s2Array[j - 1] ? 0 : 1

                matrix[i][j] = min(
                    matrix[i - 1][j] + 1,         // Deletion
                    matrix[i][j - 1] + 1,         // Insertion
                    matrix[i - 1][j - 1] + cost   // Replacement
                )
            }
        }

        if isPrinted { 
            print(Constants.nonRecursiveLevenshteinMatrix)
            outputMatrix(matrix: matrix, s1: s1, s2: s2) 
        }

        return matrix[len1][len2]
    }

    // MARK: - Public

    public static func execute(_ algorithm: AlgorithmType) -> Int {
        switch algorithm {
        case .nonRecursiveDamerauLevenshteinDistance(let s1, let s2, let print):
            return nonRecursiveDamerauLevenshteinDistance(s1, s2, print: print)
        case .recursiveDamerauLevenshteinDistance(let s1, let s2):
            let s1Array: [Character] = Array(s1)
            let s2Array: [Character] = Array(s2)
            return recursiveDamerauLevenshteinDistance(s1Array, s2Array, s1.count, s2.count)
        case .recursiveCacheDamerauLevenshteinDistance(let s1, let s2, let print):
            return recursiveCacheDamerauLevenshteinDistance(s1, s2, print: print)
        case .nonRecursiveLevenshteinDistance(let s1, let s2, let print):
            return nonRecursiveLevenshteinDistance(s1, s2, print: print)
        }
    }
}
