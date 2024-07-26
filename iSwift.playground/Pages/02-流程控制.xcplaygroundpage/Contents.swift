//: [Previous](@previous)

import Foundation

let greeting = "hi，流程控制"

//MARK: - if-else
//判断条件必须为Bool类型，判断条件小括号可省略，条件后面的花括号不可省略
if true {
    //条件为真
    String("条件为真")
} else {
    //条件为假
    String("条件为假")
}

//MARK: - while
//判断条件小括号可省略，条件后面的花括号不可省略
var num: Int = 5
while (num > 0) {
    print("num is \(num)")
    num -= 1
}
//输出：5 4 3 2 1

//Swift2.2开始，废弃了自增（++）、自减（--）运算符
var rNum = -1
repeat {
    print("rNum is \(rNum)")
} while rNum > 0
//输出：-1

//MARK: - for
//MARK: 闭区间运算符
let names = ["jack","rose","alex","anna"]
for i in 0...3 {
    print(names[i])
}
//输出：jack rose alex anna

for name in names[0...3] {
    print(name)
}
//输出：jack rose alex anna

let range = 1...3
for i in range {
    print(names[i])
}
//输出：rose alex anna

for _ in 0...2 {
    print("for")
}
//输出：for for for

//MARK: 半开区间运算符 a..<b（a <= 取值 < b）
for i in 0..<2 {
    print("for")
}
//输出：for for

//MARK: 单侧区间-让区间朝着一个方向尽可能的远
for name in names[2...] {
    print(name)
}
//输出：alex anna

for name in names[...2] {
    print(name)
}
//输出：jack rose alex

for name in names[..<2] {
    print(name)
}
//输出：jack rose

let sRange = ...3
sRange.contains(-1) //true
sRange.contains(2) //true
sRange.contains(3) //true
sRange.contains(4) //false

//MARK: - 区间类型
let aRange: ClosedRange<Int> = 0...5
let hRange: Range<Int> = 1..<5
let pRange: PartialRangeThrough<Int> = ...5

let stringRange = "cc"..."ff"
stringRange.contains("cf") //true
stringRange.contains("fg") //false

//所有ASCII字符
let characterRange: ClosedRange<Character> = "\0"..."~"
characterRange.contains("E") //true

//带间隔的区间值
for tickMark in stride(from: 2, to: 12, by: 2) {
    print(tickMark)
}
//输出：2 4 6 8 10

//MARK: - switch
//!!!: 1、必须保证处理所有情况（如处理了所有情况可以不写default） 2、case和default至少有一条语句，如无需处理，加break即可
//!!!: 每个case的break非必须，case后不能写大括号，如需贯穿到下个case 请使用fallthrough
let sNum = 2
switch sNum {
case 1:
    print("1")
case 2:
    print("2")
    fallthrough
default:
    print("unknown")
}
//输出：2 unknown

//MARK: 复合条件
//switch支持Character、String类型
let string = "jack"
switch string {
case "jack":
    fallthrough
case "rose":
    print("right person")
default:
    break
}
//等价于
switch string {
case "jack","rose":
    print("right person")
default:
    break
}

let c: Character = "a"

//MARK: 区间匹配、元组匹配
let count = 20
switch count {
case 0:
    print("none")
case 1..<5:
    print("小于5")
case 5...10:
    print("5~10")
case 11...20:
    print("11~20")
default:
    print("many")
}

let mPoint = (1, 1)
switch mPoint {
case (0, 0):
    print("the origin")
case (_, 0):
    print("on the x-axis")
case (0, _):
    print("on the y-axis")
case (-1...1, -1...1):
    print("inside the box")
default:
    print("outside of the box")
}

//MARK: 值绑定
let bPoint = (2,0)
switch bPoint {
case (let x, 0):
    print("on the x-axis with an x value of \(x)")
case (0, var y):
    print("on the y-axis with a y value of \(y)")
case let (x, y):
    print("somewhere else at (\(x),\(y)")
}

//MARK: where
let wPoint = (1,-1)
switch wPoint {
case let (x, y) where x == y:
    print("on the line x == y")
case (let x, let y) where x == -y:
    print("on the line x == -y")
case let (x, y):
    print("(\(x), \(y)) is just some arbitrary point")
}

//MARK: 标签语句
outer: for i in 1...4 {
    for j in 1...4 {
        if j == 3 {
            continue outer
        }
        
        if i == 3 {
            break outer
        }
        
        print("i == \(i), j == \(j)")
    }
}


//: [Next](@next)
