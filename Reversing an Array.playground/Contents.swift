//: Playground - noun: a place where people can play

import UIKit

func reverseArray<T>(array: [T]) -> [T] {
    
    var returnArray = [T]()
    for item in array {
        returnArray.insert(item, atIndex: 0)
    }
    return returnArray
}

var testInt: [Int] = [1,2,34,5,6,77,88,99,]
var testString: [String] = ["A", "B", "C", "D", "E", "F"]

reverseArray(testInt)
reverseArray(testString)






