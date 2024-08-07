//: [Previous](@previous)

import Foundation

var greeting = "Hello, Access Control"

//MARK: - 访问控制
/*
 • Swift提供了5个不同的访问级别（以下是从高到低排列， 实体指被访问级别修饰的内容）
 - open：允许在定义实体的模块、其他模块中访问，允许其他模块进行继承、重写（open只能用在类、类成员上）
 - public：允许在定义实体的模块、其他模块中访问，不允许其他模块进行继承、重写
 - internal：只允许在定义实体的模块中访问(当前Targets)，不允许在其他模块中访问
 - fileprivate：只允许在定义实体的源文件中访问
 - private：只允许在定义实体的封闭声明中访问（当前作用域内）
 
 • 绝大部分实体默认都是internal级别
 
 • 一个实体不可以被更低访问级别的实体定义，例如：
 - 变量类型的访问级别 >= 变量的访问级别
 - 参数类型、返回值类型 >= 函数
 - 父类 >= 子类
 - 父协议 >= 子协议
 - 原类型 >= typealias
 - 原始值类型、关联值类型 >= 枚举类型
 - 定义类型A时用到的其它类型 >= 类型A
 - ......
 */

//错误示例：
//fileprivate class Person { }
//internal var person: Person

//正确示例：
public class Person { }
internal var person: Person

//MARK: - 各种类型访问级别
//MARK: 元组 - 元组类型的访问级别是所有成员类型最低的那个级别
internal struct Dog { }
fileprivate class Cat { }
fileprivate var data1: (Dog, Cat)
private var data2: (Dog, Cat)

/*
 Dog类型访问级别是internal，Cat类型访问级别是fileprivate，所以元组类型访问级别是fileprivate
 */

//MARK: 泛型 - 泛型类型的访问级别是类型的访问级别以及所有泛型类型参数的访问级别中最低的那个级别
internal protocol Foo1 { }
fileprivate protocol Foo2 { }
public class Foo<T1, T2> { }
fileprivate var p = Foo<Foo1, Foo2>()

//MARK: 成员/嵌套类型
//类型的访问级别会影响成员（属性、方法、初始化器，下标）、嵌套类型的默认访问级别。
//1.类型为private或fileprivate
//一般情况下，类型为private或fileprivate，那么成员/嵌套类型默认也是private或fileprivate。
//变量age、函数run、嵌套类型Season的访问级别是private。
private class Animal {
    var age = 0
    func run() { }
    enum Seaon { case spring, summer }
}

//2. 类型为internal或public
//一般情况下，类型为internal或public，那么成员/嵌套类型默认是internal。
//变量age、函数run、嵌套类型Season的访问级别是internal。
public class Animal1 {
    var age = 0
    func run() { }
    enum Seaon { case spring, summer }
}

public class PublicClass { // public
    public var p1 = 0 // public
    var p2 = 0 // internal
    fileprivate func f1() { } // fileprivate
    private func f2() { } // private
}

class InternalClass { // internal
    var p = 9 // internal
    fileprivate func f1() { } // fileprivate
    private func f2() { } // private
}

fileprivate class FileprivateClass { // fileprivate
    func f1() { } // fileprivate
    private func f2() { } // private
}

private class PrivateClass { // private
    func f() { } // private
}

//MARK: 成员的重写
//子类重写的成员访问级别必须 ≥子类的访问级别，或者≥父类被重写成员的访问级别）
//示例1：父类的成员不能被成员作用域外定义的子类重写。

//错误示例：
//public class Person {
//    private var age: Int = 0
//}
//public class Student: Person {
//    override var age: Int {
//        set { }
//        get { 10 }
//    }
//}

//正确示例：
//public class Person {
//    private var age: Int = 0
//    public class Student: Person {
//        override var age: Int {
//            set { }
//            get { 10 }
//        }
//    }
//}

//示例2：示例代码能否编译通过？
//private class Person { }
//fileprivate class Student : Person { }

//1.如果把示例代码放到最外层（main文件为例），编译正常
//2.如果把示例代码放到internal类中,报错：父类级别需要大于子类级别。

//示例3：
//!!!: 如果把示例代码放到最外层，修饰Dog结构体的private等价于fileprivate，其内部的age、run()，均为fileprivate，所以可以在Person中访问。
//private struct Dog {
//    var age: Int = 0
//    func run() { }
//}
//
//fileprivate struct Person {
//    var dog: Dog = Dog()
//    mutating func walk() {
//        dog.run()
//        dog.age = 1
//    }
//}

//放到类中报错，放到源文件根层就编译正常
//如果上面的代码中Dog成员变量和内部函数都加上private访问限制会怎样呢?
//private struct Dog {
//    private var age: Int = 0
//    private func run() { }
//}
//
//fileprivate struct Person {
//    var dog: Dog = Dog()
//    mutating func walk() {
//        dog.run()
//        dog.age = 1
//    }
//}
//报错：因为Dog的内部成员变量和函数都是用private控制的，所以仅限在Dog内部使用，外部无法访问
//直接在全局作用域下定义的private等价于fileprivate

//示例4：
class Test {
    private struct Dog {
        var age: Int = 0
        func run() { }
    }
    private struct Person {
        var dog: Dog = Dog()
        mutating func walk() {
            dog.run()
            dog.age = 1
        }
    }
}
//!!!: Dog虽然被private修饰，但是Person中还是可以使用Dog及其内部属性的。Dog中的属性访问权限默认跟随类型是private，但是没有明确声明访问权限时，内部属性的作用域和类型相同。所以在Person中可以使用Dog的内部属性，如果明确声明访问级别，情况则会不同，比如明确age为private，则Person的walk()中不能使用age属性，会报错。

//MARK: getter和setter
//getter、setter默认自动接收它们所属环境的访问级别。
//可以给setter单独设置一个比getter更低的访问级别，用来限制写的权限（不能单独给getter设置权限）。

//示例代码：
//fileprivate(set) public var num = 10
//class Person {
//    private(set) var age = 0
//    fileprivate(set) public var weight: Int {
//        set { }
//        get { 10 }
//    }
//    internal(set) public subscript(index: Int) -> Int {
//        set { }
//        get { index }
//    }
//}
//
//var p = Person()
//p.age = 10 //报错

//MARK: 初始化器
//如果一个public类想在另一个模块调用编译生成的默认无参初始化器，必须显式提供public的无参初始化器。因为public类的默认初始化器是internal级别
//1.可以供外界使用无参初始化器
//public class Person {
//    public init() { }
//}
//var p = Person()

//2.required初始化器 ≥ 它的默认访问级别
//public class Person {
//    //使用 fileprivate 报错，使用 internal 是ok的
//    fileprivate required init() {
//        
//    }
//}

//3.如果结构体有private/fileprivate的存储实例属性，那么它们的成员初始化器也是private/fileprivate，否则默认就是internal
//struct Point {
//    fileprivate var x = 0
//    var y = 0
//}
//var p = Point(x: 10, y: 20)
//Point(x: 10, y: 20)的访问级别是fileprivate

//struct Point {
//    private var x = 0
//    var y = 0
//}
//var p = Point(y: 20) //报错
//只要有一个存储属性是private，所有成员初始化器都不能使用（编译器也不再自动生成），只能使用无参初始化器

//MARK: 枚举
/*
 - 不能给enum的每个case单独设置访问级别
 - 每个case自动接收enum的访问级别
 - public enum定义的case也是public（和结构体/类不同）
 */

//MARK: 协议
/*
 - 协议中定义的成员，自动接收协议的访问级别，不能单独设置访问级别（和枚举类似）
 - 协议实现的访问级别必须≥类型的访问级别，或者≥协议的访问级别
 - Swift标准库中的协议，默认访问级别为public
 */

//internal protocol Runnable {
//    func run()
//}
//
//fileprivate class Person : Runnable {
//    public func run() {
//        
//    }
//}
//协议实现func run() {}的访问级别≥（取类型Person的访问级别 和 协议Runnable的访问级别两者最低的级别）

//public protocol Runnable {
//    func run()
//}
//
//public class Person : Runnable {
//    //这里实现协议方法，必须使用public
//    public func run() {
//        
//    }
//}

//MARK: 扩展
/*
 - 如果有显式设置扩展的访问级别，扩展添加的成员自动接收扩展的访问级别
 - 如果没有显式设置扩展的访问级别，扩展添加的成员的默认访问级别，跟直接在类型中定义的成员一样
 - 可以单独给扩展添加的成员设置访问级别
 - 不能给用于遵守协议的扩展显式设置扩展的访问级别
 - 在同一文件中的扩展，可以写成类似多个部分的类型声明
    - 在原本的声明中声明一个私有成员，可以在同一文件的扩展中访问它
    - 在扩展中声明一个私有成员，可以在同一文件的其他扩展中、原本声明中访问它
 */

//class Person {
//    
//}
//报错：不能给用于遵守协议的扩展显式设置扩展的访问级别
//fileprivate extension Person :  Equatable {
//
//}

//public class Person {
//    private func run0() { }
//    private func eat0() {
//        run1()
//    }
//}
//
//extension Person {
//    private func run1() { }
//    private func eat1() {
//        run0()
//    }
//}
//
//extension Person {
//    private func eat2() {
//        run1()
//    }
//}

//MARK: 将方法赋值给var/let
//方法也可以像函数那样，赋值给一个let或者var
//struct Person {
//    var age: Int
//    func run(_ v: Int) {
//        print("func run", age, v)
//    }
//    static func run(_ v: Int) {
//        print("static func run", v)
//    }
//}
//
//let fn1 = Person.run
//fn1(10) // 输出：static func run 10
//
//let fn2: (Int) -> () = Person.run
//fn2(20) // 输出：static func run 20
//
//// 实例传给变量：Person.run 方法引用（这里编译器推导出的方法为实例方法）
//let fn3: (Person) -> ((Int) -> ()) = Person.run
//fn3(Person(age: 18))(30) // 输出：func run 18 30

//: [Next](@next)
