//: [Previous](@previous)

import Foundation

var greeting = "Hello, protocol"

//MARK: - 协议（Protocol）
/*
 • 协议:
 - 用来定义方法、属性、下标的声明，
 - 可以被枚举、结构体、类型遵守（多个协议使用逗号分隔）
 
 • 规则:
 - 协议中定义方法不能存在默认参数值
 - 默认遵守协议必须实现协议内容（方法、属性、下标）
    - 可以处理成可选实现协议内容
 */

//MARK: 可选协议
protocol FooProtocol {
    func foo()
    func foo(age: Int)
    func foo(name: String)
}

//在协议扩展中实现协议的默认实现，就可以实现可选协议
extension FooProtocol {
    func foo() {
        print("Implemented foo() in extension")
    }
}

class Foo: FooProtocol {
    
    func foo(age: Int) {
        print("Implemented foo(age: Int) in Person")
    }
    
    func foo(name: String) {
        print("Implemented foo(name: String) in Person")
    }
    
}

let f = Foo()
f.foo() //Foo 中并未实现此协议方法，故协议可选择实现
f.foo(age: 18)
f.foo(name: "jack")

//MARK: - 协议属性
/*
 • 协议实例属性
 - 协议中定义的属性必须使用var关键字
 - 实现协议属性时，权限大于等于声明时权限
    - 协议中定义get、set，用var存储属性或者get、set计算属性实现
    - 协议中定义的get，任何属性均可实现
 
 • 协议类型属性
 - 协议中必须使用static定义类型方法、类型属性、类型下标
    - 实现时可实现为使用class关键字，并非一定为static关键字
 */

//MARK: 实例属性、类型属性
protocol Drawable {
    func draw()
    var x: Int { get set }
    var y: Int { get }
    subscript(index: Int) -> Int { get set }
    static func painting()
}

class Person : Drawable {
    var x: Int = 0
    var y: Int = 0
    func draw() {
        print("Person draw()")
    }
    
    subscript(index: Int) -> Int {
        get { index }
        set {}
    }
    
    static func painting() {
        print("Person painting()")
    }
}

class Student : Drawable {
    private var _x : Int = 0
    var x: Int {
        get {
            _x
        }
        
        set {
            _x = newValue
        }
    }
    
    var y: Int {
        get { 0 }
    }
    
    func draw() {
        print("Studen draw()")
    }
    
    subscript(index: Int) -> Int {
        get { index }
        set {}
    }
    
    class func painting() {
        print("Studen painting()")
    }
}

//MARK: - mutating
/*
 • 实例方法使用 mutating 标记
 - 结构体、枚举可以实现在方法内修改自身内存，比如修改属性
 - 与类无关，mutating 仅针对于值类型的结构体、枚举，类是引用类型，本身就可修改
 */
protocol Paintable {
    mutating func painting()
}

struct Point : Paintable {
    var x = 0
    //结构体、枚举 必须使用 mutating 关键字
    mutating func painting() {
        x = 10
    }
}

class Size : Paintable {
    var width = 0
    //类中 不需要使用 mutating 关键字
    func painting() {
        width = 10
    }
}

//MARK: - 初始化器
/*
 - 协议中还可以定义初始化器init
    - 非final类实现时必须加上required
    - 值类型（结构体、枚举）实现时则不需要required
 
 - 如果从协议实现的初始化器，刚好是重写了父类的指定初始化器
    - 那么这个初始化必须同时加required、override
 */
protocol Livable {
    init(age: Int, name: String)
}

class Deadpool : Livable {
    var age = 0
    var name = ""
    //非 final 的类，实现协议初始化器必须使用 required
    required init(age: Int, name: String) {
        self.age = age
        self.name = name
    }
}

final class Ironman : Livable {
    var age = 0
    var name = ""
    //final 的类，实现协议初始化器则不必须使用 required
    init(age: Int, name: String) {
        self.age = age
        self.name = name
    }
}

class Man {
    init(age: Int, name: String) {
        
    }
}

class Venom : Man, Livable {
    //如果实现协议的初始化器刚好为父类的指定初始化器，则required、override需要同时使用
    required override init(age: Int, name: String) {
        super.init(age: age, name: name)
    }
}

//MARK: init、init?、init!
/*
 - 协议中定义的init?、init!，可以用init、init?、init!去实现
 - 协议中定义的init，可以用init、init!去实现
 */
protocol Initializable {
    init()
    init?(age: Int)
    init!(no: Int)
}

class new : Initializable {
    required init!(no: Int) {
        
    }
    //    required init?(no: Int)
    //    required init(no: Int)
    
    required init?(age: Int) {
        
    }
    //    required init!(age: Int)
    //    required init(age: Int)
    
    required init() {
        
    }
//    required init!()
}

//MARK: - 协议的继承
protocol Movable {
    func move()
}

protocol Runnable : Movable {
    func breath()
}

class Thor : Runnable {
    func move() {
        
    }
    
    func breath() {
        
    }
}

//MARK: - 协议组合
/*
 协议组合：多个协议使用逗号分隔，只允许最多一个类类型，也就是只能继承自一个类，比如下面的Woman类，C++中支持多继承，Swift中不支持
 */
protocol Magical {
    func magic()
}

func fn(obj: Runnable & Magical & Woman) {
    
}

class Woman {
    
}

class ScarletWitch : Woman, Runnable, Magical {
    func move() {
        
    }
    
    func breath() {
        
    }
    
    func magic() {
        
    }
}

fn(obj: ScarletWitch())

//MARK: - CaseIterable
//可迭代协议
enum Season : CaseIterable {
    case spring, summer, autumn, winter
}

let seasons = Season.allCases

for season in seasons {
    print(season)
}

//MARK: - CustomStringConvertible、 CustomDebugStringConvertible协议
/*
 都可以自定义实例的打印字符串
 */
class Phenix : CustomStringConvertible, CustomDebugStringConvertible {
    var age: Int = 0
    
    init(age: Int) {
        self.age = age
    }
    
    var description: String {
        "phenix_age:\(age)"
    }
    
    var debugDescription: String {
        "debug_phenix_age:\(age)"
    }
}

var phenix = Phenix(age: 6)
phenix.description
phenix.debugDescription

//MARK: - Any、AnyObject
/*
 • 二种特殊类型：
 - Any:可以代表任意类型（枚举、结构体、类，也包括函数类型）
 - AnyObject:可以代表任意类类型（在协议后面写上: AnyObject代表只有类能遵守这个协议）
 */

//此协议只能有类遵守，结构体和枚举不能遵守
protocol Interruptible : AnyObject {
    func interrupt()
}

//Any的使用
//第一种：
var any : Any = 10
any = "any"
any = Phenix(age: 10)

//第二种：
//创建1个能存放任意类型的数组
// var data = Array<Any>()
var data = [Any]()
data.append(1)
data.append(3.14)
data.append(Student())
data.append("Jack")
data.append({ 10 })

//MARK: - is、as?、as!、as
/*
 • is:判断是否为某种类型
 • as:强制类型转换
 */

class Groot : Man, Runnable {
    func move() {
        
    }
    
    func breath() {
        
    }
    
    func scream() {
        print("Groot scream")
    }
    
    override init(age: Int, name: String) {
        super.init(age: age, name: name)
    }
}

//var g : Any = 10
//print(g is Int)
//g = "jack"
//print(g is String)
//g = Groot(age: 1, name: "Groot")
//print(g is Groot)
//print(g is Man)
//print(g is Runnable)

var g: Any = 10
(g as? Groot)?.scream() // 没有调用scream
g = Groot(age:1, name: "Groot")
(g as? Groot)?.scream() // Groot scream
(g as! Groot).scream() // Groot scream
(g as? Runnable)?.breath() // Groot breath

var d = 10 as Double
print(d) // 10.0

//MARK: - X.self、X.Type、AnyClass
/*
 • X.self:是元类型（metadata）的指针，metadata存放着类型相关信息
 • X.self:属于X.Type类型
 */

class Animal {}
class Cat : Animal {}

var animType: Animal.Type = Animal.self
var catType: Cat.Type = Cat.self
animType = Cat.self

var anyType: AnyObject.Type = Animal.self
anyType = Cat.self

public typealias AnyClass = AnyObject.Type
var anyType2: AnyClass = Animal.self
anyType2 = Cat.self

var animal = Animal()
var animalType = type(of: animal) // Animal.self
print(Animal.self == type(of: animal)) // true

//MARK: 元类型应用
class Monkey { required init() {} }
class GoldenMonkey : Monkey {}
class Macaque : Monkey {}
class SpiderMonkey : Monkey {}
func create(_ clses: [Monkey.Type]) -> [Monkey] {
    var arr = [Monkey]()
    for cls in clses {
        arr.append(cls.init())
    }
    return arr
}
print(create([GoldenMonkey.self, Macaque.self, SpiderMonkey.self]))

//MARK: - Self
/*
 • 代表当前类型(当前类型的占位符)
 • 一般用作返回值类型，限定返回值跟方法调用者必须是同一类型（也可以作为参数类型）
 */
//1、代表当前类型
//class Person {
//    var age = 1
//    static var count = 2
//    func run() {
//        print(self.age) // 1
//        //当前类型 等于 Person
//        print(Self.count) // 2
//    }
//}

//2、一般用作返回值类型，限定返回值跟方法调用者必须是同一类型（也可以作为参数类型）
//protocol Runnable {
//    func test() -> Self
//}
//class Person : Runnable {
//    required init() {}
//    //这里的Self，可以理解为返回Person类型的实例，类似OC中：- (Person *)test { return [[Person alloc] init]; }
//    func test() -> Self { type(of: self).init() }
//}
//class Student : Person {}

//var p = Person()
//// Person
//print(p.test())
//var stu = Student()
//// Student
//print(stu.test())

//: [Next](@next)
