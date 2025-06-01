//: [Previous](@previous)

import Foundation
import Combine
import SwiftUI

var greeting = "Combine - Publishers_Subscribers"

func testSample(label : String, testBlock : () -> Void) {
    print("-----------[\(label)]:start-----------");
    testBlock()
    print("-----------[\(label)]:end-------------\n");
}

var cancell = Set<AnyCancellable>()

//MARK: - Just
/*
 https://developer.apple.com/documentation/combine/just
 Just 不会产生错误，只会发送一个单一的数据。
 */
testSample(label: "01_Just") {
    let justScriber = Just("10")
    
    let scriber1 = Subscribers.Sink<String,Never> (receiveCompletion: { completion in
        if completion == .finished {
            print("scriber1 Finished")
        } else {
            print("scriber1 Failure")
        }
    }, receiveValue: { value in
        print(value)
    })

    let scriber2 = Subscribers.Sink<String,Never> (receiveCompletion: { completion in
        if completion == .finished {
            print("scriber2 Finished")
        } else {
            print("scriber2 Failure")
        }
    }, receiveValue: { value in
        print(value)
    })

    justScriber.subscribe(scriber1)
    justScriber.subscribe(scriber2)
}
/*
 结果:
 10
 scriber1 Finished
 10
 scriber2 Finished
 */

testSample(label: "02_Just" ) {
    let integers : ClosedRange<Int> = 0...3
    integers
        .publisher
        .sink {
            print("Received \($0)")
        }
}
/*
 结果:
 Received 0
 Received 1
 Received 2
 Received 3
 */

testSample(label: "03_Just" ) {
    let range : ClosedRange<Int>  = 0...3
    let cancellable = range.publisher
        .sink(receiveCompletion: {
                print ("completion: \($0)"
                )},
              receiveValue: {
                print ("value: \($0)")
        })
}
/*
 结果:
 value: 0
 value: 1
 value: 2
 value: 3
 completion: finished
 */

testSample(label: "04_Just" ) {
    class FooClass {
        var anInt: Int = 0 {
            didSet {
                print("anInt 被复制为 : \(anInt)", terminator: "; \n")
            }
        }
    }

    let fooObject = FooClass()
    let range  : ClosedRange<Int> = 0...2
    let cancellable = range
                        .publisher
                        .assign(to: \.anInt, on: fooObject)
}
/*
 结果:
 anInt 被复制为 : 0;
 anInt 被复制为 : 1;
 anInt 被复制为 : 2;
 */

//testSample(label: "05_Just" ) {
//    class FooModel: ObservableObject {
//        @Published var lastUpdated: Date = Date() // Calendar.current.date(byAdding: .day, value: -3, to: Date())!
//
//        init() {
//             Timer.publish(every: 1.0, on: .main, in: .common)
//                 .autoconnect()
//                 .assign(to: &$lastUpdated) /// public func assign(to published: inout Published<Self.Output>.Publisher)
//        }
//    }
//    let model = FooModel()
//    print(model.lastUpdated)
//}

testSample(label: "06_Just" ) {
    class FooModel: ObservableObject {
        @Published var id: Int = 0
    }
    
    let model = FooModel()
    /// public func assign(to published: inout Published<Self.Output>.Publisher)
    Just(100).assign(to: &model.$id)
    print(model.id)
    
    let model2 = FooModel()
    Just(101).assign(to: \.id, on: model2)
    print(model2.id)
}
/*
 结果:
 100
 101
 */

//MARK: - Future
testSample(label: "01_Future" ) {
    let futurePubliser = Future<Int, Never> { promise in
        //异步执行 耗时操作
        print("i will promise soon")
        promise(.success(100))
    }
    let scriber1 = Subscribers.Sink<Int,Never> (receiveCompletion: { completion in
            if completion == .finished {
                print("scriber v1 Finished")
            } else {
                print("scriber v1 Failure")
            }
        }, receiveValue: { value in
            print(value)
        })
    let scriber2 = Subscribers.Sink<Int,Never> (receiveCompletion: { completion in
            if completion == .finished {
                print("scriber v2 Finished")
            } else {
                print("scriber v2 Failure")
            }
        }, receiveValue: { value in
            print(value)
        })
    
    futurePubliser.subscribe(scriber1)
    futurePubliser.subscribe(scriber2)
    
    class FooModel {
        var id: Int = 0
    }
    
    let model = FooModel()
    futurePubliser.assign(to: \.id, on: model)
    print("model : \(model.id)")
}
/*
 结果:
 i will promise soon
 100
 scriber v1 Finished
 100
 scriber v2 Finished
 model : 100
 */

//: [Next](@next)
