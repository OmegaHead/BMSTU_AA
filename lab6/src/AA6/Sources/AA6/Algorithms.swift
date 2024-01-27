import Foundation

public struct Params {
    let distanceMatrix: [[Int]]
    let numberOfAnts: Int
    let evaporationRate: Double
    let alpha: Double
    let beta: Double
    let elitePheromoneMultiplier: Double
    let iterations: Int
}

public enum AlgorithmType {
    case bruteForce(params: Params)
    case antAlgorithm(params: Params)
}

public class Algorithms {

    private static func bruteForce(distanceMatrix: [[Int]]) -> (path: [Int], distance: Int)? {
        var minDistance = Int.max
        var bestPath: [Int] = []

        // Генерируем все возможные перестановки городов
        var currentPath: [Int] = Array(0..<distanceMatrix.count)
        repeat {
            let currentDistance = calculatePathDistance(path: currentPath, distanceMatrix: distanceMatrix)
            if currentDistance < minDistance {
                minDistance = currentDistance
                bestPath = currentPath
            }
        } while next_permutation(&currentPath)

        // Возвращаем лучший найденный маршрут и его длину
        return (bestPath, minDistance)
    }

    private static func calculatePathDistance(path: [Int], distanceMatrix: [[Int]]) -> Int {
        var distance = 0
        for i in 0..<path.count - 1 {
            distance += distanceMatrix[path[i]][path[i + 1]]
        }
        distance += distanceMatrix[path.last!][path.first!]
        return distance
    }

    // Генерация следующей перестановки массива
    private static func next_permutation(_ a: inout [Int]) -> Bool {
        var i = a.count - 2
        while (i >= 0 && a[i] >= a[i + 1]) {
            i -= 1
        }

        if i < 0 {
            return false
        }

        var j = a.count - 1
        while a[j] <= a[i] {
            j -= 1
        }

        a.swapAt(i, j)

        var left = i + 1
        var right = a.count - 1

        while left < right {
            a.swapAt(left, right)
            left += 1
            right -= 1
        }

        return true
    }
    
    

    // MARK: - Public

    public static func execute(_ algorithm: AlgorithmType) -> (path: [Int], distance: Int)? {
        switch algorithm {
        case let .bruteForce(params):
            return self.bruteForce(distanceMatrix: params.distanceMatrix)
        case let .antAlgorithm(params):
            return AntColony(
                distanceMatrix: params.distanceMatrix,
                numberOfAnts: params.numberOfAnts,
                evaporationRate: params.evaporationRate,
                alpha: params.alpha,
                beta: params.beta,
                elitePheromoneMultiplier: params.elitePheromoneMultiplier
            ).runAntColony(iterations: params.iterations)
        }
    }
}

class AntColony {
    let distanceMatrix: [[Int]]
    let numberOfAnts: Int
    let evaporationRate: Double
    let alpha: Double
    let beta: Double
    let elitePheromoneMultiplier: Double
    var pheromoneMatrix: [[Double]]

    init(distanceMatrix: [[Int]], numberOfAnts: Int, evaporationRate: Double, alpha: Double, beta: Double, elitePheromoneMultiplier: Double) {
        self.distanceMatrix = distanceMatrix
        self.numberOfAnts = numberOfAnts
        self.evaporationRate = evaporationRate
        self.alpha = alpha
        self.beta = beta
        self.elitePheromoneMultiplier = elitePheromoneMultiplier

        // Инициализация матрицы феромонов
        self.pheromoneMatrix = Array(repeating: Array(repeating: 1.0, count: distanceMatrix.count), count: distanceMatrix.count)
    }

    func runAntColony(iterations: Int) -> (path: [Int], distance: Int)? {
        var globalBestPath: [Int] = []
        var globalBestDistance = Int.max

        for _ in 0..<iterations {
            var antPaths: [[Int]] = []
            var antDistances: [Int] = []
            for _ in 0..<numberOfAnts {
                let path = generateAntPath()
                let distance = calculatePathDistance(path: path)

                // Обновление лучшего пути текущего муравья
                if distance < globalBestDistance {
                    globalBestPath = path
                    globalBestDistance = distance
                }
                antPaths.append(path)
                antDistances.append(distance)
            }

            updatePheromones(antPaths: antPaths, antDistances: antDistances)

            // Испарение феромонов
            for i in 0..<pheromoneMatrix.count {
                for j in 0..<pheromoneMatrix[i].count {
                    pheromoneMatrix[i][j] *= (1.0 - evaporationRate)
                }
            }

            // Обновление феромонов на лучшем пути
            depositPheromone(path: globalBestPath, amount: elitePheromoneMultiplier / Double(globalBestDistance))
        }

        return (globalBestPath, globalBestDistance)
    }

    func generateAntPath() -> [Int] {
        var path: [Int] = []
        var visited: Set<Int> = []

        // Начальный город
        let startCity = Int.random(in: 0..<distanceMatrix.count)
        path.append(startCity)
        visited.insert(startCity)

        // Построение пути
        for _ in 1..<distanceMatrix.count {
            let nextCity = selectNextCity(currentCity: path.last!, visited: visited)
            path.append(nextCity)
            visited.insert(nextCity)
        }

        return path
    }

    func selectNextCity(currentCity: Int, visited: Set<Int>) -> Int {
        let pheromoneValues = pheromoneMatrix[currentCity]

        // Вычисление вероятностей выбора следующего города
        var probabilities: [Double] = []
        for (index, pheromone) in pheromoneValues.enumerated() {
            if !visited.contains(index) {
                let visibility = 1.0 / Double(distanceMatrix[currentCity][index])
                let probability = pow(pheromone, alpha) * pow(visibility, beta)
                probabilities.append(probability)
            } else {
                probabilities.append(0.0)
            }
        }

        // Выбор следующего города на основе вероятностей
        let totalProbability = probabilities.reduce(0, +)
        let randomValue = Double.random(in: 0.0..<totalProbability)
        var cumulativeProbability = 0.0

        for (index, probability) in probabilities.enumerated() {
            if !visited.contains(index) {
                cumulativeProbability += probability
                if cumulativeProbability >= randomValue {
                    return index
                }
            }
        }

        // В случае ошибки возвращаем последний посещенный город
        return visited.first!
    }

    func calculatePathDistance(path: [Int]) -> Int {
        var distance = 0
        for i in 0..<path.count - 1 {
            distance += distanceMatrix[path[i]][path[i + 1]]
        }
        distance += distanceMatrix[path.last!][path.first!]
        return distance
    }

    func depositPheromone(path: [Int], amount: Double) {
        for i in 0..<path.count - 1 {
            pheromoneMatrix[path[i]][path[i + 1]] += amount
            pheromoneMatrix[path[i + 1]][path[i]] += amount
        }
        pheromoneMatrix[path.last!][path.first!] += amount
        pheromoneMatrix[path.first!][path.last!] += amount
    }

    func updatePheromones(antPaths: [[Int]], antDistances: [Int]) {
        for i in 0..<pheromoneMatrix.count {
            for j in 0..<pheromoneMatrix[i].count {
                var pheromoneDeposit = 0.0
                for k in 0..<antPaths.count {
                    if antPaths[k].contains(i) && antPaths[k].contains(j) {
                        pheromoneDeposit += 1.0 / Double(antDistances[k])
                    }
                }
                pheromoneMatrix[i][j] += pheromoneDeposit
                pheromoneMatrix[j][i] += pheromoneDeposit
            }
        }
    }
}
