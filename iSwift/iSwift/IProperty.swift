//
//  IProperty.swift
//  iSwift
//
//  Created by ibabyblue on 2024/5/16.
//

import Foundation

class IProperty {
    ///变量属性
    var isAnimal : Bool = true
    var names : [String] = ["Lewis","Jonathan","Zack","Lux"]
    var nums : [Int] = [1,2,3]
    var closeStorage : (() -> Void)? = nil;
    
    ///常量属性
    let dic : [String : String] = ["q" : "w"]
    
    ///只读属性
    private(set) var celsius: Double = 0.0
    
    ///观察者属性
    var weight : Float = 1 {
        willSet {
            print("新值：\(newValue)")
        }
        
        didSet {
            print("旧值：\(oldValue)")
        }
    }
    
    //计算属性
    private var _height : Float = 0
    var height : Float {
        get {
            return _height
        }
        
        set {
           _height = newValue
        }
    }
    
}

//自定义操作符（仿写??）
infix operator ???
func ???<T>(optional: T? , defaultValue: @autoclosure ()->T) -> T{
    if let value = optional{ return value}
    return defaultValue()
}

@inline(__always) func A() -> String{
    print("A is called!!!")
    return "A"
}

@inline(never) func B() -> String{
    
    print("B is called!!!")
    return "B"
}

let AorB = A() ??? B()
let AorX = A() ??? "X"
