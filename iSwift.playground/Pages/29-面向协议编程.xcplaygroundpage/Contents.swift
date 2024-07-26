//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

/*
 • 面向协议编程（Protocol Oriented Programming，简称POP）
 - 是Swift的一种编程范式，Apple于2015年WWDC提出。在Swift的标准库中，能见到大量POP的影子
 */

//MARK: - POP和OOP
//MARK: OOP
/*
 • Swift也是一门面向对象的编程语言（Object Oriented Programming，简称OOP）
 • OOP三大特性：
    - 封装
    - 继承
    - 多态
 */

/*
 • 公共方法抽取
 */

//如何将BVC、DVC的公共方法run抽取出来？
//class BVC: UIViewController {
//    func run() {
//        print("run")
//    }
//}
//
//class DVC: UITableViewController {
//    func run() {
//        print("run")
//    }
//}

/*
 - OOP解决方案：
    1.将run方法放到另一个对象A中，然后BVC、DVC拥有对象A属性
    2.将run方法添加到UIViewController分类中（UITableViewController继承自UIViewController）
    3.将run方法抽取到新的父类，采用多继承（C++支持多继承）
 - 问题：
    1.增加了额外的依赖关系
    2.导致UIViewController越来越臃肿，而且会影响它的其他所有子类
    3.虽然在iOS开发中用不到，但在C++中使用也会增加程序设计的复杂度，产生菱形继承等问题，需要开发者额外解决
 */

/*
 - POP解决方案:
    1.定义一个协议，同时定义公共方法run。扩展协议并实现抽象方法run，类遵守协议即可
 */
protocol Runnable {
    func run()
}

extension Runnable {
    func run() {
        print("run")
    }
}

//class BVC: UIViewController, Runnable { }
//class DVC: UITableViewController, Runnable { }

/*
 - 相比较OOP，POP的解决方案更加简洁。因为协议支持扩展实现，使得Swift使用POP非常便捷
 - 在Swift开发中，OOP和POP是相辅相成的，任何一方并不能取代另一方。POP能弥补OOP一些设计上的不足
 */

/*
 POP的注意点：
 - 优先考虑创建协议，而不是父类（基类）
 - 优先考虑值类型（struct、enum），而不是引用类型（class）
 - 巧用协议的扩展功能
 - 不要为了面向协议而使用协议（有时候使用类更合理）
 */

//MARK: - 利用协议实现类型判断
//场景：判断传入的实例参数是不是数组
//示例代码：
func isArray(_ value: Any) -> Bool {
    value is [Any]
}
print(isArray([1, 2])) // 输出：true
print(isArray(["1", 2])) // 输出：true
print(isArray(NSArray())) // 输出：true
print(isArray(NSMutableArray())) // 输出：true
print(isArray("123")) // 输出：false

//场景：判断传入的类型参数是不是数组。
//示例代码：
protocol ArrayType { }
extension Array: ArrayType { }
extension NSArray: ArrayType { }
func isArrayType(_ type: Any.Type) -> Bool {
    //!!!: 判断协议类型即可
    type is ArrayType.Type
}
print(isArrayType([Int].self)) // 输出：true
print(isArrayType([Any].self)) // 输出：true
print(isArrayType(NSArray.self)) // 输出：true
print(isArrayType(NSMutableArray.self)) // 输出：true

/// 前缀类型
struct BB<T> {
    private var t: T
    init(_ t: T) {
        self.t = t;
    }
}

/// 利用协议扩展前缀属性
protocol BBCompatible { }
extension BBCompatible {
    var bb: BB<Self> {
        set { }
        get { BB(self) }
    }
    static var bb: BB<Self>.Type {
        set { }
        get { BB<Self>.self }
    }
}

/// 给字符串扩展功能
/// 使String拥有bb前缀属性
extension String : BBCompatible { }
/// 给String.bb、String().bb前缀扩展功能
extension BB where T == String {
    var numberCount: Int {
        var count = 0
        for c in t where ("0"..."9").contains(c) {
            count += 1
        }
        return count
    }
    
    static func foo() {
        
    }
    
    mutating func change() {
        
    }
}

class Person {}

extension Person : BBCompatible {
    var bb: BB<Person> { BB(self) }
}

extension BB where T : Person {
    func run() {
        
    }
}

"123qwer".bb.numberCount
String.bb.foo();

var str = "abc123"
str.bb.change()

Person().bb.run()

//: [Next](@next)
