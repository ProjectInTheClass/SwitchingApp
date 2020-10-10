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

print("Q4")
print(items1.reduce(0){$0 + $1} == answer1)


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

// Answer 5
print("Q5")
print(items2.reduce(0){$0 + $1.count} == answer2)


//: [Next](@next)
