/*
 This example demonstrates how to use generics in Swift. Examples are not complicated and
 do not contain an advanced stuff. I may add such examples in the future. For now, its a simple
 demonstration for a people who came from another language or just started learning generics.
 
 Deniss Kaibagarovs, deniss.kaibagarovs@gmail.com
 MIT License
 */

import Foundation

/// A generic function that takes 2 variables and swap them
///
/// - Parameters:
///   - first: first item to swap between
///   - second: secon item to swap between
func swapTwoValues<T>(_ first: inout T, _ second: inout T) {
  let tempFirst = first
  first = second
  second = tempFirst
}

/// Example how to swap a strings
var aString = "Hello"
var bString = "World"
swapTwoValues(&aString, &bString)
print("Swap Strings: \(aString) \(bString)")

/// Example how to swap an ints
var aInt = 1
var bInt = 2
swapTwoValues(&aInt, &bInt)
print("Swap Ints: \(aInt) \(bInt)")


/// A stack (LIFO) that could be used with any type
/// type must be the same for all inner items
struct Stack<SomeClass> {
  var items = [SomeClass]()
  mutating func push(_ item: SomeClass) {
    items.append(item)
  }
  mutating func pop() -> SomeClass? {
    guard !items.isEmpty else {
      return nil
    }
    return items.removeLast()
  }
}

/// Example with string stack
var intStack = Stack<Int>()
intStack.push(1 as Int)
print("Last int item was: \(intStack.pop())")

/// Example with int stack
var stringStack = Stack<String>()
stringStack.push("Hello")
stringStack.push("World")
print("Last string item was: \(stringStack.pop())")


/// This example demonstrates that you could limit generic functions
/// to specific items, for example, items that confirming to a protocol
extension Stack where SomeClass: Equatable {
  mutating func isFirstElement(_ element: SomeClass) -> Bool {
    guard !items.isEmpty else {
      return false
    }
    return items.last! == element
  }
}

let hodor = "Hodor"
let hello = "Hello"
print("If first item is \(hodor)?: \(stringStack.isFirstElement(hodor))")
print("If first item is \(hello)?: \(stringStack.isFirstElement(hello))")
