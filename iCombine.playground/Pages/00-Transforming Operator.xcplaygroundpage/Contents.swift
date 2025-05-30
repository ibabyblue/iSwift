//: [Previous](@previous)

import Foundation
import Combine

var greeting = "Combine - Transforming Operators"

func testSample(label : String, testBlock : () -> Void) {
    print("-----------[\(label)]:start-----------");
    testBlock()
    print("-----------[\(label)]:end-------------\n");
}

var cancell = Set<AnyCancellable>()

//MARK: -
//MARK: -- Transforming Operators
//MARK: - collect
//collect：一次性获取所有元素
testSample(label: "01_collect") {
    let arrPublisher = [1, 2, 3, 4, 5].publisher
    arrPublisher
        .collect()
        .sink(receiveCompletion : { completion in
            print("01_receiveCompletion:\(completion)");
        }, receiveValue: { value in
            print("01_receiveValue:\(value)");
        }).store(in: &cancell)
}

/*
 结果：
 01_receiveValue:[1, 2, 3, 4, 5]
 01_receiveCompletion:finished
 */

//collect：获取指定元素个数
testSample(label: "02-collect") {
    let srcPublisher = PassthroughSubject<Int, Never>()
    let _ = srcPublisher
        .collect(2)
        .sink(receiveCompletion : { completion in
            print("02_receiveCompletion:\(completion)");
        }, receiveValue: { value in
            print("02_receiveValue:\(value)");
        }).store(in: &cancell)
    
    srcPublisher.send(10)
    srcPublisher.send(20)
    srcPublisher.send(30)
    srcPublisher.send(completion: .finished)
}

/*
 结果：
 02_receiveValue:[10, 20]
 02_receiveValue:[30]
 02_receiveCompletion:finished
 */

//MARK: - map
//map:对每个数据进行处理
testSample(label: "03_map") {
    let arrPublisher = [1,2,3].publisher
    arrPublisher
        .map { val in
            return "转为字符:\(val)" //将每个Int数据转为String
        }.sink { completion in
            print("03_receiveCompletion:\(completion)")
        } receiveValue: { val in
            print("03_receiveValue:\(val)")
        }.store(in: &cancell)
}

/*
 结果：
 03_receiveValue:转为字符:1
 03_receiveValue:转为字符:2
 03_receiveValue:转为字符:3
 03_receiveCompletion:finished
 */

//trymap:对每个数据进行处理
testSample(label: "04_trymap") {
    enum iError : Error {
        case wrongData
    }
    
    let arrPublisher = [1,2,3].publisher
    arrPublisher
        .tryMap { (val) -> String in
            if val == 2 {
                throw iError.wrongData
            }
            return "转为字符:\(val)"
        }
        .sink(receiveCompletion: {completion in
            print("04_receiveCompletion:\(completion)");
        }, receiveValue: { value in
            print("04_receiveValue:\(value)");
        })
        .store(in: &cancell)
}

/*
 结果：
 04_receiveValue:转为字符:1
 04_receiveCompletion:failure(__lldb_expr_60.(unknown context at $10a39781c).(unknown context at $10a397824).(unknown context at $10a39782c).iError.wrongData)
 */

//map:处理单个keyPath
testSample(label: "05_map") {
    struct Student {
        var name : String
        var age : Int
        var nickname : String?
    }
    
    let srcPublisher = PassthroughSubject<Student, Never>()
    srcPublisher
        .map(\.name)
        .sink { completion in
            print("05_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("05_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send(Student(name: "jack", age: 20))
    srcPublisher.send(Student(name: "rose", age: 20))
    srcPublisher.send(completion: .finished)
}
/*
 结果：
 05_receiveValue:jack
 05_receiveValue:rose
 05_receiveCompletion:finished
 */

//map:处理两个keyPath
testSample(label: "06_map") {
    struct Student {
        var name : String
        var age : Int
        var nickname : String?
    }
    
    let srcPublisher = PassthroughSubject<Student, Never>()
    srcPublisher
        .map(\.name, \.age)
        .sink { completion in
            print("06_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("06_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send(Student(name: "jams", age: 18))
    srcPublisher.send(Student(name: "john", age: 20))
    srcPublisher.send(completion: .finished)
}
/*
 结果:
 06_receiveValue:("jams", 18)
 06_receiveValue:("john", 20)
 06_receiveCompletion:finished
 */

//map:处理三个keyPath, !!!: 最多只能处理3三个，多余三个需自定义
testSample(label: "07_map") {
    struct Student {
        var name : String
        var age : Int
        var nickname : String?
    }
    
    let srcPublisher = PassthroughSubject<Student, Never>()
    srcPublisher
        .map(\.name, \.age, \.nickname)
        .sink { completion in
            print("07_receiveCompletion:\(completion)");
        } receiveValue: { name, age, nickname in
            print("07_receiveValue:name(\(name)), age(\(age)), nickname(\(nickname ?? ""))");
        }
        .store(in: &cancell)
    
    srcPublisher.send(Student(name: "William", age: 18, nickname: "wiwi"))
    srcPublisher.send(Student(name: "Mary", age: 20, nickname: "mimi"))
    srcPublisher.send(completion: .finished)
}
/*
 结果:
 07_receiveValue:name(William), age(18), nickname(wiwi)
 07_receiveValue:name(Mary), age(20), nickname(mimi)
 07_receiveCompletion:finished
 */

//MARK: - flatMap
@available(iOS 13.0, *)
public struct Chatter {
    public let name : String
    public let message : CurrentValueSubject<String, Never>
    
    public init(name: String, message: String) {
        self.name = name
        self.message = CurrentValueSubject(message)
    }
}

testSample(label: "08_flatMap") {
    let chatterJack = Chatter(name: "jack", message: "hi rose")
    let chatterRose = Chatter(name: "rose", message: "hi jack")
    let chat = CurrentValueSubject<Chatter, Never>(chatterJack)
    chat
        .sink { completion in
            print("08_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("08_receiveValue:\(value)");
        }
        .store(in: &cancell)
    chatterJack.message.value = "nice to meet you"
    chat.value = chatterJack
}
/*
 结果:!!!: 这里看到message是一个Publisher 并不是消息内容，所以这样做达不到预期
 08_receiveValue:Chatter(name: "jack", message: Combine.CurrentValueSubject<Swift.String, Swift.Never>)
 08_receiveValue:Chatter(name: "jack", message: Combine.CurrentValueSubject<Swift.String, Swift.Never>)
 */

//flatMap:
testSample(label: "09_flatMap") {
    let chatterJack = Chatter(name: "jack", message: "jack:hi rose")
    let chatterRose = Chatter(name: "rose", message: "rose:hi jack")
    let chat = CurrentValueSubject<Chatter, Never>(chatterJack)
    chat
        .flatMap({ output -> CurrentValueSubject<String, Never> in
            output.message //将 CurrentValueSubject<Chatter, Never> 转为 CurrentValueSubject<String, Never>
        })
        .sink { completion in
            print("09_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("09_receiveValue:\(value)");
        }
        .store(in: &cancell)
    //以下赋值将会发出receiveValue
    chatterJack.message.value = "jack:are you ok?"
    chat.value = chatterRose
    chatterRose.message.value = "rose:fine, thank you"
}
/*
 结果:
 09_receiveValue:jack:hi rose
 09_receiveValue:jack:are you ok?
 09_receiveValue:rose:hi jack
 09_receiveValue:rose:fine, thank you
 */

testSample(label: "10_flatMap") {
    let chatterJack = Chatter(name: "jack", message: "jack:hi")
    let chatterRose = Chatter(name: "rose", message: "rose:hello")
    let chatterJohn = Chatter(name: "john", message: "john:what's up")
    
    let chat = CurrentValueSubject<Chatter, Never>(chatterJack)
    chat
        .flatMap(maxPublishers: .max(2), {
            $0.message
        })
        .sink { completion in
            print("10_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("10_receiveValue:\(value)");
        }
        .store(in: &cancell)
    //以下赋值将会发出receiveValue
    chatterJack.message.value = "jack:hi 1"
    chatterRose.message.value = "rose:hello 1"
    
    chat.value = chatterRose
    chatterJack.message.value = "jack:hi 2"
    chatterRose.message.value = "rose:hello 2"
    
    //以下无效
    chat.value = chatterJohn
    chatterJohn.message.value = "john:what's up 1"
}
/*
 结果:
 10_receiveValue:jack:hi
 10_receiveValue:jack:hi 1
 10_receiveValue:rose:hello 1
 10_receiveValue:jack:hi 2
 10_receiveValue:rose:hello 2
 */

//MARK: - replace
testSample(label: "11_replace") {
    let arrPublisher = [1, nil, 2].publisher
    arrPublisher
        .replaceNil(with: 1024)
        .sink { completion in
            print("11_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("11_receiveValue:\(value)");
        }
        .store(in: &cancell)
}
/*
 结果:
 11_receiveValue:1
 11_receiveValue:1024
 11_receiveValue:2
 11_receiveCompletion:finished
 */

testSample(label: "12_replace") {
    //默认无数据可发送，使用replaceEmpty(with:)发送一个数据
    let srcPublisher = Empty<Int, Never>()
    srcPublisher
        .replaceEmpty(with: 1024)
        .sink { completion in
            print("12_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("12_receiveValue:\(value)");
        }
        .store(in: &cancell)
}
/*
 结果:
 12_receiveValue:1024
 12_receiveCompletion:finished
 */

testSample(label: "13_replace") {
    //默认无数据可发送，使用replaceEmpty(with:)发送一个数据
    let arrPublisher = [].publisher
    arrPublisher
        .replaceEmpty(with: 1024)
        .sink { completion in
            print("13_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("13_receiveValue:\(value)");
        }
        .store(in: &cancell)
}
/*
 结果:
 13_receiveValue:1024
 13_receiveCompletion:finished
 */

//MARK: - scan
testSample(label: "14_scan") {
    let srcPublisher = PassthroughSubject<Int, Never>()
    srcPublisher
        .scan(0) { curVal, sumVal in
            print("\(curVal) : \(sumVal)")
            return curVal + sumVal
        }
        .sink { completion in
            print("14_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("14_receiveValue:\(val)");
        }
        .store(in: &cancell)
    
    srcPublisher.send(1)
    srcPublisher.send(2)
    srcPublisher.send(3)
    srcPublisher.send(completion: .finished)
}
/*
 结果:
 0 : 1
 14_receiveValue:1
 1 : 2
 14_receiveValue:3
 3 : 3
 14_receiveValue:6
 14_receiveCompletion:finished
 */

testSample(label: "15_reduce") {
    let srcPublisher = PassthroughSubject<Int, Never>()
    srcPublisher
        .reduce(0, { curVal, sumVal in
            print("\(curVal) : \(sumVal)")
            return curVal + sumVal
        })
        .sink { completion in
            print("15_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("15_receiveValue:\(val)");
        }
        .store(in: &cancell)
    
    srcPublisher.send(1)
    srcPublisher.send(2)
    srcPublisher.send(3)
    srcPublisher.send(completion: .finished)
}
/*
 结果: 只发送最后一次计算的结果给订阅者
 0 : 1
 1 : 2
 3 : 3
 15_receiveValue:6
 15_receiveCompletion:finished
 */


//: [Next](@next)
