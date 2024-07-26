//: [Previous](@previous)

import Foundation

var greeting = "Hello, Generics"

//MARK: - 泛型
/*
 • 泛型：将类型参数化，提高代码复用率，减少代码量
 */

func swapValues<T>(_ v1: inout T, _ v2: inout T) {
    (v1, v2) = (v2, v1)
}

var iV1 = 10
var iV2 = 20
swapValues(&iV1, &iV2)

var dV1 = 30.0
var dV2 = 40.0
swapValues(&dV1, &dV2)

struct Date {
    var year = 0, month = 0, day = 0
}
var dd1 = Date(year: 2011, month: 9, day: 10)
var dd2 = Date(year: 2012, month: 10, day: 11)
swapValues(&dd1, &dd2)

//泛型函数赋值给变量，多个泛型参数
func fooGenerics<T1, T2>(_ v1: T1, _ v2: T2) {
    print("fooGenerics v1:\(v1) v2:\(v2)")
}

//注意不能使用类型推导，因为此时编译器不知道参数类型是什么，需要明确指定
var fn: (Int, Double) -> () = fooGenerics
fn(iV1,dV1)

class Stack<T> {
    var elements : [T] = [T]()
    func push(_ element: T) {
        elements.append(element)
    }
    
    func pop() -> T {
        elements.removeLast()
    }
    
    func top() -> T {
        elements.last!
    }
    
    func size() -> Int {
        elements.count
    }
}

var stack = Stack<Int>()
stack.push(11)
stack.push(22)
stack.push(33)
print(stack.top()) // 33
print(stack.pop()) // 33
print(stack.pop()) // 22
print(stack.pop()) // 11
print(stack.size()) // 0

//继承泛型类型的类，子类也必须是泛型类型
class SubStack<T> : Stack<T> {
    
}

//结构体
//struct Stack<E> {
//    var elements = [E]()
//    mutating func push(_ element: E) { elements.append(element) }
//    mutating func pop() -> E { elements.removeLast() }
//    func top() -> E { elements.last! }
//    func size() -> Int { elements.count }
//}

//枚举
//enum Score<T> {
//    case point(T)
//    case grade(String)
//}
//let score0 = Score<Int>.point(100)
//let score1 = Score.point(99)
//let score2 = Score.point(99.5)
//let score3 = Score<Int>.grade("A")

//MARK: - 关联类型（Associated Type）
/*
 • 关联类型作用：给协议中用到的类型定义一个占位名称
 • 协议中可以拥有多个关联类型
 */
protocol Stackable {
    //关联类型
    associatedtype T
    mutating func push(_ element: T)
    mutating func pop() -> T
    func top() -> T
    func size() -> Int
}

class CStack<T>: Stackable {
    //给关联类型设定真实类型,可以推导类型时，可也省略
    //typealias 关联类型 = 真实类型
    typealias T = Int
    
    var elements = [Int]()
    func push(_ element: Int) {
        elements.append(element)
    }
    
    func pop() -> Int {
        elements.removeLast()
    }
    
    func top() -> Int {
        elements.last!
    }
    
    func size() -> Int {
        elements.count
    }
}

var cs = CStack<Int>()
cs.push(1)
cs.push(2)
cs.pop()
cs.size()

//MARK: - 类型约束
//protocol Runnable { }
//class Person { }
//func swapValues<T : Person & Runnable>(_ a: inout T, _ b: inout T) {
//    (a, b) = (b, a)
//}
//
//protocol Stackable {
//    associatedtype Element: Equatable
//}
//class Stack<E : Equatable> : Stackable { typealias Element = E }
//func equal<S1: Stackable, S2: Stackable>(_ s1: S1, _ s2: S2) -> Bool
//where S1.Element == S2.Element, S1.Element : Hashable {
//    return false
//}
//var stack1 = Stack<Int>()
//var stack2 = Stack<String>()
//// error: requires the types 'Int' and 'String' be equivalent
//equal(stack1, stack2)

//MARK: - some
/*
 • 如果协议中有associatedtype,会存在编译期间不能确定关联类型具体类型的错误
    - 1、使用泛型解决
    - 2、使用some关键字解决
        - 2.1、声明一个 some 不透明类型
 */

/*
 any和some关键字：修饰协议
 - any:关键词用于创建存在类型（existential type）,标记的协议更像是一个“盒子”，如果需要知道具体是什么类型，需要先把盒子打开。因此编译期间并不知道具体是什么，需要运行时才知道。
 - some:关键词用于创建不透明类型（opaque type），标记的协议，是一个存在的类型，没有外层的“盒子”，编译期间就已经确定了类型。
 推荐使用some，some性能优于any

 func myFunc(_ p: some MyProtocol) {
     print(p.name)
 }

 func myFunc1<T: MyProtocol>(_ p: T) {
     print(p.name)
 }

 func myFunc2<T>(_ p: T) where T: MyProtocol {
     print(p.name)
 }
 上述三种写法等价
 */

protocol Runnable {
    associatedtype Speed
    var speed: Speed { get }
}
class Person : Runnable {
    var speed: Double { 0.0 }
}
class Car : Runnable {
    var speed: Int { 0 }
}

//编译就会报错:协议Runnable不能用作泛型约束，因为他有Self或关联类型约束
//报错的原因:就是程序在编译期间并不知道协议中的关联类型Speed具体是什么类型。
//func get(_ type: Int) -> Runnable {
//    if 0 == type {
//        return Person()
//    }
//    return Car()
//}

//1、泛型
func get<T: Runnable>(_ type: Int) -> T {
    if 0 == type {
        return Person() as! T
    }
    return Car() as! T
}

//2、some不透明类型（Opaque Type）
func get(_ type: Int) -> some Runnable { Car() }
//2.1 some限制只能返回一种类型，下面返回多种类型，报错
//func get(_ type: Int) -> some Runnable {
//    if 0 == type {
//        return Person()
//    }
//    return Car()
//}

//some除了用在返回值类型上，一般还可以用在属性类型上
//protocol Runnable { associatedtype Speed }
//class Dog : Runnable { typealias Speed = Double }
//class Person {
//    var pet: some Runnable {
//        return Dog()
//    }
//}

//MARK: - 可选项的本质
/*
 可选项：本质是enum类型
 */

//官方定义：
/*
 public enum Optional<Wrapped> : ExpressibleByNilLiteral {
     case none
     case some(Wrapped)
     public init(_ some: Wrapped)
 }
 */

var age: Int? = 10
age = 20
age = nil

//完整形式：
//var age: Optional<Int> = Optional(10)
//// var age: Optional<Int> = .some(10)
//age = .some(20)
//age = .none

//!!!: 可选项在switch中的注意点
switch age {
case let v?:
    print("1", v)
case nil:
    print("2")
}
//正常情况下，case let v，v一定是一个可选类型，和if不一样（if会自动解包)
//如果把v后面加上?，最终得到的v是Int类型，这是一种可选模式匹配，let v?解包可选值age，如果age包含一个值，这个值会被绑定到变量v上
//等价代码
/*
 if let v = age {
     print("1", v)
 } else {
     print("2")
 }
 */

//: [Next](@next)
