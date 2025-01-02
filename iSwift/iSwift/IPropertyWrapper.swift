//
//  IPropertyWrapper.swift
//  iSwift
//
//  Created by ibabyblue on 2024/12/18.
//

import Foundation

//属性包装器
@propertyWrapper
struct Clamped {
    private var value: Int
    private let range: ClosedRange<Int>
    
    //包装器的值 wrappedValue 是固定写法
    var wrappedValue: Int {
        get { value }
        set { value = min(max(newValue, range.lowerBound), range.upperBound) }
    }
    
    //初始化
    init(wrappedValue: Int, range: ClosedRange<Int>) {
        self.range = range
        self.value = min(max(wrappedValue, range.lowerBound), range.upperBound)
    }
}

// 使用
struct Settings {
    @Clamped(range: 0...100) var volume: Int = 50
}

func foo() {
    var settings = Settings()
    settings.volume = 101
    print(settings.volume)
}
