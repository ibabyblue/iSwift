//: [Previous](@previous)

import Foundation

var greeting = "Hello, methods"

//MARK: 方法
/*
 方法：枚举、结构体、类均可定义实例方法、类型方法
 - 实例方法（Instance Method）
    - 通过实例对象调用
 - 类型方法（Type Method）
    - 通过类型调用，使用static或者class关键字定义
        - static 定义的类型方法不可继承
        - class 定义的类型方法可继承
 
 • self
    - 实例方法中的self，代表实例对象
    - 类型方法中的self，代表类型
 */

class Car {
    static var count = 0;
    
    init() {
        Car.count += 1;
    }
    
    static func getCount() -> Int {
        count
        //等价于
//        self.count
//        Car.count
//        Car.self.count
    }
    
    class func getColor() -> String {
        "black car"
    }
}

//MARK: mutating
/*
 mutating:
 - 结构体、枚举是值类型，默认情况下，值类型的属性不能被自身实例方法修改
 - 在 func 关键字前面增加 mutating 关键字，可允许值类型的属性被自身实例方法修改
 
 @discardableResult
 - 在 func 关键字前面增加 @discardableResult 关键字，可消除方法返回值未被使用的警告
 */
struct Point {
    var x: Int = 0
    var y: Int = 0
    
    mutating func moveBy(deltaX: Int, deltaY: Int) {
        x += deltaX
        y += deltaY
    }
    
    @discardableResult
    func getX() -> Int {
        return x
    }
    
    @discardableResult
    func getY() -> Int {
        return y
    }
}

//下面代码报错，因为let修饰的的结构体实例对象，不可修改，调用方法修改也不行
//let p = Point()
//p.moveBy(deltaX: 1, deltaY: 1)

var p = Point()
p.moveBy(deltaX: 1, deltaY: 1)

p.getX()

//: [Next](@next)
