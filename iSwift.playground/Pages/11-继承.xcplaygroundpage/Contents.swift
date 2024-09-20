//: [Previous](@previous)

import Foundation

var greeting = "Hello, inherit"

//MARK: - 继承
/*
 - 枚举、结构体不支持继承，只有类支持继承
 
 • 基类
    - 没有父类的类，称为基类
    - swift没有OC、Java那样任何类都最终要继承自某个基类的规定
 • 子类可以重写父类的下标、方法、属性，重写时必须使用 override 关键字
 */

/*
 • !!!: 无继承行为或简单的类，建议使用结构体，效率更高。
 • !!!: Swift中的多态底层使用虚表实现（和C++相同）
 */

//MARK: - 重写方法
/*
 • 类型方法：
 - 被 class 修饰的类型方法、下标，允许被子类重写
 - 被 static 修饰的类型方法、下标，不允许被子类重写
 */
class Animal {
    //实例存储属性
    var age = 0
    
    //类型计算属性
    class var weight: Int {
        0
    }
    
    func speak() {
        print("Animal speak")
    }
    
    subscript(index: Int) -> Int {
        return index
    }
    
    class func color() {
        print("Animal color")
    }
    
    class subscript(index: Int) -> Int {
        return index + 1
    }
}

class Dog : Animal {
    var weight = 0
    
    //重写父类实例方法
    override func speak() {
        super.speak()
        print("Dog speak")
    }
    
    //重写父类下标实例方法
    override subscript(index: Int) -> Int {
        return super[index] + 1
    }
    
    //重写父类类型方法
    override class func color() {
        super.color()
        print("Dog color")
    }
    
    //重写父类下标类型方法
    override class subscript(index: Int) -> Int {
        return super[index] + 1
    }
}

var d = Dog()
d.age = 10
d.weight = 20

d.speak()
d[1]

//类型方法
Dog.color()
Dog[6]

//MARK: - 重写属性
/*
 • 实例属性：
 - 子类只能重写父类 var 属性，不能重写 let 属性
 - 重写时，属性名称与类型需一致
 - 子类只能将父类的存储、计算属性，重写为计算属性，不能重写为存储属性（如果是存储属性会破坏内存布局）。
 
 • 类型属性：
 - 被 class 修饰的类型计算属性，可以被子类重写
    - class 不能修饰存储属性的原因：
        - 1、class 是用于定义类型级别的内容，例如类方法、类属性，而不是实例级别的内容，存储属性属于实例级别的概念，此为原因一。
        - 2、存储属性是与特定实例绑定的，每个实例都有一份存储属性的内存空间，此为原因二。
 - 被 static 修饰的类型属性（存储、计算），不可以被子类重写。
    - static 可以修饰存储属性的原因：
        - 1、static 修饰的属性，本质上与实例无关，类似全局存储属性
 
 • 属性权限
 子类重写后的属性权限需大于等于父类属性的权限
 - 父类的属性是只读的，子类重写后可为只读的，也可以是可读可写的
 - 父类的属性是可读可写的，子类重写后也必须是可读可写的，不能是只读的
 */
class Cat : Animal {
    //重写父类实例存储属性为：实例计算属性
    override var age: Int {
        get {
            super.age
        }
        
        set {
            super.age = newValue
        }
    }
    
    //重写父类类型计算属性为：类型计算属性
    override class var weight: Int {
        super.weight
    }
}

var cat = Cat()
Cat.weight

//MARK: - 属性观察器
/*
 子类中可以为父类属性（除了只读计算属性、let属性）增加属性观察器，增加属性观察器 与 子类只能将父类的存储、计算属性，重写为计算属性 不冲突。
 - 示例一：父类存储属性
    - 子类：willset
    - 子类：didset
 - 示例二：父类本身实现属性观察器，子类依然可以重写属性观察器
    子类和父类的属性观察器方法都会调用，调用顺序如下：
    - 子类：willset
    - 父类：willset
    - 父类：didset
    - 子类：didset
 - 示例三：父类计算属性，子类重写增加属性观察器
    调用顺序如下：
    - 父类：get方法
    - 子类：willset
    - 父类：set方法
    - 父类：get方法
    - 子类：didset
 - 示例四：父类类型计算属性，子类重写增加属性观察器
    调用顺序如下：
    - 父类：get方法
    - 子类：willset
    - 父类：set方法
    - 父类：get方法
    - 子类：didset
 */

////示例一:
//class Circle {
//    var radius: Int = 1
//}
//
//class SubCircle : Circle {
//    override var radius: Int {
//        willSet {
//            print("SubCircle willSet \(newValue)")
//        }
//        
//        didSet {
//            print("SubCircle didSet \(oldValue)", radius)
//        }
//    }
//}
//
//var circle = SubCircle()
//circle.radius = 2

////示例二:
//class Circle {
//    var radius: Int = 1 {
//        willSet {
//            print("Circle willSet \(newValue)")
//        }
//        
//        didSet {
//            print("Circle didSet \(oldValue)", radius)
//        }
//    }
//}
//
//class SubCircle : Circle {
//    override var radius: Int {
//        willSet {
//            print("SubCircle willSet \(newValue)")
//        }
//        
//        didSet {
//            print("SubCircle didSet \(oldValue)", radius)
//        }
//    }
//}
//
//var circle = SubCircle()
//circle.radius = 2

////示例三：
//class Circle {
//    var radius: Int {
//        set {
//            print("Circle setRadius \(newValue)")
//        }
//        
//        get {
//            print("Circle getRadius")
//            return 10
//        }
//    }
//}
//
//class SubCircle : Circle {
//    override var radius: Int {
//        willSet {
//            print("SubCircle willSet \(newValue)")
//        }
//
//        didSet {
//            print("SubCircle didSet \(oldValue)", radius)
//        }
//    }
//}
//
//var circle = SubCircle()
//circle.radius = 2

//示例四：
class Circle {
    class var radius: Int {
        set {
            print("Circle setRadius \(newValue)")
        }
        
        get {
            print("Circle getRadius")
            return 10
        }
    }
}

class SubCircle : Circle {
    override static var radius: Int {
        willSet {
            print("SubCircle willSet \(newValue)")
        }

        didSet {
            print("SubCircle didSet \(oldValue)", radius)
        }
    }
}

SubCircle.radius = 2

//MARK: - final
/*
 final关键字：
 - final修饰的方法、属性、下标，禁止被重写
 - final修饰的类，禁止被继承
 */
final class Point {
    var x: Int = 0, y: Int = 0
}

//: [Next](@next)
