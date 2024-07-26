//: [Previous](@previous)

import Foundation

var greeting = "Hello, array"

//MARK: - Array函数式操作

var arr = [1, 2, 3, 4]

//MARK: map（映射）
var mArr = arr.map {
    element -> Int in
    return element * 2
}
print(mArr) // 输出：[2, 4, 6, 8]

// 简化写法
// var mArr = arr.map { $0 * 2 }
// print(mArr) // 输出：[2, 4, 6, 8]

//MARK: filter（过滤）
var fArr = arr.filter {
    element -> Bool in
    return element % 2 == 0
}
print(fArr) // 输出：[2, 4]

// 简化写法
// var fArr = arr.filter { $0 % 2 == 0 }
// print(fArr) // 输出：[2, 4]

//MARK: reduce（累计）
/*
 - 第一个参数是初始值
 - 第二个参数是闭包表达式
    - 第一个参数是闭包返回值，首次传入的参数值是reduce函数的第一个参数即初始值
    - 第二个参数是数组元素，函数返回值作为下一次遍历时闭包表达式的第一个参数），数组遍历完成后把结果返回
 */
var rArr = arr.reduce(0) { (result, element) -> Int in
    return result + element
}
print(rArr)

// 简化写法一
// var rArr = arr.reduce(0) { $0 + $1 }
// print(rArr) // 输出：10

// 简化写法二
//var rArr = arr.reduce(0, +)
// print(rArr) // 输出：10

//MARK: flatMap（元素平铺映射）
/*
 - map是返回一个泛型元素数组，返回值是什么，最终返回的数组元素就是什么
 - flatMap返回元素值是Sequence类型，而数组就是Sequence类型，如果flatMap传入的是一个数组，
   函数会把传入的数组所有元素平铺放到一个新的数组中返回
 */
// repeating：重复元素  count：重复次数
var iarr = Array.init(repeating: 3, count: 4);
print(iarr) // 输出：[3, 3, 3, 3]

var rptArr = arr.map {
    Array.init(repeating: $0, count: $0)
}
print(rptArr) // 输出：[[1], [2, 2], [3, 3, 3], [4, 4, 4, 4]]

var flatArr = arr.flatMap {
    Array.init(repeating: $0, count: $0)
}
print(flatArr) // 输出：[1, 2, 2, 3, 3, 3, 4, 4, 4, 4]

//MARK: compactMap（元素压缩映射）
//compactMap可以自动解包可选值，非nil元素会被解包放到新的数组中
var sArr = ["123", "hi", "-20"]
var oArr = sArr.map { Int($0) }
print(oArr) //[Optional(123), nil, Optional(-20)]

var cArr = sArr.compactMap{ Int($0) }
print(cArr) //[123, -20]

//MARK: lazy
let result = arr.map {
    (i: Int) -> Int in
    print("mapping \(i)")
    return i * 2
}
print("begin---")
print("mapped \(result[0])")
print("mapped \(result[1])")
print("mapped \(result[2])")
print("end---")

/*
 输出：
 mapping 1
 mapping 2
 mapping 3
 mapping 4
 begin---
 mapped 2
 mapped 4
 mapped 6
 end---
 */
//使用数组result前，数组已经被map遍历完成。有没有可能用到result时再去执行map？可以的，使用lazy
let lResult = arr.lazy.map {
    (i: Int) -> Int in
    print("mapping \(i)")
    return i * 2
}
print("begin---")
print("mapped \(lResult[0])")
print("mapped \(lResult[1])")
print("mapped \(lResult[2])")
print("end---")

/*
 输出：
 begin---
 mapping 1
 mapped 2
 mapping 2
 mapped 4
 mapping 3
 mapped 6
 end---
 */

//MARK: - Optional的map和flatMap
//map 对可选类型操作时，闭包表达式传入的是解包后的值，map 的返回值类型也是可选类型，传入的可选类型是nil，返回也是nil
var num1: Int? = 10
print(num1 as Any) // 输出：Optional(10)

var num2 = num1.map {
    i -> Int in
    print(i) // 输出：10
    return i * 2
}
print(num2 as Any) // 输出：Optional(20)

var num3: Int? = nil
print(num3 as Any) // 输出：nil

var num4 = num3.map { $0 * 2}
print(num4 as Any) // 输出：nil

//!!!: map 和 flatMap
//如果map传入的是可选类型，闭包表达式中返回的也是可选类型，最终返回的是双重可选类型（会自动再次包装一层可选类型）
//但是flatMap发现返回的是可选类型时不会再次包装，如果不是可选类型就会再次包装一层
var num5: Int? = 10
var num6 = num5.map { Optional.some($0 * 2) }
print(num6 as Any) // 输出：Optional(Optional(20))

var num7 = num5.flatMap { Optional.some($0 * 2) }
print(num7 as Any) // 输出：Optional(20)

//应用场景一:下面代码中n2和n3是等价的
var n1: Int? = 10
var n2 = (n1 != nil) ? (n1! + 10) : nil
var n3 = n1.map { $0 + 10 }

//应用场景二:下面代码中date1和date2是等价的
var fmt = DateFormatter()
fmt.dateFormat = "yyyy-MM-dd"
var str: String? = "2008-08-08"
var date1 = str != nil ? fmt.date(from: str!) : nil
var date2 = str.flatMap(fmt.date)

//应用场景三:下面代码中str1和str2是等价的
var score: Int? = 98
var str1 = score != nil ? "Score is \(score ?? 0)" : "No score"
var str2 = score.map { "Score is \($0)" } ?? "No score"
//??前面如果是可选类型，后面是非可选类型，当可选类型值非nil时会自动解包

//应用场景四:根据name找到对应Person实例。p1和p2是等价的
struct Person {
    var name: String
    var age: Int
}
var items = [
    Person(name: "jack", age: 20),
    Person(name: "rose", age: 21),
    Person(name: "kate", age: 22)
]
func p1(_ name: String) -> Person? {
    let index = items.firstIndex { $0.name == name }
    return index != nil ? items[index!] : nil
}
func p2(_ name: String) -> Person? {
    return items.firstIndex { $0.name == name }.map { items[$0] }
}

//应用场景五:字典转模型，下面示例中p1和p2的代码是等价的
struct Student {
    var name: String
    var age: Int
    init?(_ json: [String : Any]) {
        guard let name = json["name"] as? String,
              let age = json["age"] as? Int
        else {
            return nil
        }
        self.name = name
        self.age = age
    }
}
var json: Dictionary? = ["name" : "idbeny", "age" : 18]
var s1 = json != nil ? Student(json!) : nil
var s2 = json.flatMap(Student.init)

/*
 Person.init 是对 Person 结构体初始化方法的引用，类型是 ([String: Any]) -> Person?
 等同于 Person(["name" : "idbeny", "age" : 18])
 使用 flatMap 方法可以简化可选值的处理和初始化过程
 */

//: [Next](@next)
