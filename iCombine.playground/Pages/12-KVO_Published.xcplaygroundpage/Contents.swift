//: [Previous](@previous)

import Foundation
import Combine

var greeting = "Combine - KVO、Published"

func testSample(label : String, action : Bool, testBlock : () -> Void) {
    guard action else {
        return
    }
    print("-----------[\(label)]:start-----------");
    testBlock()
    print("-----------[\(label)]:end-------------\n");
}

var cancell = Set<AnyCancellable>()

//MARK: - OperationCount
testSample(label: "01_OperationCount", action: false) {
    let queue = OperationQueue()
    let queuePublisher = queue.publisher(for: \.operationCount)
    queuePublisher
        .sink { completion in
            print("01_completion:\(completion)")
        } receiveValue: { val in
            print("01_receiveValue:\(val)")
        }
        .store(in: &cancell)
    
    //addOperation -> operationCount + 1, 这个闭包执行完 -> operationCount - 1
    queue.addOperation({
        print("hi")
    })
    
    queue.addOperation({
        print("hello")
    })
}

//MARK: - OC对象
class OCObject : NSObject {
    @objc dynamic var val : Int = 0
    @objc dynamic var arr : [Int] = []
}

testSample(label: "02_OC对象", action: true) {
    let obj = OCObject()
    let ocPublisher = obj.publisher(for: \.val) //监听 OCObject 的 val 变化
    
    ocPublisher
        .sink { completion in
            print("02_val_completion:\(completion)")
        } receiveValue: { val in
            print("02_val_receiveValue:\(val)")
        }
        .store(in: &cancell)
    
    obj.val = 1
    obj.val = 2
    
    let arrPublisher = obj.publisher(for: \.arr) //监听 OCObject 的 arr 变化
    arrPublisher
        .sink { completion in
            print("02_arr_completion:\(completion)")
        } receiveValue: { val in
            print("02_arr_receiveValue:\(val)")
        }
        .store(in: &cancell)
    
    obj.arr = [1,2]
    obj.arr = [3,4]
}
/*
 结果:
 02_val_receiveValue:0
 02_val_receiveValue:1
 02_val_receiveValue:2
 02_arr_receiveValue:[]
 02_arr_receiveValue:[1, 2]
 02_arr_receiveValue:[3, 4]
 */

testSample(label: "03_OC对象", action: true) {
    let obj = OCObject()
    let ocPublisher = obj.publisher(for: \.val, options:[.initial]) //监听 OCObject 的 val 变化, .initial输出初始值
    
    ocPublisher
        .sink { completion in
            print("03_val_completion:\(completion)")
        } receiveValue: { val in
            print("03_val_receiveValue:\(val)")
        }
        .store(in: &cancell)
    
    obj.val = 1
    obj.val = 2
    
    let arrPublisher = obj.publisher(for: \.arr, options:[[.initial, .prior]]) //监听 OCObject 的 arr 变化，.initial输出初始值，.prior输出变化前和变化后的值
    arrPublisher
        .sink { completion in
            print("03_arr_completion:\(completion)")
        } receiveValue: { val in
            print("03_arr_receiveValue:\(val)")
        }
        .store(in: &cancell)
    
    obj.arr = [1,2]
    obj.arr = [3,4]
}
/*
 结果:
 03_val_receiveValue:0
 03_val_receiveValue:1
 03_val_receiveValue:2
 03_arr_receiveValue:[]
 03_arr_receiveValue:[]
 03_arr_receiveValue:[1, 2]
 03_arr_receiveValue:[1, 2]
 03_arr_receiveValue:[3, 4]
 */

//MARK: - 属性赋值
class Student {
    var name : String = ""
    var age : Int = 0
}

testSample(label: "04_Assign", action: true) {
    let stu = Student()
    
    Just(18)
        .assign(to: \.age, on: stu)
    print("\(stu.age)");
}
   
//MARK: - ObservableObject
class OO : ObservableObject {
    @Published var id : Int = 0
}

testSample(label: "05_ObservableObject", action: true) {
    let o = OO()
    Just(100)
        .assign(to: &o.$id) //这里使用 $id 取到的值是Publisher，.id 取到的值是Int类型
    print(o.id);
}

testSample(label: "06_ObservableObject", action: true) {
    let o = OO()
    o.$id.sink(){
        print("06_ObservableObject:\($0)");
    }
    o.objectWillChange.sink(receiveValue: {
        print("06_ObservableObject will change");
    })
    
    o.id = 1
    o.id = 2
}
/*
 06_ObservableObject:0
 06_ObservableObject will change
 06_ObservableObject:1
 06_ObservableObject will change
 06_ObservableObject:2
 */

//: [Next](@next)
