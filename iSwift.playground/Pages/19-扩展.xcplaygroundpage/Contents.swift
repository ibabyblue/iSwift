//: [Previous](@previous)

import Foundation

var greeting = "Hello, extension"

//MARK: - 扩展
/*
 • 扩展（Extension）
 - 适用于：枚举、结构体、类、协议
 - 增加新功能：方法、计算属性、下标、初始化器（类只能扩展便捷初始化器）、嵌套类型、协议等等
 - 办不到的事：
    - 不能覆盖原有的功能
    - 不能添加存储属性、不能向已有的属性添加属性观察器
    - 不能添加父类
    - 不能添加指定初始化器，不能添加反初始化器
 
 场景：
 1、为数组限定下标，防崩溃
 extension Array {
     subscript(idx: Int) -> Element? {
         if (startIndex..<endIndex).contains(idx) {
             return self[idx]
         } else {
             return nil;
         }
     }
 }

 2、为结构体自定义初始化器，同时保留编译器生成默认初始化器
 struct Point{
     var x: Int = 0
     var y: Int = 0
 }

 extension Point {
     init(_ point: Point) {
         self.init(x: point.x, y: point.y)
     }
 }

 示例:
 //函数为自定义初始化器，参数为编译器默认生成初始化器
 Point(Point())
 注意：扩展限定的指定初始化器是针对类，因为只有类才有指定初始化器的概念。

 3、类
 注意：
 1、结构体存在编译器默认的初始化，类不存在
 2、类扩展中不能添加指定初始化器，但可以添加便捷初始化器

 4、协议
 - 扩展可以提供默认实现，间接实现可选协议的效果
 - 扩展可以给协议扩充协议中未声明过的方法
 示例:
 protocol P {
     func hi()
 }

 extension P {
     func hi() {
         print("hi - p")
     }
     
     func wo() {
         print("wo - p")
     }
 }
 */

//MARK: - 结构体
//1、为Double添加距离单位：
extension Double {
    var km: Double {
        self * 1_000.0
    }
    var m: Double {
        self
    }
    var cm: Double {
        self / 100.0
    }
    var mm: Double {
        self / 1_000.0
    }
}
var d = 100.0.mm
print(d) // 输出：0.1
print(d.km) // 输出：100.0
print(d.m) // 输出：0.1
print(d.cm) // 输出：0.001

//2.为数组添加下标安全约束，防止数组越界程序崩溃
extension Array {
    subscript(nullable idx: Int) -> Element? {
        if (startIndex..<endIndex).contains(idx) {
            return self[idx]
        }
        return nil
    }
}
let numbers = [10, 20, 30, 40, 50]
var i1 = numbers[nullable: -1]
print(i1 as Any) // 输出：nil
var i2 = numbers[nullable: 3]
print(i2 as Any) // 输出：Optional(40)

//3.为Int扩展功能
extension Int {
    // 重复执行
    func repeats(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
    // 求平方
    mutating func square() -> Int {
        self = self * self
        return self
    }
    // 嵌套枚举类型
    enum Kind {
        case negative, zero, positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
    // 获取最大位数的值（例如：1234[3]，结果：1）
    subscript(digitIndex: UInt) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}

3.repeats {
    print("repeat print")
}
/*
 输出:
 repeat print
 repeat print
 repeat print
 */

var i3 = 10
print(i3.square()) // 输出：100

var i4 = -10
print(i4.kind) // 输出：negative

var i5 = 12345
print(i5[3]) // 输出：2

//4.结构体默认初始化器和自定义初始化器，同时存在
//!!!: 注意：扩展限定的指定初始化器是针对类，因为只有类才有指定初始化器的概念。
struct Point {
    var x: Int = 0
    var y: Int = 0
}
extension Point {
    init(_ point: Point) {
        self.init(x: point.x, y: point.y)
    }
}
var p1 = Point()
var p2 = Point(x: 10)
var p3 = Point(y: 20)
var p4 = Point(x: 10, y: 20)
var p5 = Point(p4)

//MARK: - 类
//!!!: 注意：类遵守协议实现的required初始化器，不能写在扩展中
//!!!: 类扩展中不能添加指定初始化器，只能添加便捷初始化器
class Person {
    var age: Int
    var name: String
    init(age: Int, name: String) {
        self.age = age
        self.name = name
    }
}

extension Person : Equatable {
    static func == (left: Person, right: Person) -> Bool {
        left.age == right.age && left.name == right.name
    }
    convenience init() {
        self.init(age: 0, name: "")
    }
}

//MARK: - 协议
/*
 注意点：
 - 扩展可以给协议提供默认实现，也间接实现可选协议的效果
 - 扩展可以给协议扩充协议中从未声明过的方法
 */
//1.可实现可选协议，默认必须实现协议
protocol Foo {
    func foo()
}

extension Foo {
    func foo() {
        print("extension Foo - foo()")
    }
}

extension Person : Foo {
    
}

let p = Person()
p.foo() //extension Foo - foo()
//如果类中也实现了可选的协议，优先执行类中的协议方法

//2.为系统协议扩展方法
extension BinaryInteger {
    func isOdd() -> Bool {
        self % 2 != 0
    }
}
let i = Int8(10)
print(i.isOdd()) // 输出：false
print(10.isOdd()) // 输出：false
print((-3).isOdd()) // 输出：true

protocol TestProtocol {
    func test1()
}

extension TestProtocol {
    func test1() {
        print("TestProtocol test1")
    }
    func test2() {
        print("TestProtocol test2")
    }
}

class TestClass : TestProtocol {
    func test1() {
        print("TestClass test1")
    }
    func test2() {
        print("TestClass test2")
    }
}
var cls: TestProtocol = TestClass()
cls.test1() // 输出：TestClass test1
cls.test2() // 输出：TestProtocol test2

/*
 为什么test2的输出是协议中的呢？
 - 由于在协议中没有声明test2，所以编译器不能确定将来指向的实例对象是否有test2的实现。
 - 因此把实例cls定义为TestProtocol协议类型后，调用test2时，编译器会认为test2在实例里面可能是不存在的，所以直接去协议里优先找。
 - 调用类中的test1函数的原因是：因为协议中是有声明test1函数的，而协议默认规定类遵守协议必须实现协议内容，所以会从类中调用test1
 */

//MARK: - 泛型
//在扩展中仍然可以使用原类型中的泛型类型，扩展时也可以对泛型附加约束条件。
class Stack<E> {
    var elements = [E]()
    func push(_ element: E) {
        elements.append(element)
    }
    func pop() -> E {
        elements.removeLast()
    }
    func size() -> Int {
        elements.count
    }
}

extension Stack {
    func top() -> E? {
        elements.last
    }
}

extension Stack : Equatable where E : Equatable {
    //这里 Stack 不能换成 Self 因为类型还不确定
    static func == (left: Stack<E>, right: Stack<E>) -> Bool {
        left.elements == right.elements
    }
}

/*
 Self和self的区别:
 - Self:在类型上下文中，表示当前类型，通常用于协议和泛型扩展中，表示具体的符合类型。
 - self:在实例上下文中，表示当前实例。
 */

let s1 = Stack<Int>()
s1.push(1)
s1.push(2)
s1.push(3)

let s2 = Stack<Int>()
s2.push(1)
s2.push(2)
s2.push(3)

s1 == s2

//: [Next](@next)
