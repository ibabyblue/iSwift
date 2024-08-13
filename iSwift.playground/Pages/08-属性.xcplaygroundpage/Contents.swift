//: [Previous](@previous)

import Foundation

var greeting = "Hello, property"

//MARK: - 属性
/*
 实例属性：
    - 存储属性
        - 属性观察器
        - 延迟存储属性
    - 计算属性
 类型属性：
    - 存储类型属性
    - 计算类型属性
 */

//MARK: - 实例属性
//MARK: 存储属性
/*
 
 存储属性：
 - 类似于成员变量的概念
 - 存储在实例的内存中
 - 结构体、类可定义存储属性，!!!: 枚举不可以定义存储属性
 
 • Swift中明确规定创建类或者结构体时，必须为所有的存储属性设置一个合适的初始值。
 - 可以在初始化器中设置一个初始值
 - 可以分配一个默认的属性值作为属性定义的一部分
 
 • 属性观察器：非lazy的var存储属性才能设置属性观察器
 - willSet会传递新值，默认叫newValue
 - didSet会传递旧值，默认叫oldValue
 - 在初始化器中设置属性值不会触发willSet和didSet
 - 在属性定义时设置初始值也不会触发willSet和didSet
 - 可用于全局属性、局部属性
 */
//MARK: 计算属性
/*
 计算属性：
 - 本质为方法（函数）
 - 不占用实例内存
 - 枚举、结构体、类均可定义计算属性
 
 - set传入的新值默认叫做newValue，也可以自定义：
 /*
  set(value) {
    print(value)
  }
  */
 - 只读计算属性：只有get，没有set
 - 定义计算属性只能用var，不能用let，计算属性的值是可变的
 - let代表常量，值是一成不变的
 
 • 枚举原始值rawValue的本质是：只读计算属性
 • 可用于全局属性、局部属性
 */

struct Circle {
    //存储属性
    var area: Double
    
    //存储属性
    var border : Float = {
       1
    }()
//    //等价于
//    var border : Float = 1
//    属性这样写 是为了直接调用闭包，将1赋值给border
    
    //存储属性 - 属性观察器
    var radius: Double {
        willSet {
            print("willSet", newValue)
        }
        didSet {
            print("didSet", oldValue, radius)
        }
    }
    
    //计算属性
    var diameter: Double {
        get {
            radius * 2
        }
        
        set {
            radius = newValue / 2
        }
    }
    
    //只读计算属性
    var perimeter: Double {
        get {
            //周长：半径 * 2 * π
            radius * 2 * Double.pi
        }
    }
}

var circle: Circle = Circle(area: 20, radius:6)
circle.diameter
circle.radius = 2

//MARK: 延迟存储属性
/*
 延迟存储属性:
 - 使用lazy可以定义一个延迟存储属性，在第一次用到属性的时候才会进行初始化
 - lazy属性必须是var，不能是let
    - let必须在实例的初始化方法完成之前就拥有值，lazy又是懒加载特性，所以冲突
 
 - 如果多条线程同时第一次访问lazy属性
 - 无法保证属性只被初始化1次
 */

class Car {
    init() {
        print("Car init")
    }
    
    func run() {
        print("Car is running")
    }
}

class Person {
    lazy var car = Car()
    
    init() {
        print("Person init")
    }
    
    func goOut() {
        car.run()
    }
}

let p = Person();
print("-------")
p.goOut()

/* 打印结果:
Person init!
--------
Car init!
Car is running!
*/

/*
 当结构体包含一个延迟存储属性时，只有var才能访问延迟存储属性
 因为延迟属性初始化时需要改变结构体的内存
 */
struct Point {
    var x: Int = 0
    var y: Int = 0
    lazy var z: Int = 0
}

let point = Point()
point.x
point.y
//point.z 报错 将let改为var才可以

//MARK: inout关键字
struct Shape {
    //存储属性
    var width: Int
    //存储属性 - 属性观察器
    var side: Int {
        willSet {
            print("willSetSide", newValue)
        }
        didSet {
            print("didSetSide", oldValue, side)
        }
    }
    //计算属性
    var girth: Int {
        set {
            width = newValue / side
            print("setGirth", newValue)
        }
        get {
            print("getGirth")
            return width * side
        }
    }
    
    func show() {
        print("width=\(width), side=\(side), girth=\(girth)")
    }
}

func foo(_ num: inout Int) {
    num = 20
}
var s = Shape(width: 10, side: 4)
foo(&s.width)
s.show()
print("----------")
foo(&s.side)
s.show()
print("----------")
foo(&s.girth)
s.show()
/*
 • 如果实参有物理内存地址，且没有设置属性观察器
 - 直接将实参的内存地址传入函数（实参进行引用传递）
 
 • 如果实参是计算属性 或者 设置了属性观察器
 - 采取了Copy In Copy Out的做法
    - 调用该函数时，先复制实参的值，产生副本【get】
    - 将副本的内存地址传入函数（副本进行引用传递），在函数内部可以修改副本的值
    - 函数返回后，再将副本的值覆盖实参的值【set】
 
 • 总结：inout的本质就是引用传递（地址传递）
*/

//MARK: - 类型属性
/*
 • 严格来说，属性分为实例属性（Instance Property）、类型属性（Type Property）
 • 实例属性：只能通过实例访问
    - 存储实例属性：存储在实例内存中，每个实例都有一份
    - 计算实例属性
 
 • 类型属性：只能通过类型访问
    - 存储类型属性：整个程序运行过程中，就只有一份内存（类似于全局变量）
    - 计算类型属性
 
 • 通过static关键字定义类型属性
 
 • 不同于存储实例属性，你必须给存储类型属性设定初始值
    - 因为类型没有像实例那样的init初始化器来初始化存储属性
 • 存储类型属性默认就是lazy，会在第一次使用的时候才初始化
    - 就算被多个线程同时访问，保证只会初始化一次
    - 存储类型属性可以是let
 
 • 枚举类型也可以定义类型属性（存储类型属性、计算类型属性）
 
 • static和class关键字修饰的方法类似OC的类方法:
    - static 可以修饰存储属性，而 class 不能。
    - class 修饰的方法可以继承，而 static 不能。
    - 协议中需用 static 来修饰。
 */

class Cat {
    static let name: String = "miaomiao"
    
    static func run() {
        print("run")
    }
    
    class func eat() {
        print("eat")
    }
}

class WhiteCat : Cat {
    override class func eat() {
        print("WhiteCat eat")
    }
}

Cat.name
Cat.run()
Cat.eat()

WhiteCat.eat()

//MARK: - 单例模式
//第一种
//final public class FileManager {
//    public static let shared = FileManager()
//    private init() {}
//}

//第二种
final public class FileManager {
    public static let shared = {
        //...
        //...
        return FileManager()
    }()
    private init() {}
}

//MARK: - UserDefaults
enum UDKey {
    static let k1 = "token"
}
let ud = UserDefaults.standard
ud.set("xxxxxx", forKey: UDKey.k1)
let tk = ud.string(forKey: UDKey.k1)
print(tk ?? "")

//: [Next](@next)
