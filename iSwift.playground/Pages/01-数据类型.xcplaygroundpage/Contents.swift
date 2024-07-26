let greeting = "hi，数据类型"

//常量
//只能赋值一次,不要求编译时期确定,但使用之前必须赋值

//MARK: - 数据类型
//定义时赋值
let age : Int = 20
//或者，类型推导
let age1 = 20

//定义时未赋值，但是必须定义类型
let month : Int
month = 12

//变量
//可多次修改变量的值
var name : String = "roes"
name = "jack"
name = "tom"

//字面量
//1.布尔
let bool = true

//2.字符串
let string = "iSwift"

//3.字符
let character : Character = "😄"

//整数
let intDecimal = 10 //十进制
let intBinary = 0b1010 //二进制
let intOctal = 0o12 //八进制
let intHexadecimal = 0xA //十六进制

//浮点数
let doubleDecimal = 125.0 //十进制
let doubleHexadecimal = 0xFp2 //十六进制

//数组-有序，元素不唯一
let array = [1, 2, 3, 1];

//Set-无序，元素唯一(即使存在相同元素，也会默认只有一个)
let set: Set = ["hello","world"]

//字典
let dictionary = ["age" : 20, "height" : 170]

//类型转换
let uint16 : UInt16 = 2_000
let uint32 : UInt32 = 1

let uintSum = uint32 + UInt32(uint16)

//元组
let error : (_,_) = (404, "not found")
print("The status code is \(error.0), desc is \(error.1)")

let success = (code:200, desc:"ok")
print("The status code is \(success.code), desc is \(success.desc)")

//MARK: - 注释

//单行注释

/*
 多行注释
 */

/*
 1
    /*
     嵌套多行注释
     */
 2
 */

//MARK: - Xcode中常用标记：
//MARK: 标记，和#pragma mark效果类似（无分割线）
//MARK: - 标记，和#pragma mark - 效果类似（有分割线）
//TODO: 标示处有功能代码待编写
//FIXME: 标示处代码需要修正
//!!!: 标示处代码需要注意（警告）
//???: 标示处代码有疑问 （这里代码是个坑）
//#warning("msg")用来做全局提示

/**
    两个整数相加
    # 加法（标题一）
    这个方法执行整数的加法运算。
    ## 加法运算（标题二）
    想加个试试看
 
    中间隔着一个横线
    ***
 
    代码块的*使用*方法:
    ```
        let num = func add(a: 1, b: 2)
        // print 3
    ```
 
    - Parameters:
        - a: 加号左边的整数
        - b: 加号右边的整数
    - Returns: 和
 
     - c: 参数一
     - d: 参数二
     - f: 参数三
 
    - Throws: 抛出错误，此方法不抛出错误，只为另外演示注释用法。
    - Important: 注意这个方法的参数。
    - Version: 1.0.0
    - Authors: Wei You, Fang Wang
    - Copyright: 版权所有
    - Date: 2020-12-28
    - Since: 1949-10-01
    - Attention: 加法的运算
    - Note: 提示一下，用的时候请注意类型。
    - Remark: 从新标记一下这个方法。
    - Warning: 警告，这是一个没有内容的警告。
    - Bug: 标记下bug问题。
    - TODO: 要点改进的代码
    - Experiment: 试验点新玩法。
    - Precondition: 使用方法的前置条件
    - Postcondition：使用方法的后置条件
    - Requires: 要求一些东西，才能用这个方法。
    - Invariant: 不变的
 */
func add(a: Int, b: Int) throws -> Int {
    return a + b
}

//MARK: - Markup语法（仅Playground中有效）
/*:
 # Title
 ## Title2
 ### Title3
 * Line 1
 * Line 2
*/

//: **Bold** *Italic*

//:[肘子的 Swift 记事本](https://fatbobman.com)

//:![图片，可以设置显示大小](pic.png width="400" height="209")

/*:
    // 代码片段
    func test() -> Stirng {
        print("Hello")
    }

 */

//!!!: 开启Markup渲染效果：Editor -> Show Rendered Markup

//: [Next](@next)
