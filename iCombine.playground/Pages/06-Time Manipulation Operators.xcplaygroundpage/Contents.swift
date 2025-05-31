//: [Previous](@previous)

import Foundation
import Combine

var greeting = "Combine - Time Manipulation Operators"

func testSample(label : String, action: Bool, testBlock : () -> Void) {
    guard action else {
        return
    }
    print("-----------[\(label)]:start-----------");
    testBlock()
    print("-----------[\(label)]:end-------------\n");
}

var cancell = Set<AnyCancellable>()

//MARK: - delay（延迟发布数据）
/*
 ---1-2-3-4-5-6---  srcPublisher
 -----1-2-3-4-5-6-  delayPublisher,延迟1s
 */
testSample(label: "01_delay", action: false) {
    let srcPublisher = PassthroughSubject<Date, Never>()

    srcPublisher
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .sink { completion in
            print("01_delay_receiveCompletion:\(completion)");
        } receiveValue: { date in
            print("01_delay_receiveValue:\(date.timeIntervalSinceReferenceDate.description)");
        }
        .store(in: &cancell)
        
    srcPublisher
        .sink { completion in
            print("01_receiveCompletion:\(completion)");
        } receiveValue: { date in
            print("01_receiveValue:\(date.timeIntervalSinceReferenceDate.description)");
        }
        .store(in: &cancell)
    
    Timer.publish(every: 1.0, on: .main, in: .common)
        .autoconnect()
        .subscribe(srcPublisher)
        .store(in: &cancell)
}
/*
 结果:
 01_receiveValue:770305361.117609
 01_receiveValue:770305362.11768
 01_delay_receiveValue:770305361.117609
 01_receiveValue:770305363.117613
 01_delay_receiveValue:770305362.11768
 */

//MARK: - collect（定时收集数据）
testSample(label: "01_collect", action: false) {
    let srcPublisher = PassthroughSubject<Date, Never>()

    srcPublisher
        .collect(.byTime(DispatchQueue.main, .seconds(4)))
        .sink { completion in
            print("01_collect_receiveCompletion:\(completion)");
        } receiveValue: { dates in
            print("01_collect_receiveValue:\(dates)");
        }
        .store(in: &cancell)
        
    srcPublisher
        .sink { completion in
            print("01_receiveCompletion:\(completion)");
        } receiveValue: { date in
            print("01_receiveValue:\(date)");
        }
        .store(in: &cancell)
    
    Timer.publish(every: 1.0, on: .main, in: .common)
        .autoconnect()
        .subscribe(srcPublisher)
        .store(in: &cancell)
}
/*
 结果:第一秒没有发送数据
 01_receiveValue:2025-05-30 13:59:32 +0000
 01_receiveValue:2025-05-30 13:59:33 +0000
 01_receiveValue:2025-05-30 13:59:34 +0000
 01_collect_receiveValue:[2025-05-30 13:59:32 +0000, 2025-05-30 13:59:33 +0000, 2025-05-30 13:59:34 +0000]
 01_receiveValue:2025-05-30 13:59:35 +0000
 01_receiveValue:2025-05-30 13:59:36 +0000
 01_receiveValue:2025-05-30 13:59:37 +0000
 01_receiveValue:2025-05-30 13:59:38 +0000
 01_collect_receiveValue:[2025-05-30 13:59:35 +0000, 2025-05-30 13:59:36 +0000, 2025-05-30 13:59:37 +0000, 2025-05-30 13:59:38 +0000]
 */

//srcPublisher 一秒一次，但是每隔4秒 collect 连续走4次，此时collectPublisher是连续发送4次
testSample(label: "02_collect", action: false) {
    let srcPublisher = PassthroughSubject<Date, Never>()

    srcPublisher
        .collect(.byTime(DispatchQueue.main, .seconds(4)))
        .flatMap({ dates in
            dates.publisher
        })
        .sink { completion in
            print("02_collect_receiveCompletion:\(completion)");
        } receiveValue: { dates in
            print("02_collect_receiveValue:\(dates)");
        }
        .store(in: &cancell)
        
    srcPublisher
        .sink { completion in
            print("02_receiveCompletion:\(completion)");
        } receiveValue: { date in
            print("02_receiveValue:\(date)");
        }
        .store(in: &cancell)
    
    Timer.publish(every: 1.0, on: .main, in: .common)
        .autoconnect()
        .subscribe(srcPublisher)
        .store(in: &cancell)
}
/*
 结果:
 02_receiveValue:2025-05-30 14:02:07 +0000
 02_receiveValue:2025-05-30 14:02:08 +0000
 02_receiveValue:2025-05-30 14:02:09 +0000
 02_collect_receiveValue:2025-05-30 14:02:07 +0000
 02_collect_receiveValue:2025-05-30 14:02:08 +0000
 02_collect_receiveValue:2025-05-30 14:02:09 +0000
 02_receiveValue:2025-05-30 14:02:10 +0000
 02_receiveValue:2025-05-30 14:02:11 +0000
 02_receiveValue:2025-05-30 14:02:12 +0000
 02_receiveValue:2025-05-30 14:02:13 +0000
 02_collect_receiveValue:2025-05-30 14:02:10 +0000
 02_collect_receiveValue:2025-05-30 14:02:11 +0000
 02_collect_receiveValue:2025-05-30 14:02:12 +0000
 02_collect_receiveValue:2025-05-30 14:02:13 +0000
 */

//srcPublisher一秒一次，但每隔4秒发送一次，或者事件满足2件发送一次
testSample(label: "03_collect", action: false) {
    let srcPublisher = PassthroughSubject<Date, Never>()

    srcPublisher
        .collect(.byTimeOrCount(DispatchQueue.main, .seconds(4), 2))
        .flatMap({ dates in
            dates.publisher
        })
        .sink { completion in
            print("03_collect_receiveCompletion:\(completion)");
        } receiveValue: { dates in
            print("03_collect_receiveValue:\(dates)");
        }
        .store(in: &cancell)
        
    srcPublisher
        .sink { completion in
            print("03_receiveCompletion:\(completion)");
        } receiveValue: { date in
            print("03_receiveValue:\(date)");
        }
        .store(in: &cancell)
    
    Timer.publish(every: 1.0, on: .main, in: .common)
        .autoconnect()
        .subscribe(srcPublisher)
        .store(in: &cancell)
}

/*
 结果:
 03_receiveValue:2025-05-30 14:09:01 +0000
 03_receiveValue:2025-05-30 14:09:02 +0000
 03_collect_receiveValue:2025-05-30 14:09:01 +0000
 03_collect_receiveValue:2025-05-30 14:09:02 +0000
 03_receiveValue:2025-05-30 14:09:03 +0000
 03_collect_receiveValue:2025-05-30 14:09:03 +0000
 03_receiveValue:2025-05-30 14:09:04 +0000
 03_receiveValue:2025-05-30 14:09:05 +0000
 03_collect_receiveValue:2025-05-30 14:09:04 +0000
 03_collect_receiveValue:2025-05-30 14:09:05 +0000
 03_receiveValue:2025-05-30 14:09:06 +0000
 03_receiveValue:2025-05-30 14:09:07 +0000
 03_collect_receiveValue:2025-05-30 14:09:06 +0000
 03_collect_receiveValue:2025-05-30 14:09:07 +0000
 */

//MARK: - debounce（防抖）
extension PassthroughSubject {
    func feed(with input : [(Double, Output)]) {
        let now = DispatchTime.now()
        for e in input {
            let when = DispatchTimeInterval.milliseconds(Int(e.0 * 1000))
            DispatchQueue.global().asyncAfter(deadline:DispatchTime.now() + when, execute: DispatchWorkItem(block: {
                self.send(e.1)
            }))
        }
    }
}

//share()保证数据共享，有多个订阅者，数据一致，不会请求多次
testSample(label: "01_debounce", action: false) {
    let subject = PassthroughSubject<String, Never>()

    let debounce = subject
                    .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
                    .share()
    
    subject
        .sink { completion in
            print("01_subject_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("01_subject_receiveValue:\(val)");
        }
        .store(in: &cancell)
    
    debounce
        .sink { completion in
            print("01_debounce_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("01_debounce_receiveValue:\(val)");
        }
        .store(in: &cancell)
    
    let input = [
        (0.0, "w"),
        (0.1, "wh"),
        (0.2, "wha"),
        (0.3, "what"),
        (2.0, "what'"),
        (2.1, "what's"),
        (2.8, "what's "),
        (3.0, "what's u"),
        (3.5, "what's up"),
    ]
    subject.feed(with: input)
}
/*
 03_subject_receiveValue:wh
 03_subject_receiveValue:wha
 03_subject_receiveValue:what
 03_debounce_receiveValue:what
 03_subject_receiveValue:what'
 03_subject_receiveValue:what's
 03_subject_receiveValue:what's
 03_subject_receiveValue:what's u
 03_subject_receiveValue:what's up
 03_debounce_receiveValue:what's up
 */

testSample(label: "02_share", action: false) {
    let pub = (1...3).publisher
        .delay(for: .seconds(1), scheduler: DispatchQueue.main)
        .map({_ in Int.random(in: 0...100)})
        .share() //数据一致的关键
    pub.sink {
        print("02_random1_receiveValue:\($0)");
    }.store(in: &cancell)
    
    pub.sink {
        print("01_random2_receiveValue:\($0)");
    }.store(in: &cancell)
}
/*
 结果:share() -> 两者数据一致
 02_random1_receiveValue:69
 01_random2_receiveValue:69
 02_random1_receiveValue:95
 01_random2_receiveValue:95
 02_random1_receiveValue:57
 01_random2_receiveValue:57
 
 结果:无share() -> 两者数据不一致
 02_random1_receiveValue:77
 02_random1_receiveValue:32
 02_random1_receiveValue:40
 01_random2_receiveValue:28
 01_random2_receiveValue:21
 01_random2_receiveValue:49
 */

//MARK: - throttle(节流阀)
testSample(label: "01_throttle", action: false) {
    let subject = PassthroughSubject<String, Never>()

    //throttle是在一秒之后，发送的数据是subject的指定时间内的（一秒内）的第一个（latest: false），或者最后一个（latest: true）
    let throttle = subject
        .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        .share()
    
    subject
        .sink { completion in
            print("01_subject_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("01_subject_receiveValue:\(val)");
        }
        .store(in: &cancell)
    
    throttle
        .sink { completion in
            print("01_throttle_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("01_throttle_receiveValue:\(val)");
        }
        .store(in: &cancell)
    
    let input = [
        (0.0, "w"),
        (0.1, "wh"),
        (0.2, "wha"),
        (0.3, "what"),
        (2.0, "what'"),
        (2.1, "what's"),
        (2.8, "what's "),
        (3.0, "what's u"),
        (3.5, "what's up"),
    ]
    subject.feed(with: input)
}
/*
 结果:代码中latest为false，取的第一个元素，true取最后一个元素
 01_throttle_receiveValue:w
 01_subject_receiveValue:wh
 01_subject_receiveValue:wha
 01_subject_receiveValue:what
 01_throttle_receiveValue:wh
 01_subject_receiveValue:what'
 01_throttle_receiveValue:what'
 01_subject_receiveValue:what's
 01_subject_receiveValue:what's
 01_subject_receiveValue:what's u
 01_throttle_receiveValue:what's
 01_subject_receiveValue:what's up
 01_throttle_receiveValue:what's up
 */

//MARK: - timeout(超时)
enum TimeoutError : Error {
    case timeout
}
testSample(label: "01_timeout", action: false) {
    let subject = PassthroughSubject<Void, TimeoutError>()

    let timeout = subject
        .timeout(.seconds(2), scheduler: DispatchQueue.global(), customError: {.timeout})
    
    subject
        .sink { completion in
            print("01_subject_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("01_subject_receiveValue:\(val)");
        }
        .store(in: &cancell)
    
    timeout
        .sink { completion in
            print("01_timeout_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("01_timeout_receiveValue:\(val)");
        }
        .store(in: &cancell)
    
    Thread.sleep(forTimeInterval: 5)
    subject.send()
    subject.send(completion: .finished)
}
/*
 结果:
 01_timeout_receiveCompletion:failure(__lldb_expr_87.TimeoutError.timeout)
 01_subject_receiveValue:()
 01_subject_receiveCompletion:finished
 */

//MARK: - measureInterval(统计发送数据间隔时间)
testSample(label: "01_measureInterval", action: true) {
    let subject = PassthroughSubject<String, TimeoutError>()

    let measure = subject
        .measureInterval(using: DispatchQueue.main)
    
    subject
        .sink { completion in
            print("01_subject_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("01_subject_receiveValue:\(val)");
        }
        .store(in: &cancell)
    
    measure
        .sink { completion in
            print("01_measure_receiveCompletion:\(completion)");
        } receiveValue: { val in
            print("01_measure_receiveValue:\(val)");
        }
        .store(in: &cancell)
    
    subject.send("1")
    Thread.sleep(forTimeInterval: 0.2)
    subject.send("12")
    Thread.sleep(forTimeInterval: 0.3)
    subject.send("123")
    Thread.sleep(forTimeInterval: 0.4)
    subject.send("1234")
    subject.send(completion: .finished)
}
/*
 结果:
 01_measure_receiveValue:Stride(_nanoseconds: 1740378)
 01_subject_receiveValue:1
 01_measure_receiveValue:Stride(_nanoseconds: 219585670)
 01_subject_receiveValue:12
 01_measure_receiveValue:Stride(_nanoseconds: 303621406)
 01_subject_receiveValue:123
 01_measure_receiveValue:Stride(_nanoseconds: 402950804)
 01_subject_receiveValue:1234
 01_measure_receiveCompletion:finished
 01_subject_receiveCompletion:finished
 */
//: [Next](@next)
