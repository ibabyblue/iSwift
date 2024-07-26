//
//  ISwiftBridging.swift
//  iSwift
//
//  Created by ibabyblue on 2024/5/16.
//  测试混编-Swift文件

import Foundation

//!!!: 必须继承自NSObject，才能被Objective-c识别
class ISwiftBridging : NSObject {
    
    @objc func foo() -> String? {
        return "foo"
    }
    
    @objc static func sFoo() {
        print("invoke swift sFoo method")
    }
    
    func invokeFoo() {
        IObjectiveCBridging.sFoo()
        let ib = IObjectiveCBridging()
        ib.foo()
    }
}
