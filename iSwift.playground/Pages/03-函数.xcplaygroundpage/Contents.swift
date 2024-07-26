//: [Previous](@previous)

import Foundation

var greeting = "Hello, func"

//MARK: - 函数定义
func pi() -> Double {
    return 3.1415926
}

//形参模式是let，也只能是let
func sum(v1: Int, v2: Int) -> Int {
    return v1 + v2
}

sum(v1:10, v2:20)

//无返回值
func sayHi() -> Void {
    print("hi")
}
sayHi()

func sayHello() -> () {
    print("hello")
}
sayHello()

func hitme() {
    print("hitme")
}
hitme()

//MARK: - 隐式返回（Implicit Return）
/*
 隐式返回:
 - 如果函数体为单一表达式，则函数会隐式返回表达式，省略return关键字
 */
func multiply(v1: Int, v2: Int) -> Int {
    v1 * v2
}
multiply(v1: 2, v2: 3)

//MARK: - 返回元组
//函数文档注释，参考：https://swift.org/documentation/api-design-guidelines/

/// 求和、差值、平均值
///
/// - Parameters:
///   - v1: 第一个整数
///   - v2: 第二个整数
/// - Returns: 2个整数的和、差、平均值
func calculate(v1: Int, v2: Int) -> (sum: Int, difference: Int, average: Int) {
    let sum = v1 + v2
    return (sum, v1 - v2, sum >> 1)
}

calculate(v1: 20, v2: 10)

//MARK: - 参数标签
//1.修改标签
func gotoWork(at time: String) {
    print("this time is \(time)")
}

//参数标签time -> at
gotoWork(at: "8:00")

//2.省略标签
func minus(_ v1: Int, _ v2: Int) -> Int {
    v1 - v2
}

//参数标签V1、v2省略
minus(20, 10)

//MARK: - 默认参数
func check(name: String, age: Int = 18) {
    print("name:\(name), age:\(age)")
}
check(name: "jack")

//MARK: - 可变参数
/*
 可变参数:
 - 一个函数只能存在一个可变参数
 - 紧跟在可变参数后面的参数不能省略参数标签
 */
func vSum(_ numbers: Int...) -> Int {
    var total = 0
    for number in numbers {
        total += number
    }
    return total
}

vSum(10, 20 ,30)

//MARK: - 输入输出参数
/*
 输入输出参数:
 - inout参数不能存在默认值
 - inout参数只能传递变量
 - inout参数本质是地址传递（引用传递）
 */
func swapValue(_ v1: inout Int, _ v2: inout Int) {
    //交换数值-元组
    (v1, v2) = (v2, v1)
    
    //交换数值-临时常量
//    let tmp = v1
//    v1 = v2
//    v2 = tmp
}

var v1 = 1
var v2 = 2
swapValue(&v1, &v2)

//MARK: - 函数重载（function overload）
/*
 函数重载：
 - 函数名相同
 - 参数个数不同 || 参数标签不同
 - 返回值类型与重载无关，比如参数都相同，无返回值与有返回值不构成重载
 - 默认参数值和函数重载同时使用产生二义性，编译器并不会报错（c++会报错）
 - 可变参数、省略标签和函数重载同时使用产生二义性，编译器报错
 */
func oSum(v1: Int, v2: Int) -> Int {
    v1 + v2
}

func oSum(_ v1: Int, _ v2: Int) -> Int {
    v1 + v2
}

func oSum(v1: Int, v2: Int, v3: Int = 1) -> Int {
    v1 + v2 + v3
}

oSum(1, 1)

//MARK: - inline 内联函数
/*
 内联函数：
 - 函数调用展开为函数体
 - 不会自动内联函数：
    - 函数体比较长
    - 包含递归调用
    - 包含动态派发
    - ...
 */

//永不内联
@inline(never) func inFunction() {
    print("inFunction")
}

/*强制内联
 - 需开启编译器优化选项才有效
 - 递归调用函数、动态派发函数依然不会内联
 */
@inline(__always) func iaFunction() {
    print("iaFunction")
}

//MARK: - 函数类型
/*
 函数类型：
 - 由形参类型+返回值类型组成
 */

//() -> () 或者 () -> Void 类型 Swift标准库中Void的定义就是空元组
func tvFunction() {
    print("tvFunction")
}

//(Int, Int) -> Int 类型
func tiFunction(v1: Int, v2: Int) -> Int {
    v1 + v2
}

//定义函数类型变量
var fn: (Int, Int) -> Int = tiFunction

fn(1, 2)

//函数类型参数
func division(v1: Int, v2: Int) -> Int {
    v1 / v2
}

func pFunction(_ action: (Int, Int) -> Int, v1: Int, v2: Int) {
    print(action(v1, v2))
}

pFunction(division, v1: 10, v2: 2)

//函数类型返回值
func next(_ input: Int) -> Int {
    input + 1
}

func previous(_ input: Int) -> Int {
    input - 1
}

func forward(_ forward: Bool) -> (Int) -> Int {
    forward ? next : previous
}

forward(true)(2)
forward(false)(2)

//MARK: - typealias
/*
 typealias
 - 用来给类型取别名
 */

typealias Byte = UInt8

typealias Date = (year: Int, month: Int, day: Int)

func dateFunc(_ date: Date) {
    print(date.year)
    print(date.month)
    print(date.day)
}

dateFunc((2024, 05, 19))

//MARK: - 嵌套函数
//函数内部定义函数
func embedFunc(_ forward: Bool) -> (Int) -> Int {
    func next(_ input: Int) -> Int {
        input + 1
    }

    func previous(_ input: Int) -> Int {
        input - 1
    }
    
    return forward ? next : previous
}

embedFunc(true)(2)
embedFunc(false)(2)


//: [Next](@next)
