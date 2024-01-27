import Foundation

public enum AlgorithmType {
    case standartMultiply(_ matrix1: [[Int]], _ matrix2: [[Int]])
    case vinogradMultiply(_ matrix1: [[Int]], _ matrix2: [[Int]])
    case vinogradOptimizedMultiply(_ matrix1: [[Int]], _ matrix2: [[Int]])
}

public class Algorithms {

    // MARK: - Private

    private static func standartMultiply(_ matrix1: [[Int]], _ matrix2: [[Int]]) -> [[Int]] {
        
        guard !matrix1.isEmpty && !matrix2.isEmpty else { return [] }
        guard matrix1[0].count == matrix2.count else { return [] }

        let n = matrix1.count
        let m = matrix2.count
        let t = matrix2[0].count

        var res: [[Int]] = Array(repeating: Array(repeating: 0, count: t), count: n)

        for i in 0..<n {
            for j in 0..<t {
                for k in 0..<m {
                    res[i][j] += matrix1[i][k] * matrix2[k][j];
                }
            }
        }
        
        return res;
    }

    private static func vinogradMultiply(_ matrix1: [[Int]], _ matrix2: [[Int]]) -> [[Int]] {

        guard !matrix1.isEmpty && !matrix2.isEmpty else { return [] }
        guard matrix1[0].count == matrix2.count else { return [] }

        let n = matrix1.count
        let m = matrix2.count
        let t = matrix2[0].count
        var res = Array(repeating: Array(repeating: 0, count: t), count: n)
        var rowSum = Array(repeating: 0, count: n)
        var colSum = Array(repeating: 0, count: t)

        for i in 0..<n {
            for j in 0..<(m / 2) {
                rowSum[i] = rowSum[i] + matrix1[i][2 * j] * matrix1[i][2 * j + 1]
            }
        }

        for i in 0..<t {
            for j in 0..<(m / 2) {
                colSum[i] = colSum[i] + matrix2[2 * j][i] * matrix2[2 * j + 1][i]
            }
        }

        for i in 0..<n {
            for j in 0..<t {
                res[i][j] = -rowSum[i] - colSum[j]
                for k in 0..<(m / 2) {
                    res[i][j] = res[i][j] + (matrix1[i][2 * k + 1] + matrix2[2 * k][j]) * (matrix1[i][2 * k] + matrix2[2 * k + 1][j])
                }
            }
        }

        if m % 2 == 1 {
            for i in 0..<n {
                for j in 0..<t {
                    res[i][j] = res[i][j] + matrix1[i][m - 1] * matrix2[m - 1][j]
                }
            }
        }

        return res
    }
    
    private static func vinogradOptimizedMultiply(_ matrix1: [[Int]], _ matrix2: [[Int]]) -> [[Int]] {
        
        guard !matrix1.isEmpty && !matrix2.isEmpty else { return [] }
        guard matrix1[0].count == matrix2.count else { return [] }

        let n = matrix1.count
        let m = matrix2.count
        let t = matrix2[0].count
        let halfm = m / 2
        var res = Array(repeating: Array(repeating: 0, count: t), count: n)
        var rowSum = Array(repeating: 0, count: n)
        var colSum = Array(repeating: 0, count: t)

        for i in 0..<n {
            for j in 0..<halfm {
                rowSum[i] += matrix1[i][j << 1] * matrix1[i][j << 1 + 1]
            }
        }

        for i in 0..<t {
            for j in 0..<halfm {
                colSum[i] += matrix2[j << 1][i] * matrix2[j << 1 + 1][i]
            }
        }

        for i in 0..<n {
            for j in 0..<t {
                res[i][j] = -rowSum[i] - colSum[j]
                for k in 0..<halfm {
                    res[i][j] += (matrix1[i][k << 1 + 1] + matrix2[k << 1][j]) * (matrix1[i][k << 1] + matrix2[k << 1 + 1][j])
                }
            }
        }

        if m % 2 == 1 {
            for i in 0..<n {
                for j in 0..<t {
                    res[i][j] += matrix1[i][m - 1] * matrix2[m - 1][j]
                }
            }
        }

        return res
    }


    // MARK: - Public

    public static func execute(_ algorithm: AlgorithmType) -> [[Int]] {
        switch algorithm {
        case .standartMultiply(let matrix1, let matrix2):
            return standartMultiply(matrix1, matrix2)
        case .vinogradMultiply(let matrix1, let matrix2):
            return vinogradMultiply(matrix1, matrix2)
        case .vinogradOptimizedMultiply(let matrix1, let matrix2):
            return vinogradOptimizedMultiply(matrix1, matrix2)
        }
    }
}
