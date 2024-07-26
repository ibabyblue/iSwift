//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//函数式编程（Funtional Programming，简称FP）是一种编程范式，也就是如何编写程序的方法论。

//MARK: - 什么是函数式编程
//1.1介绍
/*
 主要思想：把计算过程尽量分解成一系列可复用函数的调用。
 主要特征：函数是"一等公民"（函数与其他数据类型一样的地位，可以赋值给其他变量，也可以作为函数参数、函数返回值）

 函数式编程中几个常用的概念：
 - Higher-Order Function、Function Currying
 - Functor、Applicative Functor、Monad
 
 延伸：函数式编程最早出现在LISP语言，绝大部分的现代编程语言也对函数式编程做了不同程度的支持，比如JavaScript、Python、Swift、Kotlin、Scala等。
 */

//1.2实践
//示例代码：(非函数式)
var num = 1
func add(_ v1: Int, _ v2: Int) -> Int {v1 + v2}
func sub(_ v1: Int, _ v2: Int) -> Int {v1 - v2}
func multiple(_ v1: Int, _ v2: Int) -> Int {v1 * v2}
func divide(_ v1: Int, _ v2: Int) -> Int {v1 / v2}
func mod(_ v1: Int, _ v2: Int) -> Int {v1 % v2}

divide(mod(sub(multiple(add(num, 3), 5), 1), 10), 2)

//示例代码：(函数式)
func fAdd(_ v: Int) -> (Int) -> Int { {$0 + v} }
func fSub(_ v: Int) -> (Int) -> Int { {$0 - v} }
func fMultiple(_ v: Int) -> (Int) -> Int { {$0 * v} }
func fDivide(_ v: Int) -> (Int) -> Int { {$0 / v} }
func fMod(_ v: Int) -> (Int) -> Int { {$0 % v} }

let fn1 = fAdd(3)
let fn2 = fMultiple(5)
let fn3 = fSub(1)
let fn4 = fMod(10)
let fn5 = fDivide(2)

fn5(fn4(fn3(fn2(fn1(num)))))

//MARK: - 函数合成
//函数合成：将多个函数合并到一个函数内
func composite(_ f1: @escaping (Int) -> Int, _ f2: @escaping (Int) -> Int) -> (Int) -> Int {
    //这里$0指的是返回值函数的参数
    { f2(f1($0)) }
}

let f = composite(fAdd(3), fMultiple(5))
f(1) // 20

//示例代码：自定义运算符
infix operator >>> : AdditionPrecedence
func >>>(_ f1: @escaping (Int) -> Int, _ f2: @escaping (Int) -> Int) -> (Int) -> Int {
    { f2(f1($0)) }
}

let cf = fAdd(3) >>> fMultiple(5) >>> fSub(1) >>> fMod(10) >>> fDivide(2)
cf(num) // 4

//泛型约束示例：
infix operator <<< : AdditionPrecedence
func <<<<T1, T2, T3>(_ f1: @escaping (T1) -> T2, _ f2: @escaping (T2) -> T3) -> (T1) -> T3 {
    { f2(f1($0)) }
}

//MARK: - 高阶函数
/*
 • 高阶函数至少满足下列一个条件的函数：
 - 接受一个或多个函数作为输入（例如：map、filter、reduce等）
 - 返回一个函数
 */

//在FP中随处可见高阶函数，上述的add、sub、multiple、divide、mod均为高阶函数

//MARK: - 柯里化
/*
 • 柯里化
 - 将一个接受多参数的函数变换为一系列只接受单个参数的函数
 */

//将 func add(_ v1: Int, _ v2: Int) -> Int {v1 + v2} 柯里化
//代码示例：
func cAdd(_ v: Int) -> (Int) -> Int { {$0 + v} }
cAdd(1)(2)

func add1(_ v1: Int, _ v2: Int, _ v3: Int) -> Int { v1 + v2 + v3 }
//将 func add1(_ v1: Int, _ v2: Int, _ v3: Int) -> Int { v1 + v2 + v3 } 柯里化
func add2(_ v3: Int) -> (Int) -> (Int) -> Int {
    return { v2 in
        return { v1 in
            return v1 + v2 + v3
        }
    }
}
add2(3)(2)(1) // 6
//注意：柯里化函数参数一般是原函数参数的倒序方式。具体需要根据开发需求调整对应参数顺序

//MARK: - 函子
/*
 • 函子
 - 像Array、Optional这样支持map运算的类型，称为函子（Functor）
 */

//1.适用函子
/*
 • 对任意一个函子F，如果能支持以下运算，该函子就是一个适用函子（Application Functor）
 //传入任意泛型参数A，最终返回对应类型，该类型的实体
 - func pure<A>(_ value: A) -> F<A>
 - func <*><A, B>(fn: F<A -> B>, value: F<A>) -> F<B>
 */
//示例代码：Optional
//func pure<A>(_ value: A) -> A? { value }
//infix operator <*> : AdditionPrecedence
//func <*><A, B>(fn: ((A) -> B)?, value: A?) -> B? {
//    guard let f = fn, let v = value else { return nil }
//    return f(v)
//}
//
//var value: Int? = 10
//var fn: ((Int) -> Int)? = { $0 * 2}
//print(fn <*> value as Any) // 输出：Optional(20)

//示例代码：Array
infix operator <*> : AdditionPrecedence
func pure<A>(_ value: A) -> [A] { [value] }
func <*><A, B>(fn: [(A) -> B], value: [A]) -> [B] {
    var arr: [B] = []
    if fn.count == value.count {
        for i in fn.startIndex..<fn.endIndex {
            arr.append(fn[i](value[i]))
        }
    }
    return arr
}
print(pure(10)) // 输出：[10]

var arr = [{ $0 * 2 }, { $0 + 10 }, { $0 - 5 }] <*> [1, 2, 3]
print(arr) // 输出：[2, 12, -2]

//MARK: - 单子
/*
 • 对任意一个类型F，如果能支持以下运算，那么就可以称为是一个单子（Monad）
 - func pure<A>(_ value: A) -> F<A>
 - func flatMap<A, B>(_ value: F<A>, _ fn: (A) -> F<B>) -> F<B>
 */
//Array、Optional都是单子

//参考地址
//https://adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html
//http://www.mokacoding.com/blog/functor-applicative-monads-in-pictures

//: [Next](@next)

