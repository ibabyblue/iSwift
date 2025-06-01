//: [Previous](@previous)

import Foundation
import Combine

var greeting = "Combine - Subjects"

func testSample(label : String, testBlock : () -> Void) {
    print("-----------[\(label)]:start-----------");
    testBlock()
    print("-----------[\(label)]:end-------------\n");
}

var cancell = Set<AnyCancellable>()

enum ICErrors :Error {
    case wrongVlue
}

//MARK: - CurrentValueSubject
testSample(label: "01_CurrentValueSubject") {
    //CurrentValueSubject() 初始化时有初始值
    let curPubliser = CurrentValueSubject<String,ICErrors>("100")

    let curSubscriber = curPubliser.filter({
        return $0.count < 5
    }).sink(receiveCompletion: { completion in
        if completion == .failure(ICErrors.wrongVlue) {
            print("curSubscriber MyErrors.wrongVlue")
        } else {
            print(completion)
        }
    }, receiveValue: { value in
        print("curSubscriber Value:\(value)")
    })
    
    let sScriber = Subscribers.Sink<String, ICErrors> (receiveCompletion: { completion in
        if completion == .finished {
            print("sScriber Finished")
        } else {
            print("sScriber Failure")
        }
    }, receiveValue: { value in
        print("sScriber receiveValue: \(value)")
    })
    
    /// 产生订阅关系
    curPubliser.receive(subscriber: sScriber)
    
    /// 发送数据
    curPubliser.send("h")
    curPubliser.send("he")
    curPubliser.send("hel")
    curPubliser.send("hell")
    curPubliser.send("hello")
    curPubliser.send("hello,world.")

    // 发送失败数据
    curPubliser.send(completion: .failure(.wrongVlue))
    // 即使发送，订阅者也接收不到
    curPubliser.send("ni") // 结束后（错误结束或者正常结束），将不再发布。
}
/*
 curSubscriber Value:100
 sScriber receiveValue: 100
 curSubscriber Value:h
 sScriber receiveValue: h
 curSubscriber Value:he
 sScriber receiveValue: he
 curSubscriber Value:hel
 sScriber receiveValue: hel
 curSubscriber Value:hell
 sScriber receiveValue: hell
 sScriber receiveValue: hello
 sScriber receiveValue: hello,world.
 curSubscriber MyErrors.wrongVlue
 sScriber Failure
 */

testSample(label: "02_CurrentValueSubject") {
    
    let subject1: CurrentValueSubject<Int, ICErrors> = .init(55)
    let subject2: CurrentValueSubject<Int, ICErrors> = .init(100)
    
    // subject1 -> subject2; 箭头指的是 数据流
    let cancelable = subject1.subscribe(subject2)
 
    let sScriber = Subscribers.Sink<Int, ICErrors> (receiveCompletion: { completion in
        if completion == .finished {
            print("sScriber Finished")
        } else {
            print("sScriber Failure")
        }
    }, receiveValue: { value in
        print("sScriber receiveValue: \(value)")
    })
    
    // subject1 -> subject2 -> sScriber
    subject2.receive(subscriber: sScriber)
    
    subject1.send(1)
    subject1.send(2)
    subject2.send(66)
    subject1.send(completion: .failure(.wrongVlue))
    
    subject1.send(11) //无效,因为结束后，将不再发布
    subject2.send(77) //无效,因为结束后，将不再发布
}
/*
 结果:
 sScriber receiveValue: 55
 sScriber receiveValue: 1
 sScriber receiveValue: 2
 sScriber receiveValue: 66
 sScriber Failure
 */

//MARK: - PassthroughSubject
testSample(label: "01_PassthroughSubject") {
    
    let subject1: PassthroughSubject<Int, ICErrors> = PassthroughSubject()
    let subject2: PassthroughSubject<Int, ICErrors> = PassthroughSubject()
    
    // subject1 -> subject2
    let cancelable = subject1.subscribe(subject2)
 
    let sScriber = Subscribers.Sink<Int, ICErrors> (receiveCompletion: { completion in
        if completion == .finished {
            print("sScriber Finished")
        } else {
            print("sScriber Failure")
        }
    }, receiveValue: { value in
        print("sScriber receiveValue: \(value)")
    })
    
    // subject1 -> subject2 -> sScriber
    subject2.receive(subscriber: sScriber)
    
    subject1.send(1)
    subject1.send(2)
    subject2.send(66)
    subject1.send(completion: .failure(.wrongVlue))
    
    subject1.send(11) //无效,因为结束后，将不再发布
    subject2.send(77) //无效,因为结束后，将不再发布
}
/*
 结果:
 sScriber receiveValue: 1
 sScriber receiveValue: 2
 sScriber receiveValue: 66
 sScriber Failure
 */

//: [Next](@next)
