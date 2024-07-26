//: [Previous](@previous)

import Foundation

var greeting = "Hello, String and Array"

//MARK: - 字符串
let s1 = "Hi! This is a string. Cool?"

/// 转义符 \n 表示换行。
/// 其它转义字符有 \0 空字符)、\t 水平制表符 、\n 换行符、\r 回车符
let s2 = "Hi!\nThis is a string. Cool?"

// 多行，多行内容必须在"""后面新起一行
let s3 = """
Hi!
This is a string.
Cool?
"""

// 长度
print(s3.count)
// 判断是否为空
print(s3.isEmpty)

// 拼接
print(s3 + "\nSure!")

// 字符串中插入变量
let i = 1
print("Today is good day, double \(i)\(i)!")

/// 遍历字符串
/// 输出：
/// o
/// n
/// e
for c in "one" {
    print(c)
}

// 查找
print(s3.lowercased().contains("cool")) // true

// 替换
let s4 = "one is two"
let newS4 = s4.replacingOccurrences(of: "two", with: "one")
print(newS4)

// 删除空格和换行
let s5 = " Simple line. \n\n  "
print(s5.trimmingCharacters(in: .whitespacesAndNewlines))

// 切割成数组
let s6 = "one/two/three"
let a1 = s6.components(separatedBy: "/") // 继承自 NSString 的接口
print(a1) // ["one", "two", "three"]

let a2 = s6.split(separator: "/")
print(a2) // ["one", "two", "three"] 属于切片，性能较 components 更好

// 判断是否是某种类型
let c1: Character = "🤔"
print(c1.isASCII) // false
print(c1.isSymbol) // true
print(c1.isLetter) // false
print(c1.isNumber) // false
print(c1.isUppercase) // false

// 字符串和 Data 互转
let data = Data("hi".utf8)
let s7 = String(decoding: data, as: UTF8.self)
print(s7) // hi

// 字符串可以当作集合来用。
let revered = s7.reversed()
print(String(revered))

//MARK: - 字符串内存
/*
 • 一个String变量占用16个字节
 
 - 字符串长度不超过15位，内容直接存储在变量内存中
 - 字符串长度超过15位，内容存储在常量区
    - 内存中的后8个字节存放的是字符串内容的真实存放内存地址
    - 前8个字节存放字符串长度以及标识（标识字符串存放区域）
 - 只要超过15位拼接字符串，都会重新开辟堆空间存放字符串内容
 */

//MARK: - Array
/*
 官方定义的数组是结构体(值类型)：
 public struct Array<Element>
 */

/*
 • 结构体:
 - 结构体的内存占用大小是结构体中的变量占用内存之和
 */
struct Point {
    var x = 0, y = 0
}
var p = Point()
print(MemoryLayout.stride(ofValue: p))
//打印结果：16

//Array
var arr = [1, 2, 3, 4]
print(MemoryLayout.stride(ofValue: arr))
//打印结果：8

var arr1 = ["hello","world"]
print(MemoryLayout.stride(ofValue: arr1))
//打印结果：8

/*
 • 数组：
 - 数组的打印结果均为8，这与数组中存储的属性类型无关，这是因为数组的表象是结构体，但其本质是引用类型，
   arr、arr1是数组对象的引用（指针），指针在64位架构上，大小为8字节。
 - 内存布局：
    数组需要跳过前32个字节，才是存储的具体数据。
    前32个字节内容如下：
        第一段8个字节：存放着数组相关引用类型信息内存地址
        第二段8个字节：数组的引用计数
        第三段8个字节：数组的元素个数
        第四段8个字节：数组的容量
 - 数组的容量会自动扩容至元素个数的两倍，且是8的倍数。
*/

//: [Next](@next)
