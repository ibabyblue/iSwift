import UIKit
import Combine

var greeting = "Combine - Filtering Operators"

func testSample(label : String, testBlock : () -> Void) {
    print("-----------[\(label)]:start-----------");
    testBlock()
    print("-----------[\(label)]:end-------------\n");
}

var cancell = Set<AnyCancellable>()

//MARK: -
//MARK: -- Filtering Operators
//MARK: - filter
testSample(label: "01_filter") {
    let arrPublisher = [1,2,3].publisher
    arrPublisher
        .filter({ ele in
            ele < 3 //小于3
        })
        .sink { completion in
            print("01_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("01_receiveValue:\(val)");
        }
        .store(in: &cancell)
}
/*
 结果:
 01_receiveValue:1
 01_receiveValue:2
 01_receiveCompletion:finished
 */

testSample(label: "02_filter") {
    let srcPublisher = PassthroughSubject<Int, Never>()
    srcPublisher
        .filter({ ele in
            ele > 2 //大于2
        })
        .sink { completion in
            print("02_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("02_receiveValue:\(val)");
        }
        .store(in: &cancell)
    
    srcPublisher.send(1)
    srcPublisher.send(2)
    srcPublisher.send(3)
    srcPublisher.send(completion: .finished)
}
/*
 结果:
 02_receiveValue:3
 02_receiveCompletion:finished
 */

//MARK: - removeDuplicates
testSample(label: "03_removeDuplicates") {
    let arrPublisher = [1,1,2,2,3].publisher
    arrPublisher
        .removeDuplicates()
        .sink { completion in
            print("03_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("03_receiveValue:\(val)");
        }
        .store(in: &cancell)
}
/*
 结果:
 03_receiveValue:1
 03_receiveValue:2
 03_receiveValue:3
 03_receiveCompletion:finished
 */

testSample(label: "04_removeDuplicates") {
    let srcPublisher = PassthroughSubject<Int, Never>()
    srcPublisher
        .removeDuplicates(by: { v1, v2 in
            let diff = v1 - v2
            //相邻元素差值小于5的删除
            if abs(diff) < 5 {
                return true
            } else {
                return false
            }
        })
        .sink { completion in
            print("04_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("04_receiveValue:\(val)");
        }
        .store(in: &cancell)
    
    srcPublisher.send(1)
    srcPublisher.send(4)
    srcPublisher.send(6)
    srcPublisher.send(12)
    srcPublisher.send(completion: .finished)
}

/*
 结果:
 04_receiveValue:1
 04_receiveValue:6
 04_receiveValue:12
 04_receiveCompletion:finished
 */

//MARK: - compactMap
testSample(label: "05_compactMap") {
    let numbers = (0...5).publisher
    let romannumeralsDict = [1 : "I", 2 : "II", 3 : "III", 5 : "V"]
    numbers
        .compactMap({
            romannumeralsDict[$0]
        })
        .sink { completion in
            print("05_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("05_receiveValue:\(val)");
        }
        .store(in: &cancell)
}
/*
 结果: 忽略空值
 05_receiveValue:I
 05_receiveValue:II
 05_receiveValue:III
 05_receiveValue:V
 05_receiveCompletion:finished
 */

testSample(label: "06_compactMap") {
    let numbers = ["1","2","3","a","4"].publisher
    numbers
        .compactMap({
            Float($0)
        })
        .sink { completion in
            print("06_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("06_receiveValue:\(val)");
        }
        .store(in: &cancell)
}
/*
 结果: 忽略空值
 06_receiveValue:1.0
 06_receiveValue:2.0
 06_receiveValue:3.0
 06_receiveValue:4.0
 06_receiveCompletion:finished
 */

//MARK: - ignoreOutput
testSample(label: "07_ignoreOutput") {
    let numbers = (0...5).publisher
    numbers
        .ignoreOutput()
        .sink { completion in
            print("07_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("07_receiveValue:\(val)");
        }
        .store(in: &cancell)
}
/*
 结果:忽略发送数据
 07_receiveCompletion:finished
 */

//MARK: - drop
testSample(label: "08_dropFirst") {
    let numbers = (0...5).publisher
    numbers
        .dropFirst()
        .sink { completion in
            print("08_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("08_receiveValue:\(val)");
        }
        .store(in: &cancell)
}
/*
 结果:丢弃第一个元素0
 08_receiveValue:1
 08_receiveValue:2
 08_receiveValue:3
 08_receiveValue:4
 08_receiveValue:5
 08_receiveCompletion:finished
 */

testSample(label: "09_dropFirst") {
    let numbers = (0...5).publisher
    numbers
        .dropFirst(3)
        .sink { completion in
            print("09_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("09_receiveValue:\(val)");
        }
        .store(in: &cancell)
}
/*
 结果:丢弃前三个元素0 1 2
 09_receiveValue:3
 09_receiveValue:4
 09_receiveValue:5
 09_receiveCompletion:finished
 */

testSample(label: "10_drop(while)") {
    let numbers = (0...5).publisher
    numbers
        .drop(while: { val in
            val < 4
        })
        .sink { completion in
            print("10_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("10_receiveValue:\(val)");
        }
        .store(in: &cancell)
}
/*
 结果:从第一个元素开始丢弃到判断条件的元素
 10_receiveValue:4
 10_receiveValue:5
 10_receiveCompletion:finished
 */

testSample(label: "11_drop(untilOutputFrom)") {
    let srcPublisher = PassthroughSubject<Int, Never>()
    let readPublisher = PassthroughSubject<Void, Never>() //发送事件时，才接受数据
    
    srcPublisher
        .drop(untilOutputFrom: readPublisher)
        .sink { completion in
            print("11_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("11_receiveValue:\(val)");
        }
        .store(in: &cancell)
    
    srcPublisher.send(1)
    srcPublisher.send(2)
    readPublisher.send()
    srcPublisher.send(3)
    srcPublisher.send(completion: .finished)
}
/*
 结果:
 11_receiveValue:3
 11_receiveCompletion:finished
 */

//MARK: - prefix
testSample(label: "12_prefix") {
    let numbers = (0...5).publisher
    numbers
        .prefix(2)
        .sink { completion in
            print("12_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("12_receiveValue:\(val)");
        }
        .store(in: &cancell)
}
/*
 结果:只取前2个元素 0 1
 12_receiveValue:0
 12_receiveValue:1
 12_receiveCompletion:finished
 */

testSample(label: "13_prefix(while)") {
    let numbers = (0...5).publisher
    numbers
        .prefix(while: { val in
            val < 3
        })
        .sink { completion in
            print("13_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("13_receiveValue:\(val)");
        }
        .store(in: &cancell)
}
/*
 结果:从第一个元素开始取到条件限制的值
 13_receiveValue:0
 13_receiveValue:1
 13_receiveValue:2
 13_receiveCompletion:finished
 */

testSample(label: "14_prefix(untilOutputFrom)") {
    let srcPublisher = PassthroughSubject<Int, Never>()
    let readPublisher = PassthroughSubject<Void, Never>() //发送事件时，结束接受数据
    
    srcPublisher
        .prefix(untilOutputFrom: readPublisher)
        .sink { completion in
            print("14_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("14_receiveValue:\(val)");
        }
        .store(in: &cancell)
    
    srcPublisher.send(1)
    srcPublisher.send(2)
    readPublisher.send()
    srcPublisher.send(3)
    srcPublisher.send(completion: .finished)
}
/*
 结果:
 14_receiveValue:1
 14_receiveValue:2
 14_receiveCompletion:finished
 */
