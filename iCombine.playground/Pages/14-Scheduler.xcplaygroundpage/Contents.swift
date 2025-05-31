//: [Previous](@previous)

import Foundation
import Combine

var greeting = "Combine - Scheduler"

func testSample(label : String, action : Bool, testBlock : () -> Void) {
    guard action else {
        return
    }
    print("-----------[\(label)]:start-----------");
    testBlock()
    print("-----------[\(label)]:end-------------\n");
}

var cancell = Set<AnyCancellable>()

//MARK: - QOS
/*
 DispatchQos
    - userInteractive //用户交互
    - userInitiated   //响应用户初始化，例如打开一个文件
    - default         //默认值
    - utility         //需要计算，用户需要确认结果，例如下载文件、网络通信等
    - background      //后台，比如备份
    - unspecified     //由系统决定，这类任务时效性差
 */

//MARK: - Scheduler
testSample(label: "01_Scheduler", action: true) {
    let immediate = ImmediateScheduler.shared

    print("current thread:\(Thread.current)")

    [1,2,3].publisher
        .receive(on: immediate)
        .sink(receiveValue: {
            print("receive val:\($0)")
            print("receive thread:\(Thread.current)")
        })
        .store(in: &cancell)
}
/*
 结果:
 current thread:<_NSMainThread: 0x60000170c080>{number = 1, name = main}
 receive val:1
 receive thread:<_NSMainThread: 0x60000170c080>{number = 1, name = main}
 receive val:2
 receive thread:<_NSMainThread: 0x60000170c080>{number = 1, name = main}
 receive val:3
 receive thread:<_NSMainThread: 0x60000170c080>{number = 1, name = main}
 */

testSample(label: "02_Scheduler", action: true) {
    let global = DispatchQueue.global()

    print("current thread:\(Thread.current)")

    ["a","b","c"].publisher
        .subscribe(on: global)
        .receive(on: DispatchQueue.main)
        .map({(param) -> String in
            print("param _yy on thread:\(Thread.current)")
            return param + "_yy"
        })
        .receive(on: global)
        .map({(param) -> String in
            print("param _xx on thread:\(Thread.current)")
            return param + "_xx"
        })
        .receive(on: DispatchQueue.main)
        .sink(receiveValue: {
            print("got val:\($0) on thread:\(Thread.current)")
        })
        .store(in: &cancell)
}
/*
 结果:
 -----------[02_Scheduler]:start-----------
 current thread:<_NSMainThread: 0x600001708100>{number = 1, name = main}
 -----------[02_Scheduler]:end-------------

 param _yy on thread:<_NSMainThread: 0x600001708100>{number = 1, name = main}
 param _yy on thread:<_NSMainThread: 0x600001708100>{number = 1, name = main}
 param _xx on thread:<NSThread: 0x60000170c240>{number = 3, name = (null)}
 param _yy on thread:<_NSMainThread: 0x600001708100>{number = 1, name = main}
 param _xx on thread:<NSThread: 0x60000170b200>{number = 5, name = (null)}
 param _xx on thread:<NSThread: 0x600001711540>{number = 4, name = (null)}
 got val:a_yy_xx on thread:<_NSMainThread: 0x600001708100>{number = 1, name = main}
 got val:c_yy_xx on thread:<_NSMainThread: 0x600001708100>{number = 1, name = main}
 got val:b_yy_xx on thread:<_NSMainThread: 0x600001708100>{number = 1, name = main}
 */

//: [Next](@next)
