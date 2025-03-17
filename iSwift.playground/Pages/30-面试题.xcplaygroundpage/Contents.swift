//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//MARK: 1、Swift中的写时复制？
/*
 写时复制是一种优化内存技术，只用于值类型。将值类型赋值给另一个变量或者常量时，原始值会创建一个副本，副本和原始值是完全独立的，但不改变时这种复制开销是没有必要，写时复制就是为了优化这种场景，当一个不可变类型实例被赋值时，实际上只会增加一个指向原数据的引用计数。只有在进行修改时，才会对值进行复制。
 isKnownUniquelyReferenced:使用此函数判断是否开启写时复制。
 */

//MARK: 2、Swift中的Struct和Class的区别？
/*
 1、Struct是值类型、Class是引用类型
 */

//MARK: 3、Swift中函数派发机制？
/*
 1、直接派发：函数地址直接调用
 2、函数表派发：虚函数表
 3、消息机制派发：就是消息发送流程
 */

//MARK: 4、swift为什么推荐结构体而不是class？
/*
 1、性能优化栈上内存分配和释放速度快，无需管理引用计数。
 2、写时复制优化
 3、没有继承和多态的开销
 */

//MARK: 5、高阶函数是什么
/*
 高阶函数是至少满足下列一个条件的函数：
 - 接受一个或多个函数作为输入
 - 输出一个函数
 */

//MARK: 6、柯里化
/*
 将一个多参数的函数转换为单参数函数并且这个函数的返回值也是一个函数
 */

//MARK: 7、是什么函数式编程
/*
 函数式编程指的是数学意义上的函数，即映射关系（如：y = f(x),就是 y 和 x 的对应关系,可以理解为"像函数一样的编程").它的主要思想是把运算过程尽量写成一系列嵌套的函数调用。
 例：
 数学表达式
 (1 + 2) * 3 - 4
 传统编程
 var a = 1 + 2
 var b = a * 3
 var c = b - 4
 函数式编程
 var result = subtract(multiply(add(1,2), 3), 4)

 函数是"第一等公民"
 函数和其他数据类型一样，可以作为参数，可以赋值给其他变量，可以作为返回值。
 例：
 var print = function(i){
   console.log(i)
 }
 [1,2,3].forEach(print)
 */

//MARK: 8、说说Swift为什么将String,Array,Dictionary设计成值类型
/*
 - 值类型和引用类型的内存使用的高效性不同，值类型一般在栈上比引用类型在堆上要高效。
 - 线程安全性，值类型的线程安全性高，不会出现崩溃，但会出现数据异常。
 */

//MARK: 9、协议与泛型、协议弊端？
/*
 1、swift支持非泛型协议存储，但是有一定局限性，如下所示，mm不能调用x属性。
 protocol Drawable{
     func draw()
 }
 struct Point:Drawable{
     var x:Double
     func draw() {
         print("Point")
     }
 }
 struct Line:Drawable{
     var x:Int
     func draw() {
         print("Line")
     }
 }
 // mm 的实际类型是编译器生成的一种特殊数据类型 Existential Container(存在容器)
 let mm:Drawable = arc4random()%2 == 0 ? Point(x: 20.0) : Line(x:10)
 mm.draw()

 //Drawable 里面没有x  所以这里不能使用mm.x，也就解释了 mm.x 在编译时类型不确定的，违背了swift语法的问题
 print(mm.x)  //这里编译器会报错
 
 2、swift不支持泛型协议存储，如下是报错的
 //泛型协议的本质,约束类型
 protocol Genertor{
    associatedtype AbstractType
    func.generate()->AbstractType
 }
 struct InGenertor:Genertor{
    typealias AbstractType = Int
    func generate() -> Int {
        return 0
    }
 }
 struct StringGenertor:Genertor{
    typealias AbstractType = String
    func generate() -> String {
        return "str"
    }
 }
 //下面代码报错，因为gen既可以是InGenertor也可以是StringGenertor，这在swift强类型语言中是不允许的
 let gen:Genertor=arc4random()%2 ==0 ? InGenertor(): StringGenertor()
 
 3、类型擦除->借助中间层
 具体的解决方法是：
 - 定义一个中间层结构体，该结构体实现了协议的所有方法
 - 在中间层结构体实现的具体协议方法中，再转发给实现协议的抽象类型
 - 在中间层结构体的初始化过程中，实现协议的抽象类型，会被当做参数传入（依赖注入）
 protocol Printer{
    associatedtype AbstractType
    func test(_ parms: AbstractType)
 }
 struct AnyPrinter<T>: Printer {
    //函数指针
    private let _test:(T) -> ();
    init<Base : Printer>(_base:Base) where Base.AbstkractType == T{
        _test = base.test
    func test(_parms:T){
        _test(parms)
    }
 }
 struct TypeCPrinter<T>:Printer{
    typealias AbstractType = T
    func test(_parms: T) {
        print(parms)
    }
 }
 let p: AnyPrinter<String> = AnyPrinter(TypeCFPrinter())
 p.test("123")
 */

//MARK: 10、依赖注入
/*
 注释：依赖注入就是将实例变量传入到一个对象中去
 class Vehicle {
     var engine: Propulsion

     init(engine: Propulsion) {
         self.engine = engine
     }

     func forward() {
         engine.move()
     }
 }
 
 let raceCarEngine = RaceCarEngine()
 var car = Vehicle(engine: raceCarEngine)
 car.forward()
 
 依赖注入的方法：
 - 构造函数注入：通过初始化init()提供依赖       
 - 属性注入：通过属性（或 setter）提供依赖
 - 方法注入，将依赖项作为方法参数传递
 */
//: [Next](@next)
