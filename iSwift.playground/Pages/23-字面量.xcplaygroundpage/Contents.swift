//: [Previous](@previous)

import Foundation

var greeting = "Hello, Literal"

//MARK: - 字面量
var age = 18
var name = "Jack"
//18、Jack即为字面量

//MARK: 字面量类型
/*
 • 常见字面量默认类型：
 - public typealias IntegerLiteralType = Int
 - public typealias FloatLiteralType = Double
 - public typealias BooleanLiteralType = Bool
 - public typealias StringLiteralType = String
 */

//通过 typealias 修改字面量默认类型：
public typealias FloatLiteralType = Float
public typealias IntegerLiteralType = UInt8
var width = 10 // UInt8类型
var height = 20.0 // Float类型

//Swift自带的绝大部分类型，都支持直接通过字面量进行初始化（不需要调用初始化器）
//Bool、Int、Float、Double、String、Array、Dictionary、Set、Optional等

//MARK: 字面量协议
/*
 • 支持字面量初始化，因为遵守了对应协议：
 - Bool : ExpressibleByBooleanLiteral
 - Int : ExpressibleByIntegerLiteral
 - Float、Double : ExpressibleByIntegerLiteral、ExpressibleByFloatLiteral
 - Dictionary : ExpressibleByDictionaryLiteral
 - String : ExpressibleByStringLiteral
 - Array、Set : ExpressibleByArrayLiteral
 - Optinal : ExpressibleByNilLiteral
 */

//示例代码
var b: Bool = false // ExpressibleByBooleanLiteral
var i: Int = 10 // ExpressibleByIntegerLiteral
var f0: Float = 10 // ExpressibleByIntegerLiteral
var f1: Float = 10.0 // ExpressibleByFloatLiteral
var d0: Double = 10 // ExpressibleByIntegerLiteral
var d1: Double = 10.0 // ExpressibleByFloatLiteral
var s: String = "ibabyblue" // ExpressibleByStringLiteral
var arr: Array = [1, 2, 3] // ExpressibleByArrayLiteral
var set: Set = [1, 2, 3] // ExpressibleByArrayLiteral
var dict: Dictionary = ["name" : "rose"] // ExpressibleByDictionaryLiteral
var o: Optional<Int> = nil // ExpressibleByNilLiteral

//MARK: 字面量协议应用
//示例代码一：
//给 Int 类型扩展一个 ExpressibleByBooleanLiteral 协议，可以赋值 Bool 类型
extension Int : ExpressibleByBooleanLiteral {
    public init(booleanLiteral val: Bool) {
        self = val ? 1 : 0
    }
}

var num: Int = true
print(num)

//示例代码二：
class Student : ExpressibleByIntegerLiteral, ExpressibleByFloatLiteral, ExpressibleByStringLiteral, CustomStringConvertible {
    
    var name: String = ""
    var score: Double = 0
    
    //CustomStringConvertible协议
    var description: String {
        "name=\(name), score=\(score)"
    }
    
    //ExpressibleByIntegerLiteral协议
    required init(integerLiteral value: Int) {
        self.score = Double(value)
    }
    
    //ExpressibleByFloatLiteral协议
    required init(floatLiteral value: Double) {
        self.score = value
    }
    
    //ExpressibleByStringLiteral协议
    required init(stringLiteral value: String) {
        self.name = value
    }
    
    //ExpressibleByStringLiteral协议：支持Unicode和特殊字符
    required init(unicodeScalarLiteral value: String) {
        self.name = value
    }
    
    //ExpressibleByStringLiteral协议：扩展字符集
    required init(extendedGraphemeClusterLiteral value: String) {
        self.name = value
    }
}

var stu: Student = 90
print(stu)

stu = 98.5
print(stu)

stu = "ibabyblue"
print(stu)

//示例代码三：
struct Point {
    var x = 0.0, y = 0.0
}

extension Point : ExpressibleByArrayLiteral, ExpressibleByDictionaryLiteral {
    init(arrayLiteral elements: Float...) {
        guard elements.count > 0 else {
            return
        }
        
        self.x = elements[0]
        guard elements.count > 1 else {
            return
        }
        self.y = elements[1]
    }
    
    init(dictionaryLiteral elements: (String, Float)...) {
        for (k, v) in elements {
            if k == "x" {
                self.x = v
            } else if k == "y" {
                self.y = v
            }
        }
    }
}

var p: Point = [5.12, 10.24]
print(p)

p = ["x" : 5.27, "y" : 12.37]
print(p)

//MARK: - Pattern（模式）
/*
 • 模式：
 用于匹配规则，如 switch 的 case，捕获错误的 catch，if/guard/while/for语句的条件等
 • Swift中的模式：
 - 通配符模式（Wildcard Pattern）
 - 标识符模式（Identifier Pattern）
 - 值绑定模式（Value-Binding Pattern）
 - 元组模式（Tuple Pattern）
 - 枚举Case模式（Enumeration Pattern）
 - 可选模式（Optional Pattern）
 - 类型转换模式（Type-Casting Pattern）
 - 表达式模式（Expression Pattern）
 */

//MARK: 通配符模式（Wildcard Pattern）
/*
 • _ 匹配任何值
 • _? 匹配非nil值
 */

//代码示例：
enum Life {
    case human(name: String, age: Int?)
    case animal(name: String, age: Int?)
}
func check(_ life: Life) {
    switch life {
    case .human(let name, _):
        print("human", name)
    case .animal(let name, _?):
        print("animal", name)
    default:
        print("other")
    }
}
check(.human(name: "Rose", age: 20)) // 输出：human Rose
check(.human(name: "Jack", age: nil)) // 输出：human Jack
check(.animal(name: "Dog", age: 5)) // 输出：animal Dog
check(.animal(name: "Cat", age: nil)) // 输出：other

/*
 - case .human(let name, _):中的_就是匹配任意值
 - case .animal(let name, _?):中的_?就是匹配非nil值
 */

//MARK: 标识符模式（Identifier Pattern）
//给对应的变量、常量名赋值
var nickname = "ii"

//MARK: 值绑定模式（Value-Binding Pattern）
//将对应位置的值绑定到变量\常量中
let point = (1, 2)
switch point {
case let (x, y):
    print("x:\(x), y:\(y)")
}

//MARK: 元组模式（Tuple Pattern）
//本质为：值绑定和通配符模式
//示例代码一：（数组）
let points = [(0, 0), (1, 0), (2, 0)]
for (x, _) in points {
    print(x)
}
/*
 输出:
 0
 1
 2
 */

//示例代码二：（case）
let iName: String? = "ibabyblue"
let iAge: Int = 18
let iInfo: Any = [1, 2]

switch (iName, iAge, iInfo) {
case (_?, _, _ as String):
    print("case")
default:
    print("default")
}

//示例代码三：（字典）
var scores = ["jack" : 98, "rose" : 100, "kate" : 86]
for (name, score) in scores {
    print(name, score)
}

//MARK: 枚举Case模式（Enumeration Pattern）
//if case语句等价于只有一个case的switch语句

//示例代码一：
let iNum = 2
func foo() {
    //原写法
    if iNum >= 0 && iNum <= 9 {
        print("[0, 9]")
    }
    
    // 枚举case模式, if case 0...9 = iNum 可以理解为是拿出iNum的值和case后面的条件进行匹配
    if case 0...9 = iNum {
        print("[0, 9]")
    }
    
    guard case 0...9 = iNum else { return }
    print("[0, 9]")
}
foo()

//示例代码二：
let iNums: [Int?] = [1, 2, nil, 3]

for case nil in iNums {
    print("nil value exists")
    break
}

//示例代码三：
let iPoints = [(1, 0), (2, 1), (3, 0)]
for case let (x, 0) in iPoints {
    print(x)
}

//MARK: 可选模式（Optional Pattern）
//示例代码一：
let oAge: Int? = 18
if case .some(let x) = oAge {
    print(x)
}

if case let x? = oAge {
    print(x)
}

//示例代码二：
let oAges: [Int?] = [nil, 2, 3, nil, 5]
for case let age? in oAges {
    print(age)
}
/*
 输出：
 2
 3
 5
 */

//示例代码三：
func check(_ num: Int?) {
    switch num {
    case 2?:
        print("2")
    case 4?:
        print("4")
    case 6?:
        print("6")
    case 8?:
        print("8")
    case _?:
        print("other")
    case _:
        print("nil")
    }
}

check(4)
check(10)
check(nil)

//MARK: 类型转换模式（Type-Casting Pattern）
//is 和 as 的使用
//示例代码一：
class Animal {
    func eat() {
        print(type(of: self), "eat")
    }
}
class Dog : Animal {
    func run() {
        print(type(of: self), "run")
    }
}
class Cat : Animal {
    func jump() {
        print(type(of: self), "jump")
    }
}
func check(_ animal: Animal) {
    switch animal {
    case let dog as Dog:
        dog.eat()
        dog.run()
    case is Cat:
        animal.eat()
    default:
        break
    }
}
check(Dog())
/*
 输出：
 Dog eat
 Dog run
 */

check(Cat())
/*
 输出：
 Cat eat
 */
/*
 上面的示例中，如果匹配case is Cat时，怎样才能执行jump方法？因为animal是Animal类型。
 可以对animal进行强制转换：
 (animal as? Cat)?.jump()
 */

//MARK: 表达式模式（Expression Pattern）
let ePoint: (Int, Int) = (1, 2)
switch ePoint {
case (0, 0):
    print("(0, 0) is at the origin. ")
case (-2...2, -2...2):
    print("(\(ePoint.0), \(ePoint.1)) is near the origin.")
default:
    print("The point is at (\(ePoint.0), \(ePoint.1)).")
}
// 输出：(1, 2) is near the origin.

//在Swift中，一些复杂switch匹配会用到 ~= 表达式模式运算符，但并不是所有的switch都是用到该运算符
//1.自定义表达式模式
struct Stu {
    var score = 0, name = ""
    
    static func ~= (pattern: Int, value: Stu) -> Bool {
        value.score >= pattern
    }
    static func ~= (pattern: ClosedRange<UInt8>, value: Stu) -> Bool {
        pattern.contains(value.score)
    }
    static func ~= (pattern: Range<UInt8>, value: Stu) -> Bool {
        pattern.contains(value.score)
    }
}

//示例代码一：
var sStu = Stu(score: 72, name: "ibabyblue")
switch sStu {
case 100: 
    print(">=100")
case 90: 
    print(">=90")
case 80..<90: 
    print("[80, 90)")
case 60...79: 
    print("[60, 79]")
case 0: 
    print(">=0")
default: 
    break
}
// 输出：[60, 79]

//sStu是怎么和Int、Rang进行匹配的呢？重写 ~= 表达式模式运算符
//基本上是固定写法（返回值必须是Bool）：
// pattern: case后面的类型
// value: switch后面的类型
//static func ~= (pattern: Int, value: Student) -> Bool {
//    
//}

//示例代码二：
//if case 本质就是 switch
if case 60 = sStu {
    print(">=60")
}
// 输出：>=60

//示例代码三：
var info = (Stu(score: 70, name: "jack"), "及格")
switch info {
case let (60, text):
    print(text)
default:
    break
}
// 输出：及格

//示例代码四：
extension String {
    static func ~= (pattern: (String) -> Bool, value: String) -> Bool {
        pattern(value)
    }
}

func hasPrefix(_ prefix: String) -> ((String) -> Bool) {
    { $0.hasPrefix(prefix) }
}
func hasSuffix(_ suffix: String) -> ((String) -> Bool) {
    { $0.hasSuffix(suffix) }
}

var str = "ibabyblue"
switch str {
case hasPrefix("i"), hasSuffix("e"):
    print("以i开头 或 以e结尾")
default:
    break
}
// 输出：以i开头 或 以e结尾

//示例代码五：
func isEven(_ i: Int) -> Bool {
    i % 2 == 0
}

func isOdd(_ i: Int) -> Bool {
    i % 2 != 0
}

extension Int {
    static func ~= (pattern: (Int) -> Bool, value: Int) -> Bool {
        pattern(value)
    }
}

var digit: Int = 10

switch digit {
case isEven:
    print("偶数")
case isOdd:
    print("奇数")
default:
    print("other")
}
// 输出：偶数

//更多自定义操作符：
prefix operator ~>
prefix operator ~>=
prefix operator ~<
prefix operator ~<=
prefix func ~> (_ i: Int) -> ((Int) -> Bool) { { $0 > i } }
prefix func ~>= (_ i: Int) -> ((Int) -> Bool) { { $0 >= i } }
prefix func ~< (_ i: Int) -> ((Int) -> Bool) { { $0 < i } }
prefix func ~<= (_ i: Int) -> ((Int) -> Bool) { { $0 <= i } }

var cNum: Int = 10
switch cNum {
case ~>=0, ~<=10:
    print("1")
case ~>10, ~<20:
    print("2")
default:
    break
}
// 输出：1
//>, =, >=, <, <=运算符都是中缀运算符，为了不影响原有的运算符特性，在原有运算符前面加一个~符号成为一个新的运算符

//2.where:可以使用where为模式匹配增加匹配条件
//示例代码一: case
var data = (10, "Jack")
switch data {
case let (age, _) where age > 10:
    print(data.1, "age>10")
case let (age, _) where age > 0:
    print(data.1, "age>0")
default:
    break
}
// 输出：Jack age>0

//示例代码二: for
var digits = [1, 2, 3, 4, 5]

for difit in digits where digit > 3 {
    print(digit)
}
// 输出：4 5

//示例代码三: protocol
protocol Stackable {
    associatedtype Element
}
protocol Container {
    associatedtype Stack : Stackable where Stack.Element : Equatable
}

//示例代码四: func
func equal<S1: Stackable, S2: Stackable>(_ s1: S1, _ s2: S2) -> Bool where S1.Element == S2.Element, S1.Element : Hashable {
    return false
}

//示例代码五: extension
extension Container where Self.Stack.Element : Hashable { }

//: [Next](@next)
