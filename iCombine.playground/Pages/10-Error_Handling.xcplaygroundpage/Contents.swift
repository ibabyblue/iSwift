//: [Previous](@previous)

import Foundation
import Combine

var greeting = "Combine - Error Handling"

func testSample(label : String, action : Bool, testBlock : () -> Void) {
    guard action else {
        return
    }
    print("-----------[\(label)]:start-----------");
    testBlock()
    print("-----------[\(label)]:end-------------\n");
}

var cancell = Set<AnyCancellable>()

//MARK: - SetFailureType
testSample(label: "01_SetFailureType", action: false) {
    enum CError : Error {
        case wrongValue
    }
    let srcPublisher = PassthroughSubject<Int, Never>()
    let errPublisher = srcPublisher
                        .setFailureType(to: CError.self) //将错误类型转为PassthroughSubject<Int, CError>
                        .eraseToAnyPublisher()
    errPublisher
        .sink { completion in
            print("01_completion:\(completion)")
        } receiveValue: { val in
            print("01_receiveValue:\(val)")
        }
        .store(in: &cancell)
    
    srcPublisher.send(1)
    srcPublisher.send(2)
}

testSample(label: "02_SetFailureType", action: true) {
    let arrPublisher = [1, 2, 3, 4].publisher
    let srcPublisher = CurrentValueSubject<Int, Error>(0)
    
    arrPublisher
        .setFailureType(to: Error.self) //统一错误类型后，才可以使用combineLatest
        .combineLatest(srcPublisher)
        .sink { completion in
            print("02_completion:\(completion)")
        } receiveValue: { val in
            print("02_receiveValue:\(val)")
        }
        .store(in: &cancell)
}
/*
 结果:
 02_receiveValue:(4, 0)
 */

//MARK: - AssertNoFailure
testSample(label: "01_AssertNoFailure", action: false) {
    enum CError : Error {
        case wrongValue
    }
    let srcPublisher = PassthroughSubject<Int, CError>()
    let errPublisher = srcPublisher
                        .assertNoFailure()
                        .eraseToAnyPublisher()
    errPublisher
        .sink { completion in
            print("01_completion:\(completion)")
        } receiveValue: { val in
            print("01_receiveValue:\(val)")
        }
        .store(in: &cancell)
    
    srcPublisher.send(1)
    srcPublisher.send(2)
    srcPublisher.send(completion: .failure(.wrongValue))
}
//error: Execution was interrupted, reason: EXC_BAD_INSTRUCTION (code=EXC_I386_INVOP, subcode=0x0).

//MARK: - TryMap
testSample(label: "01_TryMap", action: false) {
    enum CError : Error {
        case wrongValue
        case endValue
    }
    let srcPublisher = PassthroughSubject<Int, CError>()
    srcPublisher
        .tryMap({ val in //tryMap 中的try表示有可能有错误
            if (val == 2) {
                throw CError.wrongValue
            }
            return val
        })
        .sink { completion in
            print("01_completion:\(completion)")
        } receiveValue: { val in
            print("01_receiveValue:\(val)")
        }
        .store(in: &cancell)
    
    srcPublisher.send(1)
    srcPublisher.send(2)
    srcPublisher.send(completion: .failure(.endValue))
}
/*
 结果:
 01_receiveValue:1
 01_completion:failure(__lldb_expr_51.(unknown context at $107d00b8c).(unknown context at $107d00bec).(unknown context at $107d00bf4).CError.wrongValue)
 */

//MARK: - MapError
testSample(label: "01_MapError", action: false) {
    enum CError : Error {
        case wrongValue
        case endValue
        case defaultError1
        case defaultError2
        case defaultError
    }
    enum DError : Error {
        case wrongValue
        case endValue
        case defaultError1
        case defaultError2
        case defaultError
    }
    let srcPublisher = PassthroughSubject<Int, CError>()
    srcPublisher
        .print("debuginfo")
        .tryMap({ val in //tryMap 中的try表示有可能有错误
            if (val == 2) {
                throw CError.wrongValue
            }
            return val
        })
        .mapError({ err -> DError in //mapError:转换错误类型
            switch (err) {
                case CError.wrongValue : return DError.defaultError1
                case CError.endValue : return DError.defaultError2
                default:
                    DError.defaultError
            }
            return DError.defaultError
        })
        .sink { completion in
            print("01_completion:\(completion)")
        } receiveValue: { val in
            print("01_receiveValue:\(val)")
        }
        .store(in: &cancell)
    
    srcPublisher.send(1)
    srcPublisher.send(2)
    srcPublisher.send(completion: .failure(.endValue))
}
/*
 结果:
 01_receiveValue:1
 01_completion:failure(__lldb_expr_55.(unknown context at $10470500c).(unknown context at $104705098).(unknown context at $1047050c4).DError.defaultError1)
 */

//MARK: - ReplaceError
testSample(label: "01_ReplaceError", action: false) {
    enum CError : Error {
        case wrongValue
        case endValue
        case defaultError1
        case defaultError2
        case defaultError
    }
    enum DError : Error {
        case wrongValue
        case endValue
        case defaultError1
        case defaultError2
        case defaultError
    }
    let srcPublisher = PassthroughSubject<Int, CError>()
    srcPublisher
//        .print("debuginfo")
        .tryMap({ val in //tryMap 中的try表示有可能有错误
            if (val == 2) {
                throw CError.wrongValue
            }
            return val
        })
        .mapError({ err -> DError in //mapError:转换错误类型
            switch (err) {
                case CError.wrongValue : return DError.defaultError1
                case CError.endValue : return DError.defaultError2
                default:
                    DError.defaultError
            }
            return DError.defaultError
        })
        .replaceError(with: 7)
        .sink { completion in
            print("01_completion:\(completion)")
        } receiveValue: { val in
            print("01_receiveValue:\(val)")
        }
        .store(in: &cancell)
    
    srcPublisher.send(1)
    srcPublisher.send(2)
    srcPublisher.send(completion: .failure(.endValue))
}
/*
 结果:
 01_receiveValue:1
 01_receiveValue:7
 01_completion:finished
 */

//MARK: - ReTry
testSample(label: "01_ReTry", action: true) {
    enum CError : Error {
        case wrongValue
        case endValue
    }
    let srcPublisher = PassthroughSubject<Int, CError>()
    srcPublisher
        .print("debuginfo")
        .tryMap({ val in //tryMap 中的try表示有可能有错误
            if (val == 2) {
                throw CError.wrongValue
            }
            return val
        })
        .retry(2) //log中可以看出打印两次receive subscription: (PassthroughSubject)，表示订阅了两次，错误也忽略了。当上游publisher产生数据有动态性，可以使用retry去获取不产生error的数据，忽略有error的情况
        .sink { completion in
            print("01_completion:\(completion)")
        } receiveValue: { val in
            print("01_receiveValue:\(val)")
        }
        .store(in: &cancell)
    
    srcPublisher.send(1)
    srcPublisher.send(2)
//    srcPublisher.send(completion: .failure(.endValue))
}

//: [Next](@next)
