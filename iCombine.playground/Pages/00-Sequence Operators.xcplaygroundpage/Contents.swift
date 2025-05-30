//: [Previous](@previous)

import Foundation
import Combine

var greeting = "Combine - Sequence Operators"

func testSample(label : String, testBlock : () -> Void) {
    print("-----------[\(label)]:start-----------");
    testBlock()
    print("-----------[\(label)]:end-------------\n");
}

var cancell = Set<AnyCancellable>()

//MARK: - Min
//获取最小值
testSample(label: "01_Min") {
    let arrPublisher = [1, 5, 10, 0, 100].publisher
    arrPublisher
        .min()
        .sink { completion in
            print("01_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("01_receiveValue:\(value)");
        }
        .store(in: &cancell)
}
/*
 结果:
 01_receiveValue:0
 01_receiveCompletion:finished
 */

testSample(label: "02_Min") {
    let srcPublisher = PassthroughSubject<Int, Never>()
    srcPublisher
        .min()
        .sink { completion in
            print("02_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("02_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send(10)
    srcPublisher.send(5)
    srcPublisher.send(50)
    srcPublisher.send(completion: .finished) //完成事件一定要发送，不然min无效
}
/*
 结果:
 02_receiveValue:5
 02_receiveCompletion:finished
 */

testSample(label: "03_Min") {
    let srcPublisher = PassthroughSubject<String, Never>()
    srcPublisher
        .min(by: { v1, v2 in
            let result = v1.count < v2.count
            return result
        })
        .sink { completion in
            print("03_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("03_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send("hello")
    srcPublisher.send("hi")
    srcPublisher.send("hello world")
    srcPublisher.send(completion: .finished) //完成事件一定要发送，不然min无效
}
/*
 结果:
 03_receiveValue:hi
 03_receiveCompletion:finished
 */

//MARK: - Max
testSample(label: "01_Max") {
    let arrPublisher = [1, 5, 10].publisher
    arrPublisher
        .max()
        .sink { completion in
            print("01_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("01_receiveValue:\(value)");
        }
        .store(in: &cancell)
}
/*
 结果:
 01_receiveValue:10
 01_receiveCompletion:finished
 */

testSample(label: "02_Max") {
    let srcPublisher = PassthroughSubject<Int, Never>()
    srcPublisher
        .max()
        .sink { completion in
            print("02_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("02_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send(10)
    srcPublisher.send(5)
    srcPublisher.send(50)
    srcPublisher.send(completion: .finished) //完成事件一定要发送，不然min无效
}
/*
 结果:
 02_receiveValue:50
 02_receiveCompletion:finished
 */

testSample(label: "03_Max") {
    let srcPublisher = PassthroughSubject<String, Never>()
    srcPublisher
        .max(by: { v1, v2 in
            //升序规则
            let result = v1.count < v2.count
            return result
        })
        .sink { completion in
            print("03_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("03_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send("hello")
    srcPublisher.send("hi")
    srcPublisher.send("hello world")
    srcPublisher.send(completion: .finished) //完成事件一定要发送，不然max无效
}
/*
 结果:
 03_receiveValue:hello world
 03_receiveCompletion:finished
 */

//MARK: - First
testSample(label: "01_First") {
    let srcPublisher = PassthroughSubject<String, Never>()
    srcPublisher
        .first()
        .sink { completion in
            print("01_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("01_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send("hello")
    srcPublisher.send("hi")
    srcPublisher.send("hello world")
    srcPublisher.send(completion: .finished)
}
/*
 结果:
 01_receiveValue:hello
 01_receiveCompletion:finished
 */

testSample(label: "02_First") {
    let srcPublisher = PassthroughSubject<String, Never>()
    srcPublisher
        .first(where: { "you are third one".contains($0)})
        .sink { completion in
            print("02_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("02_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send("first")
    srcPublisher.send("second")
    srcPublisher.send("third")
    srcPublisher.send(completion: .finished)
}
/*
 结果:
 02_receiveValue:third
 02_receiveCompletion:finished
 */

//MARK: - Last
testSample(label: "01_Last") {
    let srcPublisher = PassthroughSubject<String, Never>()
    srcPublisher
        .last()
        .sink { completion in
            print("01_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("01_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send("first")
    srcPublisher.send("second")
    srcPublisher.send("third")
    srcPublisher.send(completion: .finished) //完成事件一定要发送，不然last无效
}
/*
 结果:
 01_receiveValue:third
 01_receiveCompletion:finished
 */

testSample(label: "02_Last") {
    let srcPublisher = PassthroughSubject<String, Never>()
    srcPublisher
        .last(where: { "you are first one".contains($0)})
        .sink { completion in
            print("02_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("02_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send("first")
    srcPublisher.send("second")
    srcPublisher.send("third")
    srcPublisher.send("one")
    srcPublisher.send(completion: .finished)
}
/*
 结果: 最后一个满足条件的值
 02_receiveValue:one
 02_receiveCompletion:finished
 */

//MARK: - Output
testSample(label: "01_Output") {
    let srcPublisher = PassthroughSubject<String, Never>()
    srcPublisher
        .output(at: 1)
        .sink { completion in
            print("01_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("01_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send("first")
    srcPublisher.send("second")
    srcPublisher.send("third")
    srcPublisher.send(completion: .finished)
}
/*
 结果:获取发布的指定位置元素
 01_receiveValue:second
 01_receiveCompletion:finished
 */

testSample(label: "02_Output") {
    let srcPublisher = PassthroughSubject<String, Never>()
    srcPublisher
        .output(in: 0...1)
        .sink { completion in
            print("02_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("02_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send("first")
    srcPublisher.send("second")
    srcPublisher.send("third")
    srcPublisher.send(completion: .finished)
}
/*
 结果:获取发布的指定范围元素
 02_receiveValue:first
 02_receiveValue:second
 02_receiveCompletion:finished
 */

//MARK: - Contains
testSample(label: "01_Contains") {
    let srcPublisher = PassthroughSubject<String, Never>()
    srcPublisher
        .contains("second")
        .sink { completion in
            print("01_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("01_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send("first")
    srcPublisher.send("second")
    srcPublisher.send("third")
    srcPublisher.send(completion: .finished)
}
/*
 结果:是否包含某数据
 01_receiveValue:true
 01_receiveCompletion:finished
 */

testSample(label: "02_Contains") {
    let srcPublisher = PassthroughSubject<String, Never>()
    srcPublisher
        .contains(where: { value in
            return value.count == 5 && value.contains("d")
        })
        .sink { completion in
            print("02_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("02_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send("first")
    srcPublisher.send("second")
    srcPublisher.send("third")
    srcPublisher.send(completion: .finished)
}
/*
 结果:是否包含满足条件的某数据
 02_receiveValue:true
 02_receiveCompletion:finished
 */

//MARK: - Satisfy
testSample(label: "01_Satisfy") {
    let srcPublisher = PassthroughSubject<String, Never>()
    srcPublisher
        .allSatisfy({ val in
            val.hasPrefix("hello")
        })
        .sink { completion in
            print("01_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("01_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send("hello")
    srcPublisher.send("hello every one")
    srcPublisher.send("hello world")
    srcPublisher.send(completion: .finished)
}
/*
 结果:是否数据中所有数据都包含相同前缀
 01_receiveValue:true
 01_receiveCompletion:finished
 */

testSample(label: "02_Satisfy") {
    enum ParsingError : Error {
        case notEqual
    }
    let srcPublisher = PassthroughSubject<String, Never>()
    srcPublisher
        .tryAllSatisfy({ value in
            guard value.hasPrefix("hello") else {
                throw ParsingError.notEqual
            }
            return true
        })
        .sink { completion in
            print("02_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("02_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send("hello")
    srcPublisher.send("hello every one")
    srcPublisher.send("hello world")
    srcPublisher.send("hi")
    srcPublisher.send(completion: .finished)
}
/*
 结果:
 02_receiveCompletion:failure(__lldb_expr_112.(unknown context at $101fb889c).(unknown context at $101fb88a4).(unknown context at $101fb88ac).ParsingError.notEqual)
 */

//MARK: - Reduce
testSample(label: "01_Reduce") {
    enum ParsingError : Error {
        case notEqual
    }
    let srcPublisher = PassthroughSubject<Int, Never>()
    srcPublisher
        .reduce(100, { sum, val in
            sum + val
        })
        .sink { completion in
            print("01_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("01_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send(1)
    srcPublisher.send(10)
    srcPublisher.send(100)
    srcPublisher.send(completion: .finished)
}
/*
 结果:reduce只返回最终结果，scan是每次计算结果都返回
 01_receiveValue:211
 01_receiveCompletion:finished
 */

testSample(label: "02_Reduce") {
    enum ParsingError : Error {
        case notEqual
    }
    let srcPublisher = PassthroughSubject<String, Never>()
    srcPublisher
        .reduce("", { str, val in
            str + val
        })
        .sink { completion in
            print("02_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("02_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send("hello")
    srcPublisher.send(" ")
    srcPublisher.send("world")
    srcPublisher.send("!")
    srcPublisher.send(completion: .finished)
}
/*
 结果:拼接字符串
 02_receiveValue:hello world!
 02_receiveCompletion:finished
 */

//MARK: - Comparable
struct CustomDate : Comparable {
    let year : Int
    let month : Int
    let day : Int
    
    static func == (lhs : CustomDate, rhs : CustomDate) -> Bool {
        return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
    }
    
    static func < (lhs : CustomDate, rhs : CustomDate) -> Bool {
        if (lhs.year != rhs.year) {
            return lhs.year < rhs.year
        } else if (lhs.month != rhs.month) {
            return lhs.month < rhs.month
        } else {
            return lhs.day < rhs.day
        }
    }
    
    static func <= (lhs : CustomDate, rhs : CustomDate) -> Bool {
        return lhs < rhs || lhs == rhs
    }
    
    static func > (lhs : CustomDate, rhs : CustomDate) -> Bool {
        return !(lhs < rhs)
    }
    
    static func >= (lhs : CustomDate, rhs : CustomDate) -> Bool {
        return lhs > rhs || lhs == rhs
    }
}

testSample(label: "Comparable") {
    let date1 = CustomDate(year: 2025, month: 1, day: 1)
    let date2 = CustomDate(year: 2025, month: 2, day: 1)
    let date3 = CustomDate(year: 2025, month: 3, day: 1)
    let dates = [date1, date2, date3]
    
    print(dates)
    print(dates.sorted()) //升序
    print(dates.sorted{$0 > $1}) //降序
}
/*
 结果:
 [__lldb_expr_133.CustomDate(year: 2025, month: 1, day: 1), __lldb_expr_133.CustomDate(year: 2025, month: 2, day: 1), __lldb_expr_133.CustomDate(year: 2025, month: 3, day: 1)]
 [__lldb_expr_133.CustomDate(year: 2025, month: 1, day: 1), __lldb_expr_133.CustomDate(year: 2025, month: 2, day: 1), __lldb_expr_133.CustomDate(year: 2025, month: 3, day: 1)]
 [__lldb_expr_133.CustomDate(year: 2025, month: 3, day: 1), __lldb_expr_133.CustomDate(year: 2025, month: 2, day: 1), __lldb_expr_133.CustomDate(year: 2025, month: 1, day: 1)]
 */

testSample(label: "01_Min") {
    let srcPublisher = PassthroughSubject<CustomDate, Never>()
    srcPublisher
        .min()
        .sink { completion in
            print("01_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("01_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send(CustomDate(year: 2025, month: 2, day: 1))
    srcPublisher.send(CustomDate(year: 2025, month: 10, day: 1))
    srcPublisher.send(CustomDate(year: 2025, month: 1, day: 10))
    srcPublisher.send(completion: .finished) //完成事件必须的，否则无效
}
/*
 结果:
 01_receiveValue:CustomDate(year: 2025, month: 1, day: 10)
 01_receiveCompletion:finished
 */


//: [Next](@next)
