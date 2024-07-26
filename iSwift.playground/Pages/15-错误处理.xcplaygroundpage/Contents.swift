//: [Previous](@previous)

import Foundation

var greeting = "Hello, error"

//MARK: - 自定义错误
/*
 • 通过Error协议自定义错误信息
 */
enum SomeError : Error {
    case illegalArg(String)
    case outOfBounds(Int, Int)
    case outOfMemory
}

/*
 • 函数内部通过throw抛出自定义Error，可能会抛出Error的函数必须加上throws声明
 */
func divide(_ num1: Int, _ num2: Int) throws -> Int {
    if num2 == 0 {
        throw SomeError.illegalArg("0不能作为除数")
    }
    return num1 / num2
}

/*
 • 需要使用try调用可能会抛出Error的函数
 */

let res = try divide(10, 2)

//MARK: - do-catch
//抛出Error后，try下一句直到作用域结束的代码都将停止运行
do {
    try divide(10, 0)
} catch let error {
    switch error {
    case let SomeError.illegalArg(msg):
        print("参数错误：", msg)
    default:
        print("其它错误")
    }
}

//MARK: - 处理Error
/*
 • do-catch 捕获 Error
 • 不捕捉Error，在当前函数增加throws声明，Error将自动抛给上层函数
    - 如果最顶层函数（main函数）依然没有捕捉Error，那么程序将终止
 */
//func test() throws {
//    print("1")
//    print(try divide(20, 0))
//    print("2")
//}
//try test()
//// 1
//// Fatal error: Error raised at top level

//func test() throws {
//    print("1")
//    do {
//        print("2")
//        print(try divide(20, 0))
//        print("3")
//    } catch let error as SomeError {
//        print(error)
//    }
//    print("4")
//}
//try test()
// 1
// 2
// illegalArg("0不能作为除数")
// 4

//MARK: - try?、try!
//可以使用try?、try!调用可能会抛出Error的函数，这样就不用去处理Error
func test() {
    print("1")
    var result1 = try? divide(20, 10) // Optional(2), Int?
    var result2 = try? divide(20, 0) // nil
    var result3 = try! divide(20, 10) // 2, Int
    print("2")
}
test()

//MARK: - rethrows
//函数本身不会抛出错误，但调用闭包参数抛出错误，那么它会将错误向上抛
//func exec(_ fn: (Int, Int) throws -> Int, _ num1: Int, _ num2: Int) rethrows {
//    print(try fn(num1, num2))
//}
//// Fatal error: Error raised at top level
//try exec(divide, 20, 0)

//MARK: - defer
/*
 • defer语句：用来定义以((任何方式))(抛错误、return等)离开代码块((前))必须要执行的代码
 • defer语句本质是作用域结束时调用 lambda 表达式，底层使用c++编写。
 */

func testDefer1() throws {
    print("open")
    defer {
        print("close")
    }
    // ....
    try divide(20, 0)
    
    // print("close")将会在这里调用
}
try testDefer1()
// open
// close
// Fatal error: Error raised at top level

//defer语句的执行顺序与定义顺序相反
func fn1() { print("fn1") }
func fn2() { print("fn2") }

func testDefer2() {
    defer { fn1() }
    defer { fn2() }
    //如果作用域结束之前无其它代码，就是defer语句的话，defer语句会立即执行，也就失去了defer的意义，编译器会
    //警告，但不会报错。警告：'defer' statement at end of scope always executes immediately; replace with 'do' statement to silence this warning
}
testDefer2()
//fn2
//fn1

//应用场景1:锁的获取和释放
//func safeMethod() {
//    lock.lock()
//    defer {
//        lock.unlock()
//    }
//
//    // 执行需要同步的代码
//    // 如果这里有 return 或抛出异常，defer 仍然保证锁被释放
//}

//应用场景2:文件操作
//func processFile(path: String) throws {
//    let file = try FileHandle(forReadingFrom: URL(fileURLWithPath: path))
//    defer {
//        file.closeFile()
//    }
//
//    // 读取并处理文件内容
//}

//MARK: - assert(断言)
/*
 • assert:不符合指定条件就抛出运行时错误，常用于调试（Debug）阶段的条件判断
 - 默认情况下，Swift的断言只会在Debug模式下生效，Release模式下会忽略
 
 • 增加Swift Flags修改断言的默认行为
 - -assert-config Release：强制关闭断言
 - -assert-config Debug：强制开启断言
 */

//MARK: - fatalError
/*
 • fatalError:使用do-catch无法捕获
 - 如果遇到严重问题，希望结束程序运行时，可以直接使用fatalError函数抛出错误
    fatalError("num不能小于0")
 */

//MARK: - 局部作用域
/*
 do:实现局部作用域
 */
func foo() {
    do {
        print("scope 1")
    }
    
    do {
        print("scope 2")
    }
}

//: [Next](@next)
