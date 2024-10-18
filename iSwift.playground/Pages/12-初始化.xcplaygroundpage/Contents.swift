//: [Previous](@previous)

import Foundation

var greeting = "Hello, initializer"

//MARK: - 初始化器
/*
 初始化器：
 - 枚举、结构体、类均可定义初始化器
 - 类的初始化器：
    - 1、指定初始化器（designated initializer）
        - 每个类至少有一个指定初始化器，指定初始化器是类的主要初始化器
        - 默认初始化器总是类的指定初始化器
    - 2、便捷初始化器（convenience initializer）
        - 有关键字 convenience 修饰
        - 便捷初始化方法解决了快速初始化的需求
        - 不能被重写、不能在子类中使用super的方式调用
 - 类初始化器互相调用规则：
    - 指定初始化器必须从它的直系父类调用指定初始化器（纵向调用：子类 -> 父类）
    - 便捷初始化器必须从相同的类中调用例外一个初始化器（横向调用：同类初始化器之间）
    - 便捷初始化器最终必须调用一个指定初始化器(保证所有参数均已初始化)
 */

//示例:
class ClassA {
    var numA: Int
    var numB: Int
    
    //指定初始化器
    init(numA: Int, numB: Int) {
        self.numA = numA
        self.numB = numB
    }
    
    //便捷初始化器
    convenience init(bigNum: Bool) {
        self.init(numA: bigNum ? 1 : 2, numB: bigNum ? 3 : 4)
    }
    
    //便捷初始化器
    convenience init(numA: Int) {
        self.init(bigNum: false)
    }
}
let a = ClassA(bigNum: false)
a.numA

//MARK: - 两段式初始化
/*
 借用OC代码举例，alloc:为第一阶段 init:为第二阶段
 Test *t = [Test alloc] init];
 
 • 第一阶段：（自底向上：子类 -> 父类）
 - 1、外层调用指定\便捷初始化器，
 - 2、分配内存给实例，但未初始化
 - 3、指定初始化器确保当前类定义的存储属性都初始化
 - 4、指定初始化器调用父类初始化器，不断向上调用，形成初始化器链
 
 • 第二阶段：（自顶向下：父类 -> 子类）
 - 1、从顶部初始化器往下，链中的每一个初始化器都有机会进一步定制实例
 - 2、初始化器现在可以使用self（访问、修改属性，调用方法等等）
 - 3、最终，便捷初始化器都有机会定制实例以及使用self
 */

/*
 安全检查：
 - 1、指定初始化器必须保证在调用父类初始化器之前，其所在类定义的所有存储属性都要初始化完成
    - 原因：父类初始化器中调用了某个方法，此方法子类中重写并访问子类属性，如果属性没有初始化，故报错
    - 示例：
    /*
        class Base {
             init() {
                 self.doSomething()
             }

             func doSomething() {
                 print("Base::doSomething")
             }
         }

         class Derived: Base {
             override func doSomething() {
                 print("Derived::doSomething")
             }
         }

         let test = Derived()
     */
 - 2、指定初始化器必须先调用父类初始化器，然后才能为继承的属性设置新值
    - 原因：子类初始化器中访问父类属性，此时父类属性还未初始化，故报错
    - 示例：
    /*
        class Base {
            var p: Int
            init(p: Int) {
                self.p = p
            }
        }
         
        class Derived : Base {
            init() {
                p = 1 //报错：'self' used in property access 'p' before 'super.init' call
                super.init(p: 1)
            }
        }

        let test = Derived()
     */
 - 3、便捷初始化器必须先调用同类中的其它初始化器，然后再为任意属性设置新值
    - 原因：因便捷初始化器必须最终调用指定初始化器，在此之前属性并未初始化，故不可用
    - 示例：
     /*
        class Base {
            var p: Int
            init(p: Int) {
                self.p = p
            }
        }
           
        class Derived : Base {
            override init(p: Int) {
                super.init(p: p)
            }
              
            convenience init() {
                p = 1 //报错：'self' used before 'self.init' call or assignment to 'self'
                self.init(p: 1)
            }
        }
          
        let test = Derived()
      */
 - 4、初始化器在第1阶段初始化完成之前，不能调用任何实例方法、不能读取任何实例属性的值，也不能引用self，直到第1阶段结束，
      实例才算完全合法
    - 便捷初始化器中使用"self"调用便捷初始化器、指定初始化器时， 引用的不是已经初始化的实例，而是指向当前类实例的初始化流程，因此不会违反此时self不能引用规则。
*/

//MARK: - 系统默认初始化器
/*
 系统默认初始化器规则：
 • 无自定义初始化器
    - 如果所有存储属性均有默认值，则编译器会生成一个无参的初始化器
    - 如果存在存储属性无默认值，则编译器不会生成无参的初始化器，必须开发者提供初始化器
 • 存在自定义初始化器
    - 编译器不会生成无参的初始化器
    - 需要显示的定义无参的初始化器（如果需要的话）
 总结：类的默认初始化器只有在 所有存储属性存在默认值并且无自定义初始化器的时候 编译器才会自动生成。
 */

////情况 1：没有自定义初始化器
//class MyClass {
//    var property: Int = 0  // 有默认值
//
//    // 没有自定义初始化器，Swift 自动生成无参初始化器
//}
//
//let instance = MyClass()  // 使用默认的无参初始化器
//
////情况 2：没有默认值，没有自定义初始化器
//class MyClass {
//    var property: Int  // 没有默认值
//
//    // 没有自定义初始化器，编译错误
//}
////!!!: 编译错误：Class 'MyClass' has no initializers
//
////情况 3：定义了自定义初始化器
//class MyClass {
//    var property: Int
//
//    // 自定义初始化器
//    init(property: Int) {
//        self.property = property
//    }
//}
//
//// 无法使用默认的无参初始化器
//let instance = MyClass()  //!!!: 编译错误：Missing argument for parameter 'property' in call
//    
////情况 4：自定义无参初始化器
//class MyClass {
//    var property: Int
//
//    // 自定义初始化器
//    init(property: Int) {
//        self.property = property
//    }
//
//    // 自定义无参初始化器
//    init() {
//        self.property = 0
//    }
//}
//
//let instance = MyClass()  // 使用自定义的无参初始化器



//MARK: - 安全检查
class Animal {
    var age : Int = 0
}

class Cat : Animal {
    var name: String
    var weight: Int
    
    init(name: String) {
        self.name = name
        self.weight = 10
        /*
         安全检查-规则1：
         如果当前类的存储属性无默认值，则调用 super.init() 之前必须将存储属性初始化
         */
        super.init()
        
        /*
         安全检查-规则2：
         如果为继承属性设置新值，则必须在调用 super.init() 之后设置新值
         */
        self.age = 10
    }
    
    convenience init(weight: Int) {
        self.init(name: "miaomiao")
        /*
         安全检查-规则3：
         便捷初始化器必须调用同类中的其它初始化器（self.init(name: "miaomiao")）之后，才能为属性设置新值
         */
        age = 5
    }
}

//MARK: - 重写
/*
 重写：
 - 指定初始化器子类重写时需加 override 关键字
 - 便捷初始化器无法被子类重写，子类无法调用父类的便捷初始化器
 */
class Plant {
    var age : Int
    init(age: Int) {
        self.age = age
    }
    
    convenience init(size : Int) {
        self.init(age: Int(size) + 10)
    }
}

class Grass : Plant {
    override init(age: Int) {
        super.init(age: age)
//        super.init(isNew: false) //报错：super.init' called multiple times in initializer
    }
}

class Tree : Plant {
    //无自定义初始化器，自动继承父类所有指定初始化器
}

let t = Tree(size: 5)

//MARK: 便捷初始化器（自动继承）
/*
 便捷初始化器自动继承：
 - 父类存在便捷初始化器，子类无自定义任何指定初始化器，自动继承父类所有便捷初始化器
 - 父类存在便捷初始化器，子类重写了父类所有指定初始化器，自动继承父类所有便捷初始化器
 */

//MARK: 自动继承总结
/*
 1、如果子类没有自定义任何指定初始化器，它会自动继承父类所有的指定初始化器与便捷初始化器
 2、如果子类提供了父类所有指定初始化器的实现（要么通过方式1继承，要么重写）
    2.1、子类自动继承所有父类便捷初始化器
 3、就算子类添加了更多便捷初始化器，这些规则依然适用
 4、子类以便捷初始化器的形式重写父类的便捷初始化器（子类无法重写父类便捷初始化器），也可以作为满足规则2的一部分
 */

//MARK: 隐式调用父类初始化
/*
 • 如果父类无自定义的指定初始化器，子类可隐式调用父类的初始化器（init()）
 */
class Monkey {
    init() {
        print("Monkey init")
    }
}

class GoldeMonkey : Monkey {
    override init() {
        //重写父类指定初始化方法（init()），隐式调用了父类的init()方法
        print("GoldeMonkey init")
    }
    
    init(age: Int) {
        //自定义的指定初始化方法，隐式调用了父类的init()方法
        print("GoldeMonkey init age:\(age)")
    }
}

let m1 = GoldeMonkey()
let m2 = GoldeMonkey(age: 5)

//MARK: - require
/*
 - 用 required 修饰指定初始化器，表明其所有子类都必须实现该初始化器（通过继承或者重写实现）
 - 如果子类重写了required初始化器，也必须加上required，不用加override
 */

class House {
    var room: Int
    
    required init(room: Int) {
        self.room = room
    }
}

class Apartment : House {
    //继承的方式实现 required 的初始化器
}

let h = Apartment(room: 1)

class Villa : House {
    
    var pool: Int
    
    //存在其它初始化器，则必须显式重写 required 初始化器
    required init(room: Int) {
        self.pool = 6
        super.init(room: room)
    }
    
    //自定义初始化器
    init(pool: Int) {
        self.pool = pool
        super.init(room: 10)
    }
}

let v1 = Villa(room: 1)
let v2 = Villa(pool: 2)

//MARK: - 属性观察器
/*
 父类的属性在自己的初始化器中赋值不会触发属性观察器，子类初始化器中赋值则会触发属性观察器
 */
class Person {
    var age: Int {
        willSet {
            print("Person willSet \(newValue)")
        }
        
        didSet {
            print("Person didSet oldValue:\(oldValue)")
        }
    }
    
    init() {
        self.age = 0
    }
}

class Student : Person {
    
    override init() {
        super.init()
        //子类中赋值，会触发父类的属性观察器
        self.age = 1
    }
}

var stu = Student()

//MARK: - 可失败的初始化器
/*
 • 类、结构体、枚举都可以使用init?定义可失败初始化器
 - 不允许同时定义参数标签、参数个数、参数类型相同的可失败初始化器和非可失败初始化器
 - 可以用init!定义隐式解包的可失败初始化器
 - 可失败初始化器可以调用非可失败初始化器，非可失败初始化器调用可失败初始化器需要进行解包
 - 如果初始化器调用一个可失败初始化器导致初始化失败，那么整个初始化过程都失败，并且之后的代码都停止执行
 - 可以用一个非可失败初始化器重写一个可失败初始化器，但反过来是不行
 */
enum Answer : Int {
case wrong, right
    //可失败初始化器
    init?(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .wrong
        case 1:
            self = .right
        default:
            return nil
        }
    }
}

let answer = Answer(rawValue: 0)

//MARK: - 反初始化器
/*
 反初始化器:
 - 类似C++中的析构函数、OC中的 dealloc 方法
 - deinit 不接受参数，不写小括号，不能自行调用
 - 父类的 deinit 可以被子类继承
 - 子类deinit的实现执行完，会调用父类deinit的实现
 */

class Fish {
    init() {
        print("Fish Obj init")
    }
    
    deinit {
        print("Fish Obj Destroy")
    }
}
//: [Next](@next)
