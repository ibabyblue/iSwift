//: [Previous](@previous)

import Foundation

var greeting = "Hello, enum"

//MARK: - 基本使用
//!!!: Apple建议枚举名称首字母大写，枚举成员名称小写

enum Direction {
    case east
    case south
    case west
    case north
}

//enum Direction {
//    case east, south, west, north
//}

var dir = Direction.east

dir = Direction.north
dir = .south
print(dir)

//MARK: - 原始值（Raw Values）
// - Swift中的枚举需要指定枚举类型，才会有原始值
// - Direction就没有原始值
// - 原始值必须类型统一且唯一
//!!!: 注意：原始值不占用枚举变量的内存
enum Grade : String {
    case perfect = "A"
    case great = "B"
    case good = "C"
    case bad = "D"
}

print(Grade.perfect.rawValue) //A
print(Grade.great.rawValue) //B
print(Grade.good.rawValue) //C
print(Grade.bad.rawValue) //D

//如果String类型的枚举没有指定枚举成员的原始值，则成员名称即原始值，称为隐式原始值
enum PokerSuit : String {
    case spade
    case heart
    case diamond
    case club
}
print(PokerSuit.spade.rawValue) //spade

//如果整数类型的枚举没有指定枚举成员的原始值，则枚举成员的原始值 = 上一个枚举成员的原始值 + 1
enum Season : Int {
    case spring = 1, summer, autumn = 4, winter
    
    init?(i: Int) {
        switch i {
        case 1:
            self = .spring
        case 2:
            self = .summer
        case 4:
            self = .autumn
        case 5:
            self = .winter
        default:
            return nil
        }
    }
}
print(Season.spring.rawValue) // 1
print(Season.summer.rawValue) // 2
print(Season.autumn.rawValue) // 4
print(Season.winter.rawValue) // 5

//初始化：
//第一种：使用原始值初始化
//可失败的初始化器（可选类型），因为传入的参数可能不存在，
let s = Season(rawValue: 0) // s 为 nil
//自定义初始化器（可选类型）
let i = Season(i: 5)

//第二种：通过枚举成员初始化
//let s = Season.summer

//MARK: - 关联值（Associated Values）
/*
 - !!!: 关联值的成员 没有原始值
 - 原因:
    因为rawValue是遵从了RawRepresentable协议,协议中通过associatedtype来关联rawValue，associatedtype是用来定义在协议
    中使用的关联类型，虽然这个关联类型是不确定的，但是它们是统一的。而有关联值的枚举，它们的类型是不统一的，所以无法使用rawValue
 */

enum Score {
    case points(Int)
    case grade(String)
}

var score = Score.points(100)
score = .grade("A")

/*
 可以提取关联值 用 "let / var" 修饰
 通过值绑定,生成的 "局部变量"  就与 "关联值" 相连接
 */
switch score {
case .points(let i):
    print(i,"points")
case let .grade(i):
    print("grade", i)
}
//grade A

enum Date {
    case digit(year: Int, month: Int, day: Int)
    case string(String)
}

var date = Date.digit(year: 2024, month: 05, day: 19)
date = .string("2024-05-19")

switch date {
case let .digit(year, month, day):
    print(year, month, day)
case .string(let value):
    print(value)
}

//optional:枚举类型-关联值
var age: Int?
age = 17

switch age {
case .none:
  print("age 为 nil")
case .some(let value):
  print("age 的值是: \(value)")
}
// 打印： age 的值是 17

//递归枚举
indirect enum ArithExpr {
    case number(Int)
    case sum(ArithExpr, ArithExpr)
    case difference(ArithExpr, ArithExpr)
}

//enum ArithExpr {
//    case number(Int)
//    indirect case sum(ArithExpr, ArithExpr)
//    indirect case difference(ArithExpr, ArithExpr)
//}

let five = ArithExpr.number(5)
let four = ArithExpr.number(4)
let two = ArithExpr.number(2)
let sum = ArithExpr.sum(five, four)
let difference = ArithExpr.difference(sum, two)

func calculate(_ expr: ArithExpr) -> Int {
    switch expr {
    case let .number(value):
        return value
    case let .sum(left, right):
        return calculate(left) + calculate(right)
    case let .difference(left, right):
        return calculate(left) - calculate(right)
    }
}
calculate(difference)

//MARK: - 枚举的属性
enum KFCFood {
    case familyFood(Int)
    case Other(String, String, String)
    
    var description: String {
        switch self {
        case .familyFood(let num):
            return "KFC - 中午吃了 \(num) 个全家桶"
        case let .Other(s1, s2, s3):
            return "KFC - 晚餐吃了\(s1)  \(s2) 还有 \(s3)"
        }
    }
}

var k = KFCFood.familyFood(2)
print(k.description) // 中午吃了 2 个全家桶


k = .Other("汉堡", "可乐", "薯条")
print(k.description) // 晚餐吃了汉堡  可乐 还有 薯条

//!!!: 因为是关联值类型，所以不能使用rawValue的方式初始化，也就是说通过关联值初始化的实例都是存在的，所以switch里面不需要default的case。

//MARK: - 枚举的扩展和协议
protocol Eat {
    var description: String {
        get
    }
}

enum Mcdonald {
    case familyFood(Int)
    case Other(String, String, String)
}

extension Mcdonald : Eat {
    var description: String {
        switch self {
        case .familyFood(let num):
            return "Mcdonald - 中午吃了 \(num) 个全家桶"
        case let .Other(s1, s2, s3):
            return "Mcdonald - 晚餐吃了\(s1)  \(s2) 还有 \(s3)"
        }
    }
}

//MARK: - 枚举的方法
enum Song : String {
    case english
    case chinese
    
    func songName() -> String {
        switch self {
        case .english:
            return "english"
        case .chinese:
            return "chinese"
        }
    }
    
    //!!!: mutating 关键字用于修饰结构体（struct）和枚举（enum）中的方法，使得这些方法能够修改实例的属性。只能修饰方法。
    mutating func changeSong() {
        switch self {
        case .chinese:
            self = .english
        case .english:
            self = .chinese
        }
    }
}

var song: Song = Song.chinese
var songName = song.songName()
song.changeSong()

//: [Next](@next)
