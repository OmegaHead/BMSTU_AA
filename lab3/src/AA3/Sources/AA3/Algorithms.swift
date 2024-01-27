import Foundation

public enum AlgorithmType {
    case pancakeSort
    case radixSort
    case binaryTreeSort
}

fileprivate class TreeNode {
    var value: Int
    var left: TreeNode?
    var right: TreeNode?
    
    fileprivate init(value: Int) {
        self.value = value
    }
    
    fileprivate func insert(_ value: Int) {
        if value < self.value {
            if let left = left {
                left.insert(value)
            } else {
                left = TreeNode(value: value)
            }
        } else {
            if let right = right {
                right.insert(value)
            } else {
                right = TreeNode(value: value)
            }
        }
    }
    
    fileprivate func inOrderTraversal(_ result: inout [Int]) {
        left?.inOrderTraversal(&result)
        result.append(value)
        right?.inOrderTraversal(&result)
    }
}

public class Algorithms {

    // MARK: - Private

    private static func findMaxIndex(_ arr: [Int], _ end: Int) -> Int? {
        if end <= 0 || end > arr.count {
            return nil
        }
        
        var maxIndex = 0
        for i in 0..<end {
            if arr[i] > arr[maxIndex] {
                maxIndex = i
            }
        }
        
        return maxIndex
    }

    private static func flip(_ arr: inout [Int], _ k: Int) {
        var i = 0
        var j = k - 1
        while i < j {
            arr.swapAt(i, j)
            i += 1
            j -= 1
        }
    }
    
    private static func pancakeSort(_ arr: inout [Int]) {
        for end in stride(from: arr.count, to: 1, by: -1) {
            if let maxIndex = findMaxIndex(arr, end) {
                if maxIndex != end - 1 {
                    flip(&arr, maxIndex + 1)
                    flip(&arr, end)
                }
            }
        }
    }
    
    private static func getMax(_ arr: [Int]) -> Int {
        var maxVal = arr[0]
        for value in arr {
            if value > maxVal {
                maxVal = value
            }
        }
        return maxVal
    }

    private static func countSort(_ arr: inout [Int], _ exp: Int) {
        let n = arr.count
        var output = Array(repeating: 0, count: n)
        var count = Array(repeating: 0, count: 10)
        
        for i in 0..<n {
            count[(arr[i] / exp) % 10] += 1
        }
        
        for i in 1..<10 {
            count[i] += count[i - 1]
        }
        
        for i in stride(from: n - 1, through: 0, by: -1) {
            let index = (arr[i] / exp) % 10
            output[count[index] - 1] = arr[i]
            count[index] -= 1
        }
        
        for i in 0..<n {
            arr[i] = output[i]
        }
    }

    private static func radixSort(_ arr: inout [Int]) {
        let maxVal = getMax(arr)
        
        var exp = 1
        while maxVal / exp > 0 {
            countSort(&arr, exp)
            exp *= 10
        }
    }

    private static func binaryTreeSort(_ arr: inout [Int]) {
        var root: TreeNode?
        for element in arr {
            if let existingRoot = root {
                existingRoot.insert(element)
            } else {
                root = TreeNode(value: element)
            }
        }
        
        var sortedArray = [Int]()
        root?.inOrderTraversal(&sortedArray)
        
        arr = sortedArray
    }


    // MARK: - Public

    public static func execute(_ algorithm: AlgorithmType,_ arr: inout [Int]) {
        switch algorithm {
        case .pancakeSort:
            self.pancakeSort(&arr)
        case .radixSort:
            self.radixSort(&arr)
        case .binaryTreeSort:
            self.binaryTreeSort(&arr)
        }
    }
}
