//: [Previous](@previous)

// Page 3 - Q 1
var items1: [Int] = [1,4,6,2,33,2,1]
func reduceCopy_1(array:[Int]) -> Int {
    
    var result: Int = 0
    
    for item in array {
        result += item
    }
    
    return result
}
var answer1 = reduceCopy_1(array: items1)


// Page 3 - Q 2
var items2: [String] = [
    "12345", "King", "Wang", "The", "Best"
]
func reduceCopy_2(array:[String]) -> Int {
    
    var result: Int = 0
    
    for item in array {
        result += item.count
    }
    
    return result
}
var answer2 = reduceCopy_2(array: items2)


//: [Next](@next)
