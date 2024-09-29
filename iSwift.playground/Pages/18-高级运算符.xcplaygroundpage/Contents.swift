//: [Previous](@previous)

import Foundation

var greeting = "Hello, Operator"

//MARK: - 溢出运算符
//溢出-运行时错误
/*
 var ui = UInt8.max
 ui += 1
 */

/*
 • !!!: &+、&-、&*支持溢出运算
 官方地址:https://docs.swift.org/swift-book/documentation/the-swift-programming-language/advancedoperators/#Overflow-Operators
 当数据溢出时，溢出运算符会自动循环可数范围
 UInt8取值范围：0~255
 */
var uMax = UInt8.max
uMax = uMax &+ 1
print(uMax) // 输出：0

var uMin = UInt8.min
uMin = uMin &- 1
print(uMin) // 输出：255

//MARK: - 运算符重载
/*
 • 运算符重载:类、结构体、枚举可以为现有的运算符提供自定义的实现
 */

//MARK: 运算符+\-
struct Point {
    var x = 0, y = 0
    //+号运算符重载
    static func +(lhs: Point, rhs:Point) -> Point {
        Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    //-号运算符重载
    static func -(lhs: Point, rhs: Point) -> Point {
        Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}

let p1 = Point(x: 10, y: 20)
let p2 = Point(x: 30, y: 40)

let p3 = p1 + p2
print(p3)

let p4 = p3 - p1

//MARK: -(减号前缀)
extension Point {
    //-减号前缀运算符重载
    static prefix func -(v: Point) -> Point {
        Point(x: -v.x, y: -v.y)
    }
}

let p5 = -p4

//MARK: +=\-=
extension Point {
    //+=运算符重载
    static func +=(lhs: inout Point, rhs: Point) {
        lhs = Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    //-=运算符重载
    static func -=(lhs: inout Point, rhs: Point) {
        lhs = Point(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
}

var p6 = Point(x: 1, y: 1)
let p7 = Point(x: 2, y: 2)

p6 += p7
p6 -= p7

//MARK: 前置++\后置++
extension Point {
    //前置++运算符重载
    static prefix func ++(v: inout Point) -> Point {
        v += Point(x: 1, y: 1)
        return v
    }
    
    //后置++运算符重载
    static postfix func ++(v: inout Point) -> Point {
        let tmp = v
        v += Point(x: 1, y: 1)
        return tmp
    }
}

//++写在变量前面：先加后用
var p8 = Point(x: 1, y: 1)
let p9 = ++p8
print(p9)

//++写在变量后面：先用后加
var p10 = Point(x: 10, y: 10)
let p11 = p10++
print("p10:\(p10)","p11:\(p11)") // 输出："p10:Point(x: 11, y: 11) p11:Point(x: 10, y: 10)"

//MARK: !=\==
extension Point {
    //!=运算符重载
    static func !=(lhs: Self, rhs: Self) -> Bool {
        (lhs.x != rhs.x) || (lhs.y != rhs.y)
    }
    
//    //==运算符重载
//    static func ==(lhs: Point, rhs: Point) -> Bool {
//        (lhs.x == rhs.x) || (lhs.y == rhs.y)
//    }
}

let p12 = Point(x: 1, y: 1)
let p13 = Point(x: 1, y: 1)

p12 != p13

//MARK: - Equatable协议
/*
 Equatable:遵守Equatable协议，默认重载 != 运算符，但是自定义 == 运算符不会重载 != 运算符。
 */
extension Point : Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.x == rhs.x && lhs.y == rhs.y
    }
}

let p14 = Point(x: 10, y: 20)
let p15 = Point(x: 20, y: 30)
let isTrue1 = p14 == p15

/*
 • Swift提供默认Equatable实现的类型：
 - 原始值枚举、没有关联类型的枚举
 - 只拥有遵守Equatable协议关联类型的枚举
 - 只拥有遵守Equatable协议存储属性的结构体
 */

//1、原始值枚举
//enum Answer : Int {
//    case wrong
//    case right
//}

//2、没有关联类型的枚举
//enum Answer {
//    case wrong
//    case right
//}
//var a1 = Answer.wrong
//var a2 = Answer.right
//
//a1 == a2

//3、只拥有遵守Equatable协议关联类型的枚举
//enum Answer: Equatable {
//    case wrong(Int)
//    case right
//}
//var s1 = Answer.wrong(10)
//var s2 = Answer.wrong(10)
//print(s1 == s2)

//4、只拥有遵守Equatable协议存储属性的结构体
//struct Point: Equatable {
//    var x = 0, y = 0
//}
//let pp1 = Point(x: 10, y: 20)
//let pp2 = Point(x: 20, y: 30)
//pp1 == pp2

//MARK: - 恒等运算符===、!==
//引用类型比较存储的地址值是否相等（是否引用着同一个对象），使用恒等运算符===,!==（仅限引用类型）。
class Animal { }
var animal1 = Animal()
var animal2 = Animal()
print(animal1 === animal2) // 输出：false
print(animal1 !== animal2) // 输出：true

/*
 == 和 === 的区别（!= 和 !==）
 ==：值比较
 ===：引用比较
 */

//MARK: - Comparable协议
/*
 • 比较2个实例的大小，一般做法是：
 - 遵守Comparable协议
 - 重载相应的运算符
 */
// score大的比较大，若score相等，age小的比较大
struct Student : Comparable {
    var age: Int
    var score: Int
    init(age: Int, score: Int) {
        self.age = age
        self.score = score
    }
    static func < (lhs: Student, rhs: Student) -> Bool {
        (lhs.score < rhs.score) || (lhs.score == rhs.score && lhs.age < rhs.age)
    }
    static func > (lhs: Student, rhs: Student) -> Bool {
        (lhs.score > rhs.score) || (lhs.score == rhs.score && lhs.age > rhs.age)
    }
    static func <= (lhs: Student, rhs: Student) -> Bool {
        !(lhs > rhs)
    }
    static func >= (lhs: Student, rhs: Student) -> Bool {
        !(lhs < rhs)
    }
}

var stu1 = Student(age: 20, score: 100)
var stu2 = Student(age: 18, score: 98)
var stu3 = Student(age: 20, score: 100)
print(stu1 > stu2) // 输出：true
print(stu1 >= stu2) // 输出：true
print(stu1 >= stu3) // 输出：true
print(stu2 < stu1) // 输出：true
print(stu2 <= stu1) // 输出：true
print(stu1 <= stu3) // 输出：true

//MARK: - 自定义运算符
/*
 • 规则
 - prefix operator 前缀运算符
 - postfix operator 后缀运算符
 - infix operator 中缀运算符 : 优先级组(名称自定义)
 - precedencegroup 优先级组(名称自定义) {
     - associativity: 结合性(left/right/none)
        - left: 从左往右开始结合计算
        - right:从右往左开始结合计算
        - none:仅限一个运算符，多个运算符会报错
     - higherThan: 比谁的优先级高
     - lowerThan: 比谁的优先级低
     - assignment: true代表在可选链操作中拥有跟赋值运算符一样的优先级
 }
 */

//示例代码1：
prefix operator +++
prefix func +++(_ i: inout Int) {
    i += 2
}

var age = 10
+++age
print(age) // 输出：12

//示例代码2：
infix operator +- : PlusMinusPrecedence
precedencegroup PlusMinusPrecedence {
    associativity: left
    higherThan: AdditionPrecedence
    lowerThan: MultiplicationPrecedence
    assignment: true
}

extension Point {
    static func +- (p1: Point, p2: Point) -> Point {
        Point(x: p1.x + p2.x, y: p1.y - p2.y)
    }
}
var pm1 = Point(x: 10, y: 20)
var pm2 = Point(x: 5, y: 15)
var pm3 = pm1 +- pm2
print(pm3) // 输出：Point(x: 15, y: 5)

/*
 - 如果设置associativity: none，并且使用了两个及以上运算符就会报错：Adjacent operators are in non-associative precedence group 'PlusMinusPrecedence'
 - 解决报错：
    - associativity取值left或right
 */
var pm4 = pm1 +- pm2 +- pm1
    
//运算符优先级组描述:https://developer.apple.com/documentation/swift/operator-declarations
//高级运算符:https://docs.swift.org/swift-book/documentation/the-swift-programming-language/advancedoperators/

//: [Next](@next)
