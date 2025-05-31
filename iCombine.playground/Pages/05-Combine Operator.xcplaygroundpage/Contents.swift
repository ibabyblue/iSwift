//: [Previous](@previous)

import Foundation
import Combine

var greeting = "Combine - Combine Operator"

func testSample(label : String, testBlock : () -> Void) {
    print("-----------[\(label)]:start-----------");
    testBlock()
    print("-----------[\(label)]:end-------------\n");
}

var cancell = Set<AnyCancellable>()

//MARK: - prepend
testSample(label: "01_prepend") {
    let arrPublisher = [1,2,3].publisher
    
    arrPublisher
        .prepend(-1, -2, -3)
        .sink { completion in
            print("01_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("01_receiveValue:\(val)");
        }
        .store(in: &cancell)
}
/*
 结果:在数据前面增加数据
 01_receiveValue:-1
 01_receiveValue:-2
 01_receiveValue:-3
 01_receiveValue:1
 01_receiveValue:2
 01_receiveValue:3
 01_receiveCompletion:finished
 */

testSample(label: "02_prepend") {
    let srcPublisher = PassthroughSubject<Int, Never>()
    
    srcPublisher
        .prepend(-1, -2, -3)
        .sink { completion in
            print("02_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("02_receiveValue:\(val)");
        }
        .store(in: &cancell)
    
    srcPublisher.send(100)
    srcPublisher.send(200)
    srcPublisher.send(completion: .finished)
}
/*
 结果:
 02_receiveValue:-1
 02_receiveValue:-2
 02_receiveValue:-3
 02_receiveValue:100
 02_receiveValue:200
 02_receiveCompletion:finished
 */

testSample(label: "03_prepend") {
    let arrPublisher = [1,2].publisher
    let srcPublisher = PassthroughSubject<Int, Never>()
    
    srcPublisher
        .prepend(arrPublisher)
        .sink { completion in
            print("03_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("03_receiveValue:\(val)");
        }
        .store(in: &cancell)
    
    srcPublisher.send(3)
    srcPublisher.send(6)
    srcPublisher.send(20)
    srcPublisher.send(completion: .finished)
}
/*
 结果:
 03_receiveValue:1
 03_receiveValue:2
 03_receiveValue:3
 03_receiveValue:6
 03_receiveValue:20
 03_receiveCompletion:finished
 */

testSample(label: "04_prepend") {
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<Int, Never>()
    
    publisher2
        .prepend(publisher1)
        .sink { completion in
            print("04_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("04_receiveValue:\(val)");
        }
        .store(in: &cancell)
    
    publisher1.send(1)
    publisher1.send(2)
    publisher1.send(3)
    publisher1.send(completion: .finished) //如果这里注释，则publisher2发送4、5不会接受到，因为publisher1没有发送完成
    publisher2.send(4)
    publisher2.send(5)
    publisher2.send(completion: .finished)
}
/*
 结果:
 04_receiveValue:1
 04_receiveValue:2
 04_receiveValue:3
 04_receiveValue:4
 04_receiveValue:5
 04_receiveCompletion:finished
 */

//MARK: - append
testSample(label: "05_append") {
    let arrPublisher = [1,2,3].publisher
    
    arrPublisher
        .append(-1, -2, -3)
        .sink { completion in
            print("05_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("05_receiveValue:\(val)");
        }
        .store(in: &cancell)
}
/*
 结果:在数据后面追加数据
 05_receiveValue:1
 05_receiveValue:2
 05_receiveValue:3
 05_receiveValue:-1
 05_receiveValue:-2
 05_receiveValue:-3
 05_receiveCompletion:finished
 */

testSample(label: "06_append") {
    let srcPublisher = PassthroughSubject<Int, Never>()
    
    srcPublisher
        .append(-1, -2, -3)
        .sink { completion in
            print("06_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("06_receiveValue:\(val)");
        }
        .store(in: &cancell)
    
    srcPublisher.send(100)
    srcPublisher.send(200)
    srcPublisher.send(completion: .finished) //之后调用者发送完成，-1 -2 -3 才会被追加
}
/*
 结果:
 06_receiveValue:100
 06_receiveValue:200
 06_receiveValue:-1
 06_receiveValue:-2
 06_receiveValue:-3
 06_receiveCompletion:finished
 */

testSample(label: "07_append") {
    let arrPublisher = [10,20].publisher
    let srcPublisher = PassthroughSubject<Int, Never>()
    
    srcPublisher
        .append(arrPublisher)
        .sink { completion in
            print("07_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("07_receiveValue:\(val)");
        }
        .store(in: &cancell)
    
    srcPublisher.send(1)
    srcPublisher.send(2)
    srcPublisher.send(3)
    srcPublisher.send(completion: .finished) //调用完成事件，append生效
}
/*
 结果:
 07_receiveValue:1
 07_receiveValue:2
 07_receiveValue:3
 07_receiveValue:10
 07_receiveValue:20
 07_receiveCompletion:finished
 */

testSample(label: "08_append") {
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<Int, Never>()
    
    publisher2
        .append(publisher1)
        .sink { completion in
            print("08_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("08_receiveValue:\(val)");
        }
        .store(in: &cancell)

    publisher2.send(4)
    publisher2.send(5)
    publisher2.send(completion: .finished) //如果这里注释，则publisher1发送1、2、3不会接受到，因为publisher2没有发送完成
    publisher1.send(1)
    publisher1.send(2)
    publisher1.send(3)
    publisher1.send(completion: .finished)

}
/*
 结果:
 08_receiveValue:4
 08_receiveValue:5
 08_receiveValue:1
 08_receiveValue:2
 08_receiveValue:3
 08_receiveCompletion:finished
 */

//MARK: - switchToLatest
//多个发布者发布数据后，只有最新的数据被处理
testSample(label: "09_switchToLatest") {
    let publishers = PassthroughSubject<PassthroughSubject<Int, Never>, Never>()
    let aPublisher = PassthroughSubject<Int, Never>()
    let bPublisher = PassthroughSubject<Int, Never>()
    let cPublisher = PassthroughSubject<Int, Never>()
    
    publishers
        .switchToLatest()
        .sink { completion in
            print("09_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("09_receiveValue:\(val)");
        }
        .store(in: &cancell)

    publishers.send(aPublisher)
    aPublisher.send(1)
    aPublisher.send(2)
    
    publishers.send(bPublisher)
    aPublisher.send(3) //已经切换到bPublisher，aPublisher发送的数据不再接收
    bPublisher.send(4)
    bPublisher.send(5)
    
    publishers.send(cPublisher)
    bPublisher.send(6)//已经切换到cPublisher，bPublisher发送的数据不再接收
    cPublisher.send(7)
    cPublisher.send(8)

    cPublisher.send(completion: .finished) //cPublisher结束发送数据，不会影响publishers，订阅者不会收到completion回调
    publishers.send(completion: .finished) //publishers结束发送数据，订阅者会收到completion回调
}
/*
 结果:
 09_receiveValue:1
 09_receiveValue:2
 09_receiveValue:4
 09_receiveValue:5
 09_receiveValue:7
 09_receiveValue:8
 */

//MARK: - merge
//合并发送数据
testSample(label: "10_merge") {
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<Int, Never>()
    
    publisher1
        .merge(with: publisher2)
        .sink { completion in
            print("10_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("10_receiveValue:\(val)");
        }
        .store(in: &cancell)

    publisher1.send(1)
    publisher2.send(2)
    publisher1.send(5)
    publisher2.send(4)
    publisher2.send(4)
    publisher1.send(completion: .finished)
    publisher2.send(completion: .finished)
}
/*
 结果:
 10_receiveValue:1
 10_receiveValue:2
 10_receiveValue:5
 10_receiveValue:4
 10_receiveValue:4
 10_receiveCompletion:finished
 */

//MARK: - combineLatest
//合并发送数据
testSample(label: "11_combineLatest") {
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<Int, Never>()
    
    publisher1
        .combineLatest(publisher2)
        .sink { completion in
            print("11_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("11_receiveValue:\(val)");
        }
        .store(in: &cancell)

    publisher1.send(1)
    publisher2.send(2)
    publisher1.send(5)
    publisher2.send(4)
    publisher2.send(4)
    publisher1.send(completion: .finished)
    publisher2.send(completion: .finished)
}
/*
 结果:
 11_receiveValue:(1, 2)
 11_receiveValue:(5, 2)
 11_receiveValue:(5, 4)
 11_receiveValue:(5, 4)
 11_receiveCompletion:finished
 */

//MARK: - zip
//一对一合并发送数据
testSample(label: "12_zip") {
    let publisher1 = PassthroughSubject<Int, Never>()
    let publisher2 = PassthroughSubject<Int, Never>()
    
    publisher1
        .zip(publisher2)
        .sink { completion in
            print("11_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("11_receiveValue:\(val)");
        }
        .store(in: &cancell)

    publisher1.send(1)
    publisher2.send(2)
    publisher1.send(5)
    publisher2.send(4)
    publisher2.send(4)
    publisher1.send(completion: .finished)
    publisher2.send(completion: .finished)
}
/*
 结果:
 11_receiveValue:(1, 2)
 11_receiveValue:(5, 4)
 11_receiveCompletion:finished
 */

//: [Next](@next)
