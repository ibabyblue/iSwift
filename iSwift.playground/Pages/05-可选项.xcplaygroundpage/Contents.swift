//: [Previous](@previous)

import Foundation

var greeting = "Hello, optional"

/*
 可选项：
 - 也叫做可选类型，允许将值设置为nil
 
 !!!: 可选项是对其它类型的一层包装，可以理解为一个盒子
 !!!: 如果为nil，就是空盒子
 !!!: 如果不为nil，盒子里面装的是：被包装的类型
 */
//MARK: 可选项变量
var nickName: String? = "jack"
nickName = nil

var age: Int? //默认值为nil
age = 18

//MARK: 可选项返回值
let arr: [Int] = [1, 2, 3, 4, 5]
func getElement(_ idx: Int) -> Int? {
    if (idx < 0 || idx >= arr.count) {
        return nil
    }
    return arr[idx]
}

getElement(-1)
getElement(2)
getElement(5)

//MARK: 可选项强制解包
/*
 强制解包：
 - 如果可选项不为nil，强制解包（将盒子里面的东西取出来）
 - !!!: 如果可选项为nil，强制解包，则会崩溃(Fatal error: Unexpectedly found nil while unwrapping an Optional value)
 */

let ageInt: Int = age!

//MARK: 可选项绑定
/*
 - 可以使用可选项绑定来判断可选项是否包含值
 - 如果包含就自动解包，把值赋给一个临时的常量(let)或者变量(var)，并返回true，否则返回false
 */

var height: Float? = 1.8

if let h = height {
    print(h)
} else {
    print("height is nil")
}

if let first = Int("4") {
    if let second = Int("42") {
        if first < second && second < 100 {
            print("\(first) < \(second) < 100")
        }
    }
}
//等价于
if let first = Int("4"),let second = Int("42"), first < second && second < 100 {
    print("\(first) < \(second) < 100")
}

let str: [String] = ["10", "20", "a", "-10","30"]

var idx = 0
var sum = 0
while let num = Int(str[idx]), num > 0 {
    sum += num
    idx += 1
}

//MARK: 空合并运算符（??）
/*
 a ?? b
 a 是可选项
 b 是可选项 或者 不是可选项
 b 跟 a 的存储类型必须相同
 如果 a 不为nil，就返回 a
 如果 a 为nil，就返回 b
 如果 b 不是可选项，返回 a 时会自动解包

 var age : Int? = nil
 var age1 : Int? = 20
 var o = age ?? age1 o的值是可选类型 Int？
 var i = age ?? 10 i的值是Int类型
 var s = age ?? "" 会报错，??要求类型一致，与可选类型无关

 //自定义操作符（仿写??）
 infix operator ???
 func ???<T>(optional: T? , defaultValue: @autoclosure ()->T) -> T{
     if let value = optional { return value }
     return defaultValue()
 }

 func A() -> String{
     print("A is called!!!")
     return "A"
 }

 func B() -> String{
     print("B is called!!!")
     return "B"
 }

 let AorB = A() ??? B()
 let AorX = A() ??? "X"
 */

//let a: Int? = 1
//let b: Int? = 2
//let c = a ?? b //c为Int?, Optional(1)

//let a: Int? = 1
//let b: Int = 2
//let c = a ?? b //c为Int, 1

//let a: Int? = nil
//let b: Int? = 2
//let c = a ?? b //c为Int?, Optional(2)

//let a: Int? = nil
//let b: Int = 2
//let c = a ?? b //c为Int, 2

//let a: Int? = nil
//let b: Int? = nil
//let c = a ?? b //c为Int?, nil

//let a: Int? = 1
//let b: Int? = 2
//let c = a ?? b ?? 3 //c为Int, 1

//let a: Int? = nil
//let b: Int? = 2
//let c = a ?? b ?? 3 //c为Int, 2

//let a: Int? = nil
//let b: Int? = nil
//let c = a ?? b ?? 3 //c为Int, 3

let a: Int? = nil;
let b: Int? = 2

if let c = a ?? b {
    print(c)
}// 类似于if a != nil || b != nil

if let d = a, let e = b {
    print(d,e)
}// 类似于if a != nil && b != nil

//MARK: guard语句
/*
 guard 条件 else {
 // do something....
 退出当前作用域
 // return、break、continue、throw error
 }
 */

func guardFunc() {
    let gStr: String? = ""
    guard let s = gStr else {
        return
    }
    print("gStr is not empty")
}

guardFunc()

//MARK: 隐式解包
var z: Int! = 1
z += 1

//下面写法报错
//var x: Int! = nil
//var y: Int = x

var cat: String? = "cat"
print("miaomiao~ is \(cat ?? "animal")")

//MARK: 多重可选项
var v1: Int?? = 10
//v1: Int?? -> Int? -> Int(10)

//: [Next](@next)
