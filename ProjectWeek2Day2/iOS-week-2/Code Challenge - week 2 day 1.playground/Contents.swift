//: Playground - noun: a place where people can play

import UIKit

var numbers = ["one","two","three", "four"]

var reversedNumbers = [String]()


func reversingArray()
{
    for var arrayIndex = numbers.count - 1; arrayIndex >= 0; arrayIndex-- {
    reversedNumbers.append(numbers[arrayIndex])
    }
}

reversingArray()

//numbers.count -1 is making it so that it is counting the items in my array starting from 0-3 instead of 1-4. arrayIndex-- means going down the array by one each time. 

