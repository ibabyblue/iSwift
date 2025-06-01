//: [Previous](@previous)

import Foundation
import Combine

var greeting = "Combine - Closures、Future"

func testSample(label : String, action : Bool, testBlock : () -> Void) {
    guard action else {
        return
    }
    print("-----------[\(label)]:start-----------");
    testBlock()
    print("-----------[\(label)]:end-------------\n");
}

//MARK: - Closure
let errorFlag = false

enum CError : Error {
    case wrong
}

class AsyncClass {
    func asyncMethod(completionHandler : @escaping (String) -> Void, errorHandler : @escaping (CError) -> Void) {
        print("async call start")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: DispatchWorkItem(block: {
            if (!errorFlag) {
                let processName = ProcessInfo.processInfo.processName
                completionHandler(processName)
            } else {
                errorHandler(.wrong)
            }
        }))
    }
}
testSample(label: "Async Method", action: false) {
    let asyncInstance = AsyncClass()
    asyncInstance.asyncMethod { pName in
        print("completionHandler:\(pName)")
    } errorHandler: { err in
        print("errorHandler:\(err)")
    }
}

//MARK: - Future
var cancell = Set<AnyCancellable>()

func createFutureTask() -> Future<String, CError> {
    Future<String, CError> { promise in
        sleep(2)
        if (!errorFlag) {
            let processName = ProcessInfo.processInfo.processName
            promise(.success(processName))
        } else {
            promise(.failure(.wrong))
        }
    }
}

testSample(label: "Future Method", action: true) {
    createFutureTask()
        .sink { completion in
            switch (completion) {
            case .finished:
                print("Future Finished")
            case .failure(let err):
                print("Future err:\(err)")
            }
        } receiveValue: { val in
            print("Future val:\(val)")
        }
        .store(in: &cancell)
}
/*
 结果:
 -----------[Future Method]:start-----------
 Future val:11-Closures、Future
 Future Finished
 -----------[Future Method]:end-------------
 */
//: [Next](@next)
