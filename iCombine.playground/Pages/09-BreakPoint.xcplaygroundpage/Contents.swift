//: [Previous](@previous)

import Foundation
import Combine

var greeting = "Combine - BreakPoint"

func testSample(label : String, action : Bool, testBlock : () -> Void) {
    guard action else {
        return
    }
    print("-----------[\(label)]:start-----------");
    testBlock()
    print("-----------[\(label)]:end-------------\n");
}

var cancell = Set<AnyCancellable>()

testSample(label: "01_BreakPoint", action: false) {
    enum bError : Error {
        case notfound
    }
    
    let srcPublisher = PassthroughSubject<Int, bError>()
    srcPublisher
        .breakpointOnError()
        .sink { completion in
            print("01_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("01_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send(1)
    srcPublisher.send(2)
    srcPublisher.send(completion: .failure(.notfound))
}
//error: Execution was interrupted, reason: signal SIGTRAP.

testSample(label: "02_BreakPoint", action: true) {
    enum CError : Error {
        case notfound
    }
    
    let srcPublisher = PassthroughSubject<Int, CError>()
    srcPublisher
        .breakpoint(receiveOutput: { output in
            if (output == 1) {
                return true
            } else {
                return false
            }
        })
        .sink { completion in
            print("02_receiveCompletion:\(completion)");
        } receiveValue: { value in
            print("02_receiveValue:\(value)");
        }
        .store(in: &cancell)
    
    srcPublisher.send(1)
    srcPublisher.send(2)
    srcPublisher.send(completion: .failure(.notfound))
}
//error: Execution was interrupted, reason: signal SIGTRAP.
//: [Next](@next)
