//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//MARK: - 条件编译
// 操作系统：macOS\iOS\tvOS\watchOS\Linux\Android\Windows\FreeBSD
#if os(macOS) || os(iOS)
// CPU架构：i386\x86_64\arm\arm64
#elseif arch(x86_64) || arch(arm64)
// swift版本
#elseif swift(<5) && swift(>=3)
// 模拟器
#elseif targetEnvironment(simulator)
// 是否可以导入某模块
#elseif canImport(Foundation)
#else
#endif

//自定义编译标记：
/*
 • Xcode默认有一个DEBUG标记，我们也可以自己添加一个新的标记。
 - Active Compilation Conditions
 - Other Swift Flags
 两者没有多大区别,只是在Other Swift Flags区域增加标记时需要在最前面加上-D
 */
#if DEBUG
// debug模式
#else
// release模式
#endif

//自定义log
/*
 - 在log函数内部直接使用print(#file, #line, #function, msg)，每次打印都是同样的文件、同一行，同一个log函数。因为#file, #line, #function捕捉的是当前函数的环境
 - 为什么使用OC的NSString，因为NSString的lastPathComponent属性用起来更加便捷
 */
func log(_ msg: String, file: NSString = #file, line: Int = #line, fn: String = #function) {
//    #if DEBUG
    let prefix = "from:\(file.lastPathComponent)_line:\(line)_fn:\(fn):"
    print(prefix, msg)
//    #endif
}

func test() {
    log("测试信息")
}
test() // 输出：from:26-工程简介.xcplaygroundpage_line:47_fn:test(): 测试信息

//MARK: - 版本检测
if #available(iOS 10, macOS 10.12, *) {
    // 对于iOS平台，只在iOS10及以上版本执行
    // 对于macOS平台，只在macOS 10.12及以上版本执行
    // 最后的*表示在其他所有平台都执行
}


//MARK: - API使用说明
//官方地址：https://docs.swift.org/swift-book/documentation/the-swift-programming-language/attributes/
//Person只在iOS10及以上、macOS 10.12及以上才可以使用
@available(iOS 10, macOS 10.12, *)
class Person { }

struct Student {
    //study_已经被修改为study
    @available(*, unavailable, renamed: "study")
    func study_() { }
    func study() { }
    
    //run函数已经在iOS11被废弃
    @available(iOS, deprecated: 11)
    //run函数已经在macOS 10.11被废弃
    @available(macOS, deprecated: 10.11)
    func run() { }
}

//MARK: - 程序入口
//在AppDelegate上面默认有个 @main标记，这表示编译器自动生成入口代码（main函数代码），自动设置AppDelegate为App的代理。
//也可以删掉 @main，自定义入口代码：新建一个main.swift文件，然后手动实现main函数（和OC的main.m基本一致）
// main.swift
import UIKit

// 自定义Application
class DBApplication: UIApplication {}

// 程序入口
//UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, NSStringFromClass(DBApplication.self), NSStringFromClass(AppDelegate.self))
//注意：自定义入口代码的文件一定要是main.swift

//MARK: - OC 和 Swift混编
/*
 - Swift 调用 OC 的桥接文件 项目名-Bridging-Header.h
 - OC 调用 Swift 的桥接文件 项目名-Swift.h
 */
//MARK: Swift调用OC
//1.创建桥接头文件
//1.1手动创建
//1.1.1 新建1个桥接头文件，文件名格式默认为：{targetName}-Bridging-Header.h（文件名称是固定格式）
//1.1.2 在Build Setting中的 Objective-C Bridging Header 选项中设置新建头文件位置（路径）

//1.2自动创建
//1.2.1 源项目是Swift，新建OC文件时，Xcode会提示是否创建桥接文件，选择创建即可

//1.3 {targetName}-Bridging-Header.h 桥接文件的作用
//OC需要暴露给Swift的一些内容放到头文件中，Swift中即可使用OC中的内容

//代码示例：
//1.在桥接头文件中导入Swift需要用到的相关OC头文件
//#import "DBPerson.h"

//DBPerson.h
//int sum(int a, int b);
//@interface DBPerson : NSObject
//
//@property (nonatomic, assign) NSInteger age;
//@property (nonatomic, copy) NSString *name;
//
//- (instancetype)initWithAge:(NSInteger)age name:(NSString *)name;
//+ (instancetype)personWithAge:(NSInteger)age name:(NSString *)name;
//
//- (void)run;
//+ (void)run;
//
//- (void)eat:(NSString *)food other:(NSString *)other;
//+ (void)eat:(NSString *)food other:(NSString *)other;
//
//@end

//DBPerson.m
//#import "DBPerson.h"
//
//int sum(int a, int b) {
//    return a + b;
//}
//
//@implementation DBPerson
//
//- (instancetype)initWithAge:(NSInteger)age name:(NSString *)name {
//    NSLog(@"-init");
//    if (self = [super init]) {
//        self.age = age;
//        self.name = name;
//    }
//    return self;
//}
//
//+ (instancetype)personWithAge:(NSInteger)age name:(NSString *)name {
//    NSLog(@"+init");
//    return [[self alloc] initWithAge:age name:name];
//}
//
//- (void)run {
//    NSLog(@"%zd %@ -run", _age, _name);
//}
//
//+ (void)run {
//    NSLog(@"Person +run");
//}
//
//- (void)eat:(NSString *)food other:(NSString *)other {
//    NSLog(@"%zd %@ -eat %@ %@", _age, _name, food, other);
//}
//
//+ (void)eat:(NSString *)food other:(NSString *)other {
//    NSLog(@"Person +eat %@ %@", food, other);
//}
//
//@end

//2.在Swift文件中使用导入的OC类
//var p = DBPerson(age: 10, name: "Jack") // 输出：-init
//p.age = 18
//p.name = "Rose"
//p.run() // 输出：18 Rose -run
//p.eat("Apple", other: "Water") // 输出：18 Rose -eat Apple Water
//
//DBPerson.run() // 输出：Person +run
//DBPerson.eat("Pizza", other: "Banana") // 输出：Person +eat Pizza Banana
//
//print(sum(10, 20)) // 输出：30


//注意：
//@_silgen_name: Swift Intermediate Language Generator(Swift中间语言生成器)
//如果C语言暴露给Swift的函数名和Swift中的其他函数名冲突了，可以在Swift中使用 @_silgen_name 修改C函数名
// C 文件中函数
//int sum(int a, int b) {
//    return a + b;
//}

// Swift 中使用时，与Swift中其他函数名冲突，使用 @_silgen_name 绑定一个新函数名，注意参数类型需要与原函数一致。
//@_silgen_name("sum")
//func swift_sum(_ v1: Int32, _ v2: Int32) -> Int32
//print(swift_sum(10, 20)) // 输出：30
//print(sum(10, 20)) // 输出：30

//MARK: OC调用Swift
//1.Xcode已经默认生成一个用于OC调用Swift的桥接文件，桥接文件格式：{targetName}-Swift.h（文件名称是固定格式）
//1.1 在Build Setting中的 Objective-C Generated Interface Header Name 选项中设置文件位置（路径）

//2.Swift暴露给OC的类最终继承自NSObject
//- 使用 @objc 修饰需要暴露给OC的成员
//- 使用 @objcMembers 修饰类
//  - 代表默认所有成员都会暴露给OC（包括扩展中定义的成员）
//  - 最终是否成功暴露，还需要考虑成员自身的访问级别

/*
 注意：
 - Xcode会根据Swift代码自动生成对应的OC声明，写入{targetName-Swift.h}文件
 - 如果Swift代码写完之后发现在OC中无法提示或找不到，需要编译一下项目。不要修改{targetName-Swift.h}文件，
   因为这个文件内容是编译后自动生成的
 */

//3.重命名
//可以通过 @objc 重命名Swift暴露给OC的符号名（类名、属性名、函数名等）
//Swift代码：
@objc(DBCar)
@objcMembers class Car: NSObject {
    var price: Double
    @objc(name)
    var band: String
    init(price: Double, band: String) {
        self.price = price
        self.band = band
    }
    @objc(drive)
    func run() {
        print(price, band, "run")
    }
    static func run() {
        print("Car run")
    }
}

extension Car {
    @objc(exec:v2:)
    func test(a: Int, b: Int) {
        print(price, band, "test")
    }
}

//OC使用：
//DBCar *car = [[DBCar alloc] initWithPrice:2.0 band:@"BMW"];
//car.name = @"Benz";
//car.price = 98.0;
//
//[car drive]; // 输出：98.0 Benz run
//[car exec:10 v2:20]; // 输出：98.0 Benz test
//[DBCar run]; // 输出：Car run

//4.选择器
//Swift中依然可以使用选择器，使用#selector(name)定义一个选择器。必须是被 @objcMembers 或 @objc 修饰的方法才可以定义选择器
//示例代码：
@objcMembers class Animal: NSObject {
    func test1(v1: Int) {
        print("test1")
    }
    func test2(v1: Int, v2: Int) {
        print("test2(v1:v2:)")
    }
    func test2(_ v1: Double, _ v2: Double) {
        print("test2(_:_:)")
    }
    func run() {
        perform(#selector(test1))
        perform(#selector(test1(v1:)))
        perform(#selector(test2(v1:v2:)))
        perform(#selector(test2(_:_:)))
        perform(#selector(test2 as (Double, Double) -> Void))
    }
}

//如果没有函数重载，选择器的函数名称后面不需要写参数列表
//Swift是没有runtime概念的，所以只能是暴露给OC的成员才可以使用选择器

//MARK: - 问题
/*
 1.为什么Swift暴露给OC的类最终要继承自NSObject？
    - 因为这个类最终是要给OC使用的，OC的所有类最终都继承自NSObject
 
 2.a.run()底层是怎么调用的（走OC的runtime还是Swift的虚表）？反过来，OC调用Swift底层又是如何调用的？
    - OC调用Swift，Swift代码由于生成了OC代码，所以还是走runtime流程的，也就意味着必然有isa指针，而isa来自NSObject
    - Swift调用OC，最终还是走runtime。就算被 @objcMembers 修饰，Swift代码之间的调用还是虚表
    - 如果Swift中的类成员（函数）必须使用OC的runtime实现时，可以使用 dynamic 关键字，实现动态性
 */

//MARK: - 协议
//可供OC使用的协议
@objc protocol Xxable {
    
}

//可选协议， @objc optional 定义的协议为可选协议，此协议只能被class继承
//示例代码：
@objc protocol Runnable {
    @objc optional func run1()
    func run2()
    func run3()
}

class Dog: Runnable {
    func run2() {
        print("Dog run2")
    }
    func run3() {
        print("Dog run3")
    }
}
var d = Dog()
d.run2() // 输出：Dog run2
d.run3() // 输出：Dog run3

//MARK: - dynamic
//被 @objc、dynamic修饰的内容会具有动态性，比如调用方法会走runtime那一套流程
//Swift5中不推荐单独使用dynamic，不会隐式添加 @objc，推荐显示添加形式： @objc dynamic
class Cat: NSObject {
    @objc dynamic func test1() { }
    func test2() { }
}
var c = Cat()
c.test1() //消息转发
c.test2() //虚表

//MARK: - KVC、KVO
/*
 Swift支持KVC、KVO的条件：
 - 属性所在的类、监听器最终继承自NSObject(因为OC的KVC/KVO走的是runtime，而使用runtime必然会用isa，isa又是NSObject的)
 - @objc dynamic 修饰的属性
 
 分析"@objc"和"@objc dynamic"的区别：
 一、KVO监听：
    1、"@objc dynamic" KVO正常。
    2、"dynamic" KVO崩溃。
    3、"@objc" KVO异常，x.y = z形式的赋值，是无法监听y的改变的（并非objc_msgSend），只有x.setValue(z, forKey: "y")可以监听到，因为setValue方法本身就是NSObject的方法.
 二、未监听
    1、"dynamic"修饰变量，调用方式还是虚表。
    2、"@objc"或者"@objc dynamic"调用方式为objc_msgSend。
 */

//示例代码一:
class Observer: NSObject {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        print("observeValue", change?[.newKey] as Any)
    }
}

class O: NSObject {
    @objc dynamic var age: Int = 0
    var observer: Observer = Observer()
    override init() {
        super.init()
        self.addObserver(observer, forKeyPath: "age", options: .new, context: nil)
    }
    deinit {
        self.removeObserver(observer, forKeyPath: "age")
    }
}
var o = O()
o.age = 20 // 输出：observeValue Optional(20)
o.setValue(30, forKey: "age") // 输出：observeValue Optional(30)

//示例代码二:
class Ob: NSObject {
    @objc dynamic var age: Int = 0
    var observation: NSKeyValueObservation?
    override init() {
        super.init()
        observation = observe(\Ob.age, options: .new) {
            (ob, change) in
            print("Block", change.newValue as Any)
        }
    }
}
var ob = Ob()
ob.age = 20 // 输出：Block Optional(20)
ob.setValue(30, forKey: "age") // 输出：Block Optional(30)

//键路径表达式作为函数:
struct S2 {
    let p1: String
    let p2: Int
}

let s2 = S2(p1: "one", p2: 1)
let s3 = S2(p1: "two", p2: 2)
let a1 = [s2, s3]
//键路径（\.p1）
let a2 = a1.map(\.p1)
print(a2) // ["one", "two"]

//MARK: - 关联对象
//默认情况下，extension不可以增加存储属性。借助关联对象，可以实现类似extension为class增加存储属性的效果
//示例代码:
class Fish { }
extension Fish {
    private static var AGE_KEY: Void?
    var age: Int {
        get {
            (objc_getAssociatedObject(self, &Self.AGE_KEY) as? Int ) ?? 0
        }
        set {
            objc_setAssociatedObject(self, &Self.AGE_KEY, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
//关联对象的本质就是键值对，但是需要我们自己绑定一个编译期已知地址值（静态存储属性）。由于仅需要地址绑定，所以为了内存空间考虑，静态存储属性使用Bool类型或者Void?类型最好（仅占用1个字节）

//MARK: - 资源名管理
//示例代码一：
//let img = UIImage(named: "logo")
//let btn = UIButton(type: .custom)
//btn.setTitle("按钮", for: .normal)
//
//performSegue(withIdentifier: "login_main", sender: self)

//示例代码二：仿Android
//enum R {
//    enum string: String {
//        case add = "按钮"
//    }
//    enum image: String {
//        case logo
//    }
//    enum segue: String {
//        case login_main
//    }
//}
//let img = UIImage(named: R.image.logo)
//let btn = UIButton(type: .custom)
//btn.setTitle(R.string.add, for: .normal)
//
//performSegue(withIdentifier: R.segue.login_main, sender: self)

//示例代码三：
// 原始
let img = UIImage(named: "logo")
let font = UIFont(name: "Arial", size: 17)

// 封装资源管理
enum R {
    enum image {
        static var logo = UIImage(named: "logo")
    }
    enum font {
        static func arial(_ size: CGFloat) -> UIFont? {
            UIFont(name: "Arial", size: size)
        }
    }
}

// 使用资源管理
let img1 = R.image.logo
let font1 = R.font.arial(15)
/*
 上面对image的封装有两点考量：
 - 可以直接通过名称返回一个Image对象。
 - 静态属性在内存中只有一份，后面任何地方再次用到时可直接从内存中加载数据（除非需要每次都加载新数据）
 */

//其他优秀思路：
//https://github.com/mac-cain13/R.swift
//https://github.com/SwiftGen/SwiftGen


//MARK: - 编译器约定方法
/*
 Swift中特殊的编译器约定方法：callAsFunction
 自定义类型中实现了 callAsFunction() 的话，该类型的值就可以直接调用。
 */
// callAsFunction()
struct Example {
    var p1: String
    
    func callAsFunction() -> String {
        return "show \(p1)"
    }
}
let e = Example(p1: "hi")
print(e()) // show hi

//MARK: - 使用Swift中保留关键字作为变量的方法
/*
 !!!: Swift不允许使用保留关键字作为标识符（变量名、常量名、方法名等）直接使用，需要使用保留关键字作为标识符，必须使用反引号将其包围。
 */
enum Foo {
    case `default`
    case other
}

//使用方法：
let foo = Foo.`default`
let bar = Foo.default

//: [Next](@next)
