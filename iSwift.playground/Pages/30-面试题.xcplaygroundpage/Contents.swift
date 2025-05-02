//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//MARK: 1、Swift中的写时复制？
/*
 写时复制是一种优化内存技术，只用于值类型。将值类型赋值给另一个变量或者常量时，原始值会创建一个副本，副本和原始值是完全独立的，但不改变时这种复制开销是没有必要，写时复制就是为了优化这种场景，当一个不可变类型实例被赋值时，实际上只会增加一个指向原数据的引用计数。只有在进行修改时，才会对值进行复制。
 isKnownUniquelyReferenced:使用此函数判断是否开启写时复制。
 
 !!!: 手动实现写时复制：
 final class Ref<T> {
   var val: T
   init(_ v: T) { val = v }
 }

 struct Box<T> {
   var ref: Ref<T>
   init(_ x: T) { ref = Ref(x) }

   var value: T {
     get { return ref.val }
     set {
       if !isKnownUniquelyReferenced(&ref) {
         ref = Ref(newValue)
         return
       }
       ref.val = newValue
     }
   }
 }
 */

//MARK: 2、Swift中的Struct和Class的区别？
/*
 1、Struct是值类型、Class是引用类型
 2、Struct - 节省性能，不能被继承
 3、struct ⾥的 class，即使 struct 复制了，它也是引⽤类型 ； 重要：例外，闭包⾥使⽤ Struct 是⼀份引⽤，除⾮明确的 copy ⼀份
 */

//MARK: 3、swift为什么推荐结构体而不是class？
/*
 1、性能优化栈上内存分配和释放速度快，无需管理引用计数。
 2、没有继承和多态的开销
 */

//MARK: 4、Swift中函数派发机制？
/*
 1、直接派发：函数地址直接调用
 2、函数表派发：虚函数表
 3、消息机制派发：就是消息发送流程
                        直接派发                    函数表派发              消息派发
 值类型（struct）        AllMethods                    N/A                  N/A
 协议（protocol）        Extension           initial declaration           N/A
 类（class）      Extension（final/static）   initial declaration       @objc + dynamic
 NSObject（子类） Extension（final/static）    initial declaration       @objc + dynamic
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
 - 协议类型在内存中存储形式为:Existential Container - 5个word（64位时：5 * 8 = 40字节）；
                            |-- 前三个词（24字节）：Value Buffer
                            |
                            |
    Existential Container - |-- VWT（8字节）（Value Witness Table）
                            |
                            |
                            |---PWT（8字节）（Protocol Witness Table）
 
 - 泛型可以将类型参数化，提高代码复用率，减少代码量。
 - T 和 Any 的区别？ Any 类型会避开类型的检查
 //输⼊输出类型⼀致
 func add<T>( input: T) "-> T {
     "//""...
     return input;
 }

 //输⼊输出类型会不⼀致
 func anyAdd(* input: Any) "-> Any {
     "//""...
     return input;
 }
 
 - 协议：大部分情况下，通过查表动态派发
 - 泛型：大部分情况下，优化为直接派发，效率更高
 
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
    func generate()->AbstractType
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

//MARK: 11、为什么选择Swift而不是Objective-C
/*
- 性能效率
- 安全性
- 简洁性
*/

//MARK: 12、Swift ⼤事记
/*
 - 2014 - Swift1.0问世
 - 2016 - Swift3 - Swift Package Manager
 - 2017 - Swift4
 - 2019 - ABI稳定（Swift5），系统标准库不再需要打包进可执行文件，体积不会变大，而是固话到手机操作系统内；
        - SwiftUI、Combine（都开始于 iOS 13+）
 - 2021 - Swift5.5 - Concurrency
 */

//MARK: 13、HashTable 与 Dictionary、Set的不同
/*
 - Dictionary：由于每个提供的值都与一个键相关联，因此还可以在O(1)（常数时间）内执行必要的数据插入、查找和检索。
 - HashTable：也支持键值对，但它的键是通过使用称为哈希算法的附加函数以编程方式生成的，因此它们通常不与数据结构一起存储。这些特性使哈希表的执行时间复杂度为 O(1)常数时间，同时占用最小的空间。

 - 使用协议实现Hash算法
 protocol Keyable {
        
     var keystring: String {get}
    
     //note: in this case hashValue operates as a function
     func hashValue(for key: String!, using buckets: Array<T>) -> Int
 }
     
 extension Keyable {
         
     //compute item hash
     func hashValue<T>(for key: String!, using buckets: Array<T>) -> Int {
                 
         var remainder: Int = 0
         var divisor: Int = 0
         
         //trivial case
         guard key != nil else {
             return -1
         }
         
         for item in key.unicodeScalars {
         divisor += Int(item.value)
         }
         
         remainder = divisor % buckets.count
         return remainder
      }
 }
 */

//MARK: 14、some（Opaque type：不透明类型） 和 any
/*
- any：更像是一个“盒子”，如果需要知道具体是什么类型，需要先把盒子打开。因此编译期间并不知道具体是什么，需要运行时才知道。
- some：是一个存在的类型，没有外层的“盒子”，编译期间就已经确定了类型。

protocol MyProtocol {}
class MyC: MyProtocol {}
class MyC1: MyProtocol {}

var arr: [any MyProtocol] = [
    MyC(),
    MyC1(),
]

var arr1: [some MyProtocol] = [
    MyC(),
    MyC1(),
]

arr：元素的类型为 any MyProtocol，编译器不会检查里边装的到底是什么类型，对编译器来说，只要是“盒子”就行了，因此能够顺利编译通过。
arr1：元素的类型为 some MyProtocol，里面既有 MyC 类型，又有 MyC1，对于编译器来说是有冲突的，因此编译会报错。
*/

//MARK: 15、Opaque Type并不能完全替换 Generic
/*
- 泛型容器，比如一个可以储存任何类型的数组。
*/

//MARK: 16、Swift中的Map、FlatMap 和 CompactMap 的区别是什么？
/*
 - FlatMap和CompactMap用于转换和过滤可选项和集合（均返回新数组，不修改原数组）
    - FlatMap：平铺展开，例如：将二维数组展开为一维数组
        - 例子：
        let nestedArray = [[1, 2, 3], [4, 5, 6]]
        let flattenedArray = nestedArray.flatMap { $0 }
        print(flattenedArray) // Output: [1, 2, 3, 4, 5, 6]
    - CompactMap：用于转换序列元素，同时解包可选值并移除 nil 结果。
        - 例子：
        let numbers = ["1", "2", "three", "4"]
        let mappedNumbers = numbers.compactMap { Int($0) }
        print(mappedNumbers) // Output: [1, 2, 4]

 !!!: Combine 在iOS17之后将逐步废弃，新引入Observation框架，意味着响应式将消失
- Combine：响应式框架 （发布者、订阅者、操作符）
import Combine

// Create a publisher
let numbersPublisher = [1, 2, 3, 4, 5].publisher

// map
numbersPublisher
    .map { $0 * 10 }
    .sink { print($0) }  // Output: 10, 20, 30, 40, 50

// flatMap
let nestedPublisher = [[1, 2, 3], [4, 5, 6], [7, 8, 9]].publisher
nestedPublisher
    .flatMap { $0.publisher }
    .sink { print($0) }  // Output: 1, 2, 3, 4, 5, 6, 7, 8, 9

// compactMap
let publisherWithNil = [1, nil, 3, nil, 5].publisher
publisherWithNil
    .compactMap { $0 }
    .sink { print($0) }  // Output: 1, 3, 5

map、filter、reduce 的时间复杂度：O(n)
*/

//MARK: 17、闭包以及闭包捕获
/*
 - 闭包是⼀个捕获了全局上下⽂的常量或者变量的函数
 - "懒捕获"：Lazy Capture（不使用捕获列表：[x, y]）,闭包内外的变量是同一个，修改其中一个，另外一个也改变
 - "早捕获"：Eager Capture（使用了捕获列表：[x, y]）,闭包内外变量不是同一个，修改其中一个，另外一个不改变
 
 !!!: 这点和ObjC中的Block不同，Block默认就是"早捕获"
 !!!: 这里的"懒捕获"、"早捕获"非官方定义
 */

//MARK: 18、可选项绑定
/*
 原来写法：
 class AnimationController {
     var animation: Animation?

     func update() {
         if let animation = animation {
             // Perform updates
             ...
         }
     }
 }

 Swift5.7新的可选解包语法：
 class AnimationController {
     var animation: Animation?

     func update() {
         if let animation {
             // Perform updates
             ...
         }
     }
 }
 */

//MARK: 19、lazy底层实现原理
/*
 在Lazy.h文件中可以找到
 1、创建了两个模版类：LazyValue 用来存储懒加载值，Lazy 用来创建懒加载全局对象。
 2、延迟初始化: LazyValue 在调用 get 方法时会先调用 Value.has_value() 方法检查是否初始化过，如果没有，则调用 Init() 来初始化对象。
 3、一次性赋值: 一旦 lazy 属性被初始化，其值就会被存储起来，后续的访问将直接返回该值，无需重新计算。
 */

//MARK: 20、PassthroughSubject 与 CurrentValueSubject
/*
 PassthroughSubject和CurrentValueSubject 都是Combine框架中的发布者对象，区别：
 - PassthroughSubject 没有初始值，如果没有订阅者，事件值将被丢弃
 - CurrentValueSubject 有初始值，新的订阅者在订阅时会收到此初始值，相当于保存一个值
 */

//MARK: 21、Swift的安全性
/*
 - 代码安全：
    - let声明为常量，避免使用过程中修改。
    - 强制异常处理
 - 类型安全强制转换：
    - 禁止隐式类型转换避免转换中带来的异常问题。
    - 提供泛型和协议关联类型，可以编写出安全类型的代码
    - KeyPath相⽐使用字符串提供属性名称和类型信息，可以利使用编译器检查。
 - 内存安全
    - 强制初始化，使用前必须初始化内存
    - 通过编译器检查发现潜在的内存冲突问题
    - 使用自动内存管理避免⼿动管理内存带来的各种内存问题
    - 可选类型，有效避免空指针带来的异常问题
 - 线程安全
    - 使用值类型减少在多线程中遇到的数据竞争造成崩溃问题
    - async/await - 提供异步函数使我们可以使用格式化的方式编写重复操作。避免基于闭包的异步方式带来的内存循环引用和⽆法抛出异常的问题
    - Actor - 提供Actor模型多线程开发中进行避免数据共享时产生的数据竞争问题，同时避免在使用锁时带来的死锁等问题
 - 快速
    - 值类型 - 相⽐类不需要额外的堆内存分配/释放和更少的内存消耗
    - 静态派发 - 效率更高
    - 泛型特化/写入时复制等优化提提高运行性能
 */

//MARK: 22、Swift中协议和ObjC中的协议有什么不同
/*
 - Swift中的 protocol 还可以对接口进行抽象,可以实现面向协议,从而大大提高编程效率
 - Swift中的 protocol 可以用于值类型,结构体,枚举;
 */

//MARK: 23、Swift和OC中的自省?
/*
 OC:iskinOfClass:、isMemberOfClass:
 Swift:使用 is 判断是否属于某一类型
 */

//MARK: 24、编写高性能Swift代码
/*
 1、整体模块优化（WMO）
 默认情况下，Swift 会单独编译每个文件。这使得 Xcode 能够非常快速地并行编译多个文件。但是，单独编译每个文件会阻止某些编译器优化。
 Swift也可以将整个程序当作一个文件来编译，并像单个编译单元一样对程序进行优化。此模式可以通过swiftc命令行标志
 启用-whole-module-optimization。在此模式下编译的程序很可能需要更长时间才能完成编译，但运行速度可能会更快。

 可以使用 Xcode 构建设置“整个模块优化”启用此模式。
 
 2、减少动态调度
    - 减少函数表派发、消息派发方式，提升性能
    - 不需要被覆盖的声明，使用final关键字
    - 不需要再外部访问时候，使用private/fileprivate
 
 3、高效使用数组
    - 在数组中使用值类型
    - 当不需要 NSArray 桥接时，使用 ContiguousArray 和引用类型
 4、泛型
    - 将泛型声明放在使用它们的同一模块中（因为只有当泛型声明的定义在当前模块中可见时，优化器才能执行特化）
 */
//: [Next](@next)
