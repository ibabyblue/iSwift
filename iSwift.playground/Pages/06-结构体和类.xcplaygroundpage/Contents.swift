//: [Previous](@previous)

import Foundation

var greeting = "Hello, struct and class"

//!!!: 结构体编译器会提供一个或多个默认的初始化器（构造器、构造方法、初始化方法、initializer），用于初始化所有成员(存储属性)。

//MARK: - 结构体（Struct）
//MARK: 结构体默认初始化
//struct Point {
//    var x: Int = 0
//    var y: Int
//}
//
//Point(y: 1)
//Point(x: 1, y: 2)

//struct Point {
//    var x: Int?
//    var y: Int?
//}
//
//Point()
//Point(x: 1)
//Point(y: 2)
//Point(x: 1, y: 2)

//MARK: 结构体自定义初始化
/*
 !!!: 如果存在自定义初始化，编译器就不会提供默认初始化器了
 */
struct Point {
    var x: Int
    var y: Int
    var z: Int {
        get {
            x + y
        }
        set {
            newValue + x + y
        }
    }
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

Point(x: 1, y: 2)

//MARK: - 类（Class）
//!!!: 类的定义与结构体类似，但编译器并没有为类自动生成可以传入成员值的初始化器
class CPoint {
    var x: Int = 0
    var y: Int = 0
}
//等价于
//class CPoint {
//    var x: Int
//    var y: Int
//    
//    init(x: Int, y: Int) {
//        self.x = x
//        self.y = y
//    }
//}

//MARK: - 结构体和类的本质区别
/*
 !!!: struct和enum是值类型，class是引用类型（指针类型）
 */
//MARK: 值类型
/*
 值类型赋值给var、let或者给函数传参，是直接将所有内容拷贝一份
 类似于对文件进行copy、paste操作，产生了全新的文件副本。属于深拷贝（deep copy）
*/
//p1的值最终是多少？
var p1 = Point(x: 1, y: 2)
var p2 = p1

p2.x = 3
p2.y = 4

//p1的值为：1,2 因为值类型是拷贝，p1和p2互不影响

//MARK: 引用类型
/*
 引用赋值给var、let或者给函数传参，是将内存地址拷贝一份
 类似于制作一个文件的替身（快捷方式、链接），指向的是同一个文件。属于浅拷贝（shallow copy）
 */

//s1的值最终是多少？
class Size {
    var width: Int
    var height: Int
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}

var s1 = Size(width: 1, height: 1)
var s2 = s1;

s2.width = 2
s2.height = 2

//s1的值为：2,2 因为引用类型是地址拷贝，s1、s2指向的是同一个地址，s1、s2互相影响

/*
 在Swift中，创建类的实例对象，要向堆空间申请内存，大概流程如下
 - Class.__allocating_init()
 - libswiftCore.dylib：_swift_allocObject_
 - libswiftCore.dylib：swift_slowAlloc
 - libsystem_malloc.dylib：malloc
 - 在Mac、iOS中的malloc函数分配的内存大小总是16的倍数
 - 通过class_getInstanceSize可以得知：类的对象至少需要占用多少内存
 */
class_getInstanceSize(Size.self)
class_getInstanceSize(type(of: s1))

//MARK: 值类型与引用类型的赋值操作
var p3 = Point(x: 3, y: 3)
p3 = Point(x: 4, y: 4)
//P3变量只有一份内存占用（栈），4,4 覆盖 3,3

var s3 = Size(width: 3, height:3)
s3 = Size(width: 4, height: 4)
//s3变量只有一份内存占用（栈），堆空间则有两个Size的实例对象，s3中存储的实例对象地址由Size(width: 3, height:3) 变为 Size(width: 4, height: 4)，Size(width: 3, height:3)则由ARC机制回收。

//MARK: 值类型与引用类型的let
let p4 = Point(x: 4, y: 4)
//p4 = Point(x: 5, y: 5) //报错
//p4.x = 1 //报错
//p4.y = 1 //报错

let s4 = Size(width: 4, height:4)
//s4 = Size(width: 5, height: 5) //报错
s4.height = 1 //ok
s4.width = 1 //ok

//MARK: 嵌套类型
struct Poker {
    enum Suit : Character {
        case spades = "♠", hearts = "♥", diamonds = "♦", clubs = "♣"
    }
    
    enum Rank : Int {
        case two = 2, three, four, five, six, seven, eight, nine, ten
        case jack, queen, king, ace
    }
}

var suit = Poker.Suit.spades
suit = .diamonds

var rank = Poker.Rank.six
rank = .eight

//MARK: 枚举、结构体和类都可以定义方法
/*
 方法：定义在枚举、结构体、类中的函数，叫做方法
 - 方法不占用内存
 - 方法本质就是函数
 - 方法、函数都存放在代码段
 */

enum fPoker : Character {
    case spades = "♠", hearts = "♥", diamonds = "♦", clubs = "♣"
    
    func show() {
        print("face is \(rawValue)")
    }
}

struct fPoint {
    var x = 0
    var y = 0

    init(x: Int = 0, y: Int = 0) {
        self.x = x
        self.y = y
    }
    
    func show() {
        print("x:\(x), y:\(y)")
    }
}

class fSize {
    var width = 0
    var height = 0

    init(width: Int = 0, height: Int = 0) {
        self.width = width
        self.height = height
    }
    
    func show() {
        print("width:\(width), height:\(height)")
    }
}

let fpk = fPoker.diamonds
fpk.show()

let fp = fPoint(x: 1, y: 1)
fp.show()

let fs = fSize(width: 2, height: 2)
fs.show()


//: [Next](@next)
