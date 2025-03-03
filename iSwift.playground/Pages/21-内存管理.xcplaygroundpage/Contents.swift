//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//Swift:基于引用计数的ARC内存管理方案（针对堆空间）

//MARK: - 引用
/*
 • 引用类型
 - 强引用（strong reference）默认情况均为强引用
 - 弱引用（weak reference）通过 weak 定义弱引用
 - 无主引用（unowned reference）通过 unowned 定义无主引用
 */

//1.强引用（strong reference）
//示例代码
class People {
    deinit {
        print("Person.deinit")
    }
}

func foo() {
    let p = People()
}

print("1")
foo()
print("2")
//输出：
//1
//Person.deinit
//2
//注解：foo函数中的p是强引用，会在函数调用结束后自动释放（函数作用域结束）

//2.弱引用（weak reference）
/*
 弱引用变量必须为可选类型的var，因实例销毁后，ARC会自动将弱引用设置为nil
 思考：为什么必须是var?变量，为什么必须可选？
    - 因为只有可选类型才能设置为nil，只有var才能改变内存
 */
//示例代码
weak var p: People? = People()

//ARC自动给弱引用设置nil时，不会触发属性观察器
class Dog {
    deinit {
        print("Dog.deinit")
    }
}
class Lover {
    weak var dog: Dog? {
        willSet {
            print("dog property willSet")
        }
        
        didSet {
            print("dog property didSet")
        }
    }
    deinit {
        print("Lover.deinit")
    }
}

func foo1() {
    var l = Lover()
    print("1")
    l.dog = Dog()
    print("2")
}
foo1()

//输出：
//1
//dog property willSet
//dog property didSet
//Dog.deinit
//2
//Lover.deinit
//注解：dog是弱引用，所以会立即销毁并自动设置为nil，可以看出属性观察器 Dog.deinit 之后并未触发

//3.无主引用（unowned reference）
//无主引用不会产生强引用，实例销毁后仍然存储着实例的内存地址（类似OC中的unsafe_unretained）
//试图在实例销毁后访问无主引用，会产生运行时错误（野指针）
//Fatal error: Attempted to read an unowned reference but object 0x0 was already deallocated

//weak、unowned只能用于类实例
protocol Livable : AnyObject {}
class Human {
    var age: Int = 0
    var name: String = ""
    
    init(age: Int, name: String) {
        self.age = age
        self.name = name
    }
    
    func run() {
        print("Human.run()")
    }
}

weak var p0: Human?
weak var p1: AnyObject?
weak var p2: Livable?

unowned var p10: Human?
unowned var p11: AnyObject?
unowned var p12: Livable?

//MARK: - 自动释放池（Autoreleasepool）
//只需要把释放的代码放到自动释放池的尾随闭包内即可
//示例:
autoreleasepool {
    let h = Human(age: 20, name: "Jack")
    h.run()
}

//MARK: - 循环引用（Reference Cycle）
/*
 • weak、unowned都能解决循环引用的问题、unowned要比weak少一些性能消耗，因为不会有自动置为nil的操作
 • 使用场景：
    - 在生命周期中可能会变为 nil 的使用 weak
    - 初始化赋值后再也不会变为 nil 的使用 unowned
 */

//!!!: 使用weak解决循环引用
//示例代码
class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    var tenant: Person?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var john: Person?
var unit4A: Apartment?

john = Person(name: "John Appleseed")
unit4A = Apartment(unit: "4A")

john!.apartment = unit4A
unit4A!.tenant = john
//解决方案：
//1、Apartment中的tenant变量设置为弱引用
//weak var tenant: Person?

//2、Person中的apartment变量设置为弱引用
//weak var apartment: Apartment?

//!!!: 使用unowned解决循环引用
class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}

class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}

var jack: Customer?
jack = Customer(name: "Jack Appleseed")
jack!.card = CreditCard(number: 1234_5678_9012_3456, customer: jack!)

//MARK: - 闭包的循环引用
/*
 • 闭包
 - 闭包表达式默认会对用到的外层对象产生额外的强引用（对外层对象进行了retain操作）
 */
//循环引用：场景一（无参数）
//class Animal {
//    var fn: (() -> ())?
//    func run() {
//        print("run")
//    }
//    deinit {
//        print("deinit")
//    }
//}
//func test() {
//    let a = Animal()
//    a.fn = {
//        a.run()
//    }
//}
//test()
//Animal对象a对fn有强引用，a.fn的闭包表达式对Animal对象有强引用，两者之间形成循环引用，所以无法释放

//解决循环引用：weak
//func test() {
//    let a = Animal()
//    a.fn = { [weak a] in
//        a?.run()
//    }
//}

//解决循环引用：unowned
//func test() {
//    let a = Animal()
//    a.fn = { [unowned a] in
//        a.run()
//    }
//}

//循环引用：场景一（有参数）
//class Animal {
//    var fn: ((Int) -> ())?
//    func run() {
//        print("run")
//    }
//    deinit {
//        print("deinit")
//    }
//}
//func test() {
//    let a = Animal()
//    a.fn = { Int in
//        a.run()
//    }
//}
//test()

//解决循环引用：weak
//func test() {
//    let a = Animal()
//    a.fn = { [weak a](Int) in
//        a?.run()
//    }
//}

//变量别名：
//a.fn = {
//    [weak wa = a, unowned up = a, i = 10 + 20](Int) in
//    wa?.run()
//}

//MARK: self和lazy
/*
 定义闭包属性的同时引用self，这个闭包必须是lazy的（因为在实例初始化完毕之后才能引用self）
 */
//场景一：
//非lazy闭包属性，为什么不能使用self？
//因为self只有在实例初始化完毕后才能调用（两段式初始化），在初始化属性的同时使用self是不行的，除非在属性前面加上lazy（允许实例初始化完毕之后第一次使用属性时初始化属性）
class Animal {
    lazy var fn: (() -> ()) = {
        self.run()
    }
    
    func run() {
        print("Animal.run")
    }
    
    deinit {
        print("Animal.deinit")
    }
}

func test() {
    var a = Animal()
}

test()
//打印：Animal.deinit
//为什么不存在循环引用？
//因为属性fn没有被用到，所以属性没有对实例进行强引用

func test1() {
    var a = Animal()
    a.fn()
}

test1()
//存在循环引用
//解决循环引用：
//lazy var fn: (() -> ()) = {
//    [weak self] in
//    self?.run()
//}
//或者
//lazy var fn: (() -> ()) = {
//    [weak weakself = self] in
//    weakself?.run()
//}

//场景二：
//class Person {
//    var age: Int = 0
//    lazy var getAge: Int = {
//        self.age
//    }()
//    deinit {
//        print("deinit")
//    }
//}
//
//func test() {
//    let p = Person()
//    print(p.getAge)
//}
//test()
/*
 输出：
 0
 deinit
 */
/*
为什么这里没有循环引用？
- 因为属性getAge后面是一个立即执行的函数，函数执行完成后会立即释放self，只把返回值给到getAge，所以没有造成循环引用
 （该示例中闭包函数体内可以不写self）
 */

//MARK: - 逃逸闭包/转义闭包
/*
 • 非逃逸闭包:闭包调用发生在函数结束前，闭包调用在函数作用域内
 • 逃逸闭包:闭包有可能在函数结束后调用，闭包调用逃离了函数的作用域，需要通过 @escaping 声明
*/
//非逃逸闭包
//typealias Fn = () -> ()
//func test(_ fn: Fn) {
//    fn()
//}
//test {
//    print("1")
//}
// 输出：1

//逃逸闭包
//typealias Fn = () -> ()
//var gFn: Fn?
//func test(_ fn: @escaping Fn) {
//    gFn = fn
//}
//test {
//    print("1")
//}
// 无输出

//func test(_ fn: @escaping Fn) {
//    DispatchQueue.global().async {
//        fn()
//    }
//}

//typealias Fn = () -> ()
//class Person {
//    var fn: Fn
//    init(fn: @escaping Fn) {
//        self.fn = fn
//    }
//    func run() {
//        DispatchQueue.global().async {
//            self.fn()
//        }
//    }
//}
/*
 fn是逃逸闭包。DispatchQueue.global().async也是一个逃逸闭包。它用到了实例成员（属性、方法），编译器会强制要求明确写出self。这里不会产生循环引用，因为仅仅是异步方法对Person做了强引用，而Person没有对异步方法做强引用
 如果Person对象被释放后不需要再调用fn函数（及时释放），则需要使用弱引用：
 DispatchQueue.global().async {
     [weak weakself = self] in
     weakself?.fn()
 }
 */

//!!!: 逃逸闭包不可以捕获inout参数
typealias Fn = () -> ()

func other1(_ fn: Fn) {
    fn()
}

func other2(_ fn: @escaping Fn) {
    fn()
}

func test(value: inout Int) {
    other1 {
        value += 1
    }
    
    //报错:Escaping closure captures 'inout' parameter 'value'
//    other2 {
//        value -= 1
//    }
}

//!!!: other2()报错：Escaping closure captures 'inout' parameter 'value'

//MARK: - 内存泄漏
/*
 //1、这是一个非逃逸闭包(立即执行),因此不需要弱引用
 func uiViewAnimate() {
     UIView.animate(withDuration: 3.0) { self.view.backgroundColor = .red }
 }
 
 //2、同样对于高阶函数,也是非逃逸的,因此不需要弱引用[weak self]
 func higherOrderFunctions() {
     let numbers = [1,2,3,4,5,6,7,8,9,10]
     numbers.forEach { self.view.tag = $0 }
     numbers.forEach { num in
         DispatchQueue.global().async {
             print(num)
         }
     }
     _ = numbers.filter { $0 == self.view.tag }
 }
 
 //3、这会导致 Controller 内存泄漏，因为我们没有立即执行动画。我们把它存储为属性，在闭包中使用了self，同时self也引用了闭包
 func leakyViewPropertyAnimator() {
     // color won't actually change, because we aren't executing the animation
     let anim = UIViewPropertyAnimator(duration: 2.0, curve: .linear) { self.view.backgroundColor = .red }
     anim.addCompletion { _ in self.view.backgroundColor = .white }
     self.anim = anim
 }
 
 //4、如果我们将对要直接操作的属性(view)的引用传递给闭包，而不是使用self，将不会导致内存泄漏，即使不使用[weak self]
 func nonLeakyViewPropertyAnimator1() {
     let view = self.view
     // color won't actually change, because we aren't executing the animation
     let anim = UIViewPropertyAnimator(duration: 2.0, curve: .linear) { view?.backgroundColor = .red }
     anim.addCompletion { _ in view?.backgroundColor = .white }
     self.anim = anim
 }
 
 //5、如果我们立即启动动画，没有在其他地方进行强引用，它不会泄漏控制器，即使没有使用[weak self]
 func nonLeakyViewPropertyAnimator2() {
     let anim = UIViewPropertyAnimator(duration: 2.0, curve: .linear) { self.view.backgroundColor = .red }
     anim.addCompletion { _ in self.view.backgroundColor = .white }
     anim.startAnimation()
 }
 
 //6、如果我们存储一个闭包，它就会逃逸，如果我们不使用[weak self]，它就会造成循环引用从而导致内存泄漏
 func leakyDispatchQueue() {
     let workItem = DispatchWorkItem { self.view.backgroundColor = .red }
     DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: workItem)
     self.workItem = workItem
 }
 
 //7、如果我们立即执行闭包而不存储它，就不需要[weak self]
 func nonLeakyDispatchQueue() {
     DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
         self.view.backgroundColor = .red
     }
     
     DispatchQueue.main.async {
         self.view.backgroundColor = .red
     }
     
     DispatchQueue.global(qos: .background).async {
         print(self.navigationItem.description)
     }
 }
 
 /*8、此计时器将阻止控制器释放，因为：
 *1、定时器重复执行
 *2、self在闭包中引用，而没有使用[weak self]
 *如果这两个条件中的任何一个是错误的，它都不会引起问题*/
 func leakyTimer() {
     let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
         let currentColor = self.view.backgroundColor
         self.view.backgroundColor = currentColor == .red ? .blue : .red
     }
     timer.tolerance = 0.5
     RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
 }
 //9、类似于UIViewPropertyAnimator，如果我们存储一个URLSession任务而不立即执行它，将导致内存泄漏，除非我们使用[weak self]
 func leakyAsyncCall() {
     let url = URL(string: "https://www.github.com")!
     let task = URLSession.shared.downloadTask(with: url) { localURL, _, _ in
         guard let localURL = localURL else { return }
         let contents = (try? String(contentsOf: localURL)) ?? "No contents"
         print(contents)
         print(self.view.description)
     }
     self.closureStorage = task
 }
 
 /*10、如果立即执行URLSession任务，但设置了较长的超时间隔，则会延迟释放
     *直到您取消任务、获得响应或超时。使用[weak self]可以防止延迟
     *注意：url使用端口81有助于模拟请求超时 */
 func delayedAllocAsyncCall() {
     let url = URL(string: "https://www.google.com:81")!
     
     let sessionConfig = URLSessionConfiguration.default
     sessionConfig.timeoutIntervalForRequest = 999.0
     sessionConfig.timeoutIntervalForResource = 999.0
     let session = URLSession(configuration: sessionConfig)
     
     let task = session.downloadTask(with: url) { localURL, _, error in
         guard let localURL = localURL else { return }
         let contents = (try? String(contentsOf: localURL)) ?? "No contents"
         print(contents)
         print(self.view.description)
     }
     task.resume()
 }
 
 //11、这里导致了一个循环引用，因为闭包和“self”相互引用而不是用[weak self],注意这里需要'@escaping'，因为我们正在保存闭包(导致逃逸)以备以后使用
 func savedClosure() {
    func run(closure: @escaping () -> Void) {
        closure()
        self.closureStorage = closure // 'self' stores the closure
    }
 
    run {
        self.view.backgroundColor = .red // the closure references 'self'
    }
 }
 
 //12、这里不需要[weak self]，因为闭包没有转义（没有存储在任何地方）
 func unsavedClosure() {
     func run(closure: () -> Void) {
         closure()
     }
     
     run {
         self.view.backgroundColor = .red // the closure references 'self'
     }
 }
 
 //13、直接将闭包函数传递给closure属性是很方便的，但会导致控制器内存泄漏！
 *原因：self被闭包隐式捕获(在swift中,如UIViewController的viewDidLoad中,可以直接修改view.backgroundColor,而不需要self.view.backgroundColor)，self拥有printingButton，从而创建一个引用循环
 func setupLeakyButton() {
     printingButton?.closure = printer
 }

 func printer() {
     print("Executing the closure attached to the button")
 }
 // 需要[weak self]来打破这个循环，即使它会使语法更难看
 func setupNonLeakyButton() {
     printingButton?.closure = { [weak self] in self?.printer() }
 }
 func printer() {
     print("Executing the closure attached to the button")
 }
 
 //14、尽管这个Dispatch是立即执行的，但是有一个sempaphore(信号量)阻塞了闭包的返回，并且超时很长。这不会导致泄漏，但会导致延迟释放“self”，因为引用self时没有使用“weak”或“unowned”关键字
  func delayedAllocSemaphore() {
     DispatchQueue.global(qos: .userInitiated).async {
         let semaphore = DispatchSemaphore(value: 0)
         print(self.view.description)
         _ = semaphore.wait(timeout: .now() + 99.0)
     }
 }
 
 //15、尽管使用了[weak self]，这个嵌套的闭包还是会泄漏，因为与DispatchWorkItem关联的转义闭包使用其嵌套闭包的[weak self]关键字创建对“self”的强引用。因此，我们需要将[弱自我]提升一级，到最外层的封闭处(DispatchWorkItem {[weak self] in xxxx })，以避免泄漏
 func leakyNestedClosure() {
         
    let workItem = DispatchWorkItem {
        UIView.animate(withDuration: 1.0) { [weak self] in
            self?.view.backgroundColor = .red
        }
    }
    DispatchWorkItem {[weak self] in xxxx }
        self.closureStorage = workItem
        DispatchQueue.main.async(execute: workItem)
    }
 
 //16、以下是三种延时释放的情况,假设在执行DispatchQueue.main.asyncAfter(deadline: .now() + 10)后,未到10秒时self将要释放
 DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
    print(self)// 此时如果将要释放self,会导致无法立即释放,因为闭包引用了self,而self没有引用闭包,10秒后,先打印self,后走deinit{}释放self
 }

 DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [weak self] in
    print(self)// 此时如果将要释放self,因为此处弱引用了self,所以self释放.先走deinit{},10秒后打印self(此时为nil)
 }

 DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
    print("Hello word")// 此时如果将要释放self,因为没有引用self,所以先走deinit{},10秒后打印Hello word
 }
 */

//MARK: - 内存访问冲突
/*
 • 内存访问冲突会在两个访问满足下列条件时发生：
    - 至少一个是写入操作
    - 它们访问的是同一块内存
    - 它们的访问时间重叠（比如在同一个函数内）
 */

//示例代码一:无冲突
func plus(_ num: inout Int) -> Int {
    num + 1
}
var number = 1
number = plus(&number)

//示例代码二:存在冲突
var step = 1
func increment(_ num: inout Int) {
    num += step
}
increment(&step)

//运行时错误：Simultaneous accesses to 0x0, but modification requires exclusive access

//解决冲突：临时变量
//var step = 1
//func increment(_ num: inout Int) {
//    num += step
//}
//var copyofStep = step
//increment(&copyofStep)
//step = copyofStep

//示例代码三:函数
func balance(_ x: inout Int, _ y: inout Int) {
    let sum = x + y
    x = sum / 2
    y = sum - x
}
var num1 = 40
var num2 = 30
balance(&num1, &num2)
//balance(&num1, &num1) 传参是同一个变量就会报错：
//Inout arguments are not allowed to alias each other
//Overlapping accesses to 'num1', but modification requires exclusive access; consider copying to a local variable

//示例代码三:结构体
struct Player {
    var name: String
    var health: Int
    var energy: Int
    mutating func shareHealth(with teammate: inout Player) {
        balance(&teammate.health, &health)
    }
}
var oscar = Player(name: "Oscar", health: 10, energy: 10)
var maria = Player(name: "Maria", health: 5, energy: 10)
oscar.shareHealth(with: &maria)
//oscar.shareHealth(with: &oscar) 传参是调用者就会报错，错误同上

//示例代码三:元组
var tulpe = (health: 10, energy: 20)
balance(&tulpe.health, &tulpe.energy)

//报错:Simultaneous accesses to 0x10000c338, but modification requires exclusive access.
/*
 虽然元组内部的两个变量地址不同，但元组是一块内存，所以会报错
 */

//结构体与元组同样会报错，错误相同
var holly = Player(name: "Holly", health: 10, energy: 10)
balance(&holly.health, &holly.energy)

//MARK: 避免冲突
/*
 - 只访问实例存储属性，不是计算属性或者类属性
 - 结构体是局部变量而非全局变量
 - 结构体要么没有被闭包捕获，要么只被非逃逸闭包捕获
 */

//示例代码
//func test() {
//    var tulpe = (health: 10, energy: 20)
//    balance(&tulpe.health, &tulpe.energy)
//    
//    var holly = Player(name: "Holly", health: 10, energy: 10)
//    balance(&holly.health, &holly.energy)
//}
//test()
//把上面报错的示例代码放到函数体内就可以避免内存访问冲突，因为放到函数体后tulpe和holly就变成了局部变量

//: [Next](@next)
