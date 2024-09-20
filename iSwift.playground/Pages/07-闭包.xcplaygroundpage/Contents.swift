//: [Previous](@previous)

import Foundation

var greeting = "Hello, closure expression"

//MARK: - 闭包定义
/*
 定义:一个函数和它所捕获的变量\常量环境组合起来，称为闭包。
     - 一般为函数内部定义的函数
     - 一般捕获的是外层函数的局部变量\常量
 
 可以把闭包想象成是一个类的实例对象
     - 内存在堆空间
     - 捕获的局部变量\常量就是对象的成员（存储属性）
     - 组成闭包的函数就是类内部定义的方法
 
 闭包类型：
    - 逃逸闭包
    - 非逃逸闭包
    - 自动闭包
 
 1、逃逸闭包：\@escaping
    逃逸闭包：又称转义闭包，只是翻译不同，如果闭包需要存储使用，此时需要使用逃逸闭包，因为在当前函数作用域内，并没有调用闭包，可能在之后的逻辑中调用此闭包，所以使用逃逸闭包。
 
 2、非逃逸闭包：\@nonescaping
    非逃逸闭包：闭包不需要存储使用。
    1、为了内存管理，闭包会强引用它捕获的所有对象，这样闭包会持有当前对象，容易导致循环引用
    2、非逃逸闭包不会产生循环引用，它会在函数作用域内使用，编译器可以保证在函数结束时闭包会释放它捕获的所有对象
    3、使用非逃逸闭包可以使编译器应用更多强有力的性能优化，例如，当明确了一个闭包的生命周期的话，就可以省去一些保留（retain）和释放（release）的调用
    4、非逃逸闭包它的上下文的内存可以保存在栈上而不是堆上
 总结：开发中使用非逃逸闭包是有利于内存优化

 3、自动闭包：自动闭包的作用->避免不必要的调用资源浪费，需要时再调用
    autoclosure:自动闭包，可以解决??右侧参数直接被调用（非函数）、只能是函数参数问题
    autoclosure可以自动将"X" 转成 {return "X"}
 */

//MARK: - 闭包表达式
/*
 { 
    (参数列表) -> 返回值 in
    闭包体代码（函数体代码）
 }
 */

//MARK: - 匿名闭包
//无参无返回值闭包
func invokeAnonymousClosure() {
    //匿名闭包需要包裹在函数里面测试，因为顶级语句不能以闭包表达式开头
    { () -> () in
        let _ = "This is a closure with no arguments and no return value"
    }()
    //无参数无返回值时，参数列表、返回值、in关键字都可省略，所以等价于
//    {
//        "This is a closure with no arguments and no return value"
//    }()
}

invokeAnonymousClosure()

//无参有返回值闭包
print({ () -> (String) in
    //单一表达式，则可省略return
    "This is a closure with no parameters and a return value"
}())

//有参有返回值闭包
print({ (param: String) -> (String) in
    //单一表达式，则可省略return
    "This is a closure with an \(param) and a return value"
}("real parameter"))

//MARK: - 闭包变量
let lClosure1: () -> () = {
    print("lClosure : () -> ()")
}

lClosure1()

let lClosure2: (String) -> () = { (param: String) in
    print("lClosure : (\(param)) -> ()")
}

lClosure2("lClosure2")

let lClosure3: (String) -> String = { (param: String) -> String in
    "lClosure : (\(param)) -> (string)"
}

lClosure3("lClosure3")

//MARK: - 闭包表达式简写
func exec(v1: Int, v2: Int, fn: (Int, Int) -> Int) -> Int {
    fn(v1, v2)
}

exec(v1: 10, v2: 20) { (v1: Int, v2: Int) -> Int in
    return v1 + v2
}

exec(v1: 10, v2: 20) { v1, v2 in
    return v1 + v2
}

exec(v1: 10, v2: 20) { v1, v2 in
    v1 + v2
}

exec(v1: 10, v2: 20) {
    $0 + $1
}

//运算符作为函数，Swift中运算符实际上是函数，+：func +(lhs: Int, rhs: Int) -> Int
exec(v1: 10, v2: 20, fn: +)

//MARK: - 尾随闭包
//如果闭包作为函数的最后一个实参，使用尾随闭包可以增强可读性
// - 尾随闭包为一个被书写在函数调用括号外面的闭包表达式
//fn即为尾随闭包
func action(v1: Int, v2: Int, fn: (Int, Int) -> Int) -> Int {
    fn(v1, v2)
}

/*
 { v1, v2 in
     v1 * v2
 } 即为尾随闭包，书写在函数调用括号外面的的闭包表达式
 */
action(v1: 2, v2: 3) { v1, v2 in
    v1 * v2
}

//!!!: 经典尾随闭包结构
//array.sorted就是一个尾随闭包
var arr = [1, 2, 3]
//1、完整写法
arr.sorted { (item1: Int, item2: Int) -> Bool in return item1 < item2}
//2、省略参数类型：通过array中的参数推断类型
arr.sorted { (item1, item2) -> Bool in return item1 < item2}
//3、省略参数类型 + 返回值类型：通过return推断返回值类型
arr.sorted { (item1, item2) in return item1 < item2}
//4、省略参数类型 + 返回值类型 + return关键字：单表达式可以隐式表达，即省略return关键字
arr.sorted { (item1, item2) in item1 < item2}
//5、参数名称简写
arr.sorted {return $0 < $1}
//6、参数名称简写 + 省略return关键字
arr.sorted {$0 < $1}
//7、最简：直接传比较符号
arr.sorted (by: <)

//尾随闭包初始化
struct Foo {
    init(_ foo : (Int, Int) -> Int) {
        foo(1, 2)
    }
}

let _ = Foo { v1, v2 in
    v1 + v2
}

//MARK: - 闭包捕获
typealias Fn = (Int) -> Int
func getFn() -> Fn {
    var num = 0
    func plus(_ i: Int) -> Int {
        num += i
        return num
    }
    return plus
}

var fn1 = getFn()
var fn2 = getFn()

fn1(1)
fn2(2)
fn1(3)
fn2(4)

var funcs: [() -> Int] = []
for i in 1...3 {
    funcs.append({i})
}

for f in funcs {
    print(f())
}

//inout 参数
func add(_ num: Int) -> (inout Int) -> Void {
    func plus(v: inout Int) {
        v += num
    }
    return plus
}
var num = 5
add(20)(&num)
print(num)

//MARK: - 自动闭包\@autoclosure
/*
 - 自动将非闭包参数封装成闭包参数
 - 只支持()->T类型的参数
 - 并非只支持最后一个参数
 - 空合运算符??使用了\@autoclosure技术
 - 有\@autoclosure与无\@autoclosure的函数构成重载
 */
// 如果第1个数大于0，返回第一个数。否则返回第2个数
func getFirstPositive(_ v1: Int, _ v2: Int) -> Int {
    return v1 > 0 ? v1 : v2
}
getFirstPositive(10, 20) // 10
getFirstPositive(-2, 20) // 20
getFirstPositive(0, -4) // -4

// 改成函数类型的参数，可以让v2延迟加载
func getFirstPositive(_ v1: Int, _ v2: () -> Int) -> Int? {
    return v1 > 0 ? v1 : v2()
}
getFirstPositive(-4) { 20 }

func getFirstPositiveNum(_ v1: Int, _ v2: @autoclosure () -> Int) -> Int? {
    return v1 > 0 ? v1 : v2()
}
//@autoclosure会自动将20封装成闭包{20}
getFirstPositiveNum(-4, 20)

//MARK: - 闭包与函数的关系
/*
 关键区别:
 语法和使用方式：
 - 函数：有名字，可以重用，并且可以在多个地方调用。
 - 闭包表达式：通常是匿名的，定义和使用的范围比较小，多用于简化代码或作为参数传递。
 
 上下文捕获：
 - 函数：可以捕获并存储在其定义范围内的变量。
 - 闭包表达式：可以捕获并存储在其定义范围内的变量。特别适用于异步操作和回调。
 
 定义方式：
 - 函数：使用 func 关键字定义。
 - 闭包表达式：使用大括号 {} 进行定义，可以内联在代码中。
 
 总结:
 - 函数是闭包的一种特例：函数是一种有名字的闭包，可以在定义的作用域外部调用。
 - 闭包表达式更灵活：闭包表达式没有名字，通常用于短小的代码块，尤其是作为参数传递时。
 - 上下文捕获：闭包表达式可以捕获并存储其定义范围内的变量和常量，而全局函数不能捕获局部变量、常量。

 所以，虽然函数和闭包在 Swift 中密切相关并且在很多场景下可以互换使用，但它们并不是完全相同的概念。函数是一种命名的闭包，而闭包表达式则可以是匿名的，可以更灵活地捕获上下文。
 */
//: [Next](@next)
