//: [Previous](@previous)

import Foundation
import Combine

var greeting = "Combine - Custom-Publisher"

func testSample(label : String, action : Bool, testBlock : () -> Void) {
    guard action else {
        return
    }
    print("-----------[\(label)]:start-----------");
    testBlock()
    print("-----------[\(label)]:end-------------\n");
}

var cancell = Set<AnyCancellable>()

//MARK: - Extension
extension Publisher {
    func ignoreOptionalValues<T>() -> Publishers.CompactMap<Self, T> where Output == Optional<T> {
        self.compactMap{ $0 }
    }
}

testSample(label: "01_extension", action: true) {
    let values = [1, nil, 3, 4, nil, 6]

    values
        .publisher
        .ignoreOptionalValues()
        .sink{
            print("ignoreOptionalValues receive value: \($0)")
        }
        .store(in: &cancell)
}
/*
 结果:
 ignoreOptionalValues receive value: 1
 ignoreOptionalValues receive value: 3
 ignoreOptionalValues receive value: 4
 ignoreOptionalValues receive value: 6
 */



//: [Next](@next)
