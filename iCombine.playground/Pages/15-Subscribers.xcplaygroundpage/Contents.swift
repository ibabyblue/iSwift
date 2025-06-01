//: [Previous](@previous)

import Foundation
import Combine

var greeting = "Combine - Subscribers"

func testSample(label : String, action : Bool, testBlock : () -> Void) {
    guard action else {
        return
    }
    print("-----------[\(label)]:start-----------");
    testBlock()
    print("-----------[\(label)]:end-------------\n");
}

var cancell = Set<AnyCancellable>()

//MARK: - 自定义 Int Subscriber
testSample(label: "01_Subscriber", action: true) {
    final class IntSubscriber : Subscriber {
        //1.设定接受的数据类型
        typealias Input = Int
        typealias Failure = Never
        
        //2.初始的时候，设定接收数据次数
        func receive(subscription: Subscription) {
            subscription.request(.max(5))
        }
                                 
        //3.在每次接收数据后，重新设置需要接收数据的次数，总次数是request（Subscription）方法中设定值和receive（Output）中的总和
        func receive(_ input: Int) -> Subscribers.Demand {
            print("receive value: \(input)")
            return .max(0)
        }
                                 
        //4.接收到结束
        func receive(completion: Subscribers.Completion<Never>) {
            print("competion:\(completion)")
        }
    }
                                 
    let subscriber = IntSubscriber()
    let publisher = (1...8).publisher
    publisher.subscribe(subscriber)
}
/*
 结果:接收次数这是为5，所以只接收5次数据
 receive value: 1
 receive value: 2
 receive value: 3
 receive value: 4
 receive value: 5
 */

testSample(label: "02_Subscriber", action: true) {
    final class IntSubscriber : Subscriber {
        //1.设定接受的数据类型
        typealias Input = Int
        typealias Failure = Never
        
        //2.初始的时候，设定接收数据次数
        func receive(subscription: Subscription) {
            subscription.request(.max(3))
        }
                                 
        //3.在每次接收数据后，重新设置需要接收数据的次数，总次数是request（Subscription）方法中设定值和receive（Output）中的总和
        func receive(_ input: Int) -> Subscribers.Demand {
            print("receive value: \(input)")
            return .max(0)
        }
                                 
        //4.接收到结束事件
        func receive(completion: Subscribers.Completion<Never>) {
            print("competion:\(completion)")
        }
    }
                                 
    let subscriber = IntSubscriber()
    let srcPublisher = CurrentValueSubject<Int, Never>(1)
    srcPublisher.subscribe(subscriber)
    srcPublisher.send(10)
    srcPublisher.send(100)
    srcPublisher.send(completion: .finished)
}
/*
 结果:
 receive value: 1
 receive value: 10
 receive value: 100
 competion:finished
 */

//MARK: - 自定义 String Subscriber
testSample(label: "03_Subscriber", action: true) {
    final class SearchSubscriber : Subscriber {
        private var searchString : String
        
        init(searchString: String) {
            self.searchString = searchString
        }
        
        //1.设定接受的数据类型
        typealias Input = String
        typealias Failure = Never
        
        //2.初始的时候，设定接收数据次数
        func receive(subscription: Subscription) {
            subscription.request(.max(1))
        }
        
        //3.在每次接收数据后，重新设置需要接收数据的次数，总次数是request（Subscription）方法中设定值和receive（Output）中的总和
        func receive(_ input : String) -> Subscribers.Demand {
            print("receive value:\(input)")
            if input == self.searchString {
                return .max(0)
            } else {
                return .max(1)
            }
        }
        
        //4.接收到结束事件
        func receive(completion: Subscribers.Completion<Never>) {
            print("completion:\(completion)")
        }
    }
    
    let subscriber = SearchSubscriber(searchString: "ibabyblue")
    let publisher = PassthroughSubject<String, Never>()
    publisher.subscribe(subscriber)
    publisher.send("ibaby")
    publisher.send("ibabybl")
    publisher.send("ibabyblue") //找到后，后续不再接收
    publisher.send("ibabyblueee")
    publisher.send(completion: .finished)
}
/*
 结果:
 receive value:ibaby
 receive value:ibabybl
 receive value:ibabyblue
 completion:finished
 */

testSample(label: "04_Subscriber", action: true) {
    struct SearchSubscriber : Subscriber {
        //使用struct自定Subscriber时，此协议属性必须自定义实现，使用class则不需要（系统类扩展已实现）
        var combineIdentifier: CombineIdentifier {
            CombineIdentifier()
        }
        
        private var searchString : String
        
        init(searchString: String) {
            self.searchString = searchString
        }
        
        //1.设定接受的数据类型
        typealias Input = String
        typealias Failure = Never
        
        //2.初始的时候，设定接收数据次数
        func receive(subscription: Subscription) {
            subscription.request(.max(1))
        }
        
        //3.在每次接收数据后，重新设置需要接收数据的次数，总次数是request（Subscription）方法中设定值和receive（Output）中的总和
        func receive(_ input : String) -> Subscribers.Demand {
            print("receive value:\(input)")
            if input == self.searchString {
                return .max(0)
            } else {
                return .max(1)
            }
        }
        
        //4.接收到结束事件
        func receive(completion: Subscribers.Completion<Never>) {
            print("completion:\(completion)")
        }
    }
    
    let subscriber = SearchSubscriber(searchString: "ibabyblue")
    let publisher = PassthroughSubject<String, Never>()
    publisher.subscribe(subscriber)
    publisher.send("ibaby")
    publisher.send("ibabybl")
    publisher.send("ibabyblue") //找到后，后续不再接收
    publisher.send("ibabyblueee")
    publisher.send(completion: .finished)
}

//: [Next](@next)
