//: [Previous](@previous)

import Foundation
import Combine

var greeting = "Combine - Debug"

func testSample(label : String, testBlock : () -> Void) {
    print("-----------[\(label)]:start-----------");
    testBlock()
    print("-----------[\(label)]:end-------------\n");
}

var cancell = Set<AnyCancellable>()

testSample(label: "01_Debug") {
    let arrPublisher = [1, 2, 3, 5].publisher
    arrPublisher
        .print("debuginfo")
        .sink { completion in
            print("01_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("01_receiveValue:\(value)");
        }
        .store(in: &cancell)
}
/*
 结果:
 debuginfo: receive subscription: ([1, 2, 3, 5])
 debuginfo: request unlimited
 debuginfo: receive value: (1)
 01_receiveValue:1
 debuginfo: receive value: (2)
 01_receiveValue:2
 debuginfo: receive value: (3)
 01_receiveValue:3
 debuginfo: receive value: (5)
 01_receiveValue:5
 debuginfo: receive finished
 01_receiveCompletion:finished
 */

class TimerLogger : TextOutputStream {
    private var previous = Date()
    private let formatter = NumberFormatter()
    
    init() {
        self.formatter.maximumFractionDigits = 5
        self.formatter.minimumFractionDigits = 5
    }
    
    func write(_ string : String) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return
        }
        
        let now = Date()
        print("+ \(formatter.string(for: now.timeIntervalSince(previous))!)\(string)")
        previous = now
    }
}

testSample(label: "02_Debug") {
    let arrPublisher = [1, 2, 3].publisher
    arrPublisher
        .print("debuginfo", to: TimerLogger())
        .sink { completion in
            print("02_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("02_receiveValue:\(value)");
        }
        .store(in: &cancell)
}

//: [Next](@next)
