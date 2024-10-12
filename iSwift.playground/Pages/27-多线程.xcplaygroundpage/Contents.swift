//: [Previous](@previous)

import Foundation
import UIKit

var greeting = "Hello, playground"

//MARK: - 异步
//1.开启异步线程
func foo() {
    print("main thread:", Thread.current)
    
    DispatchQueue.global().async {
        print("subthread:", Thread.current)
        DispatchQueue.main.async {
            print("return main thread:")
            print(Thread.current)
        }
    }
}

foo()

//2.GCD任务-DispatchWorkItem
//DispatchWorkItem是定义任务的，任务完成后可以通过notify通知其他线程（一般是主线程）做其他任务
//示例代码：
//定义任务
public typealias Task = () -> Void

@available(iOS 8.0, *, *)
public struct Async {
    //异步线程1：传入子线程任务
    public static func async(_ task: @escaping Task) {
        _async(task)
    }
    
    //异步线程2：分别传入子线程和主线程的任务
    public static func async(_ task: @escaping Task, _ mainTask: @escaping Task) {
        _async(task, mainTask)
    }
    
    public static func _async(_ task: @escaping Task, _ mainTask: Task? = nil) {
        let item = DispatchWorkItem(block: task)
        //子线程执行任务
        DispatchQueue.global().async(execute: item)
        if let main = mainTask {
            //子线程执行完毕后通知主线程执行任务
            item.notify(queue: DispatchQueue.main, execute: main)
        }
    }
}

//MARK: - 延迟
//1.普通延迟
//在iOS中使用延迟一般使用dispatch_after，但是在Swift中没有这个API，使用的是DispatchQueue.*.asyncAfter
//示例代码：
@available(iOS 8.0, *, *)
extension Async {
    @discardableResult
    public static func delay(_ seconds: Double, _ block: @escaping Task) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: block)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds, execute: item)
        return item
    }
}

//2.异步延迟
//代码示例:定义
@available(iOS 8.0, *, *)
extension Async {
    @discardableResult
    public static func asyncDelay(_ seconds: Double, _ task: @escaping Task) -> DispatchWorkItem {
        return _asyncDelay(seconds, task)
    }

    @discardableResult
    public static func asyncDelay(_ seconds: Double, _ task: @escaping Task, _ mainTask: @escaping Task) -> DispatchWorkItem {
        return _asyncDelay(seconds, task, mainTask)
    }

    private static func _asyncDelay(_ seconds: Double, _ task: @escaping Task, _ mainTask: Task? = nil) -> DispatchWorkItem {
        let item = DispatchWorkItem(block: task)
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + seconds, execute: item)
        if let main = mainTask {
            item.notify(queue: DispatchQueue.main, execute: main)
        }
        return item
    }
}

//代码示例:使用
//class ViewController: UIViewController {
//    private var item: DispatchWorkItem?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//           
//        item = Async.asyncDelay(3) {
//            
//        };
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        item?.cancel()
//    }
//}

//MARK: - once
//!!!: dispatch_once在Swift中已被废弃，取而代之的是静态属性（底层还是调用了dispatch_once）
//示例代码：
class ViewController: UIViewController {
    static var onceTask: Void = {
        print("onceTask")
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let _ = Self.onceTask
        let _ = Self.onceTask
        let _ = Self.onceTask
    }
}
// 输出：print("onceTask")

//MARK: - 加锁
public struct Cache {
    private static var data = [String : Any]()
    private static var lock = DispatchSemaphore(value: 1)
    public static func set(_ key: String, _ value: Any) {
        //加锁
        lock.wait()
        defer {
            //解锁
            lock.signal()
        }
        data[key] = value
    }
}

//MARK: - queue
@available(iOS 8.0, *, *)
let item1 = DispatchWorkItem {
    for i in 0...5 {
        print("item1 -> \(i), thread -> \(Thread.current)")
    }
}

@available(iOS 8.0, *, *)
let item2 = DispatchWorkItem {
    for i in 0...5 {
        print("item2 -> \(i), thread -> \(Thread.current)")
    }
}

//自定义串行队列
let serialQueue = DispatchQueue(label: "Serial")
serialQueue.async(execute: item1)
serialQueue.async(execute: item2)

//自定义并行队列
let concurrentQueue = DispatchQueue(label: "concurrent", attributes: .concurrent)
concurrentQueue.async(execute: item1)
concurrentQueue.async(execute: item2)

//主队列
let mainQueue = DispatchQueue.main
mainQueue.async(execute: item1)

//全局队列
let globalQueue = DispatchQueue.global()
globalQueue.async(execute:item1)

//MARK: - DispatchGroup
//1.使用方法
let group = DispatchGroup()
let queue = DispatchQueue(label: "com.ibabyblue", attributes: .concurrent)

@available(iOS 8.0, *, *)
let gItem1 = DispatchWorkItem(block: {
    print("item1 -> \(Thread.current)")
})

queue.async(group: group, execute: gItem1)

@available(iOS 8.0, *, *)
let gItem2 = DispatchWorkItem(block: {
    print("item2 -> \(Thread.current)")
})
queue.async(group: group, execute:gItem2)

group.notify(queue: DispatchQueue.main) {
    print("item1 and item2 done -> \(Thread.current)")
}

//阻塞当前线程，直到上述group.notify方法被调用，释放当前线程，"wait 结束" 将在 "item1 and item2 done -> xxx" 之前打印
group.wait()
print("wait 结束")

//2.挂起、恢复
let gro = DispatchGroup()
let acQueue = DispatchQueue(label: "active")
let suQueue = DispatchQueue(label: "suspend")

//挂起
suQueue.suspend()

@available(iOS 8.0, *, *)
let acItem = DispatchWorkItem(block: {
    print("acQueue -> \(Thread.current)")
    
    sleep(10)
    
    //恢复
    suQueue.resume()
})
acQueue.async(group: gro, execute: acItem)

@available(iOS 8.0, *, *)
let suItem = DispatchWorkItem(block: {
    print("suQueue -> \(Thread.current)")
})

suQueue.async(group: gro, execute: suItem)

@available(iOS 8.0, *, *)
let notiItem = DispatchWorkItem(block: {
    print("acQueue and suQueue done -> \(Thread.current)")
})

gro.notify(queue: DispatchQueue.main, work: notiItem)

//MARK: - DispatchQoS
//DispatchQoS调度优先级：直译过来就是应用在任务上的服务质量或执行优先级，可以理解为任务的身份、等级。可以用来修饰DispatchWorkItem、DispatchQueue。
/*
 DispatchQoS类型：
    - userInteractive: 与用户交互相关的任务，要最重视，优先处理，保证界面最流畅
    - userInitiated: 用户主动发起的任务，要比较重视
    - default: 默认任务，正常处理即可
    - utility: 用户没有主动关注的任务
    - background: 不太重要的维护、清理等任务，空闲处理
    - unspecified: 无标识，能处理则处理，不能处理也无所谓
*/

@available(iOS 8.0, *, *)
let qosItem1 = DispatchWorkItem(qos: .userInteractive) {
    for i in 0...9999{
        print("item1 -> \(i)  thread: \(Thread.current)")
    }
}

@available(iOS 8.0, *, *)
let qosItem2 = DispatchWorkItem(qos: .unspecified) {
    for i in 0...9999{
        print("item2 -> \(i)  thread: \(Thread.current)")
    }
}

let qosQueue = DispatchQueue(label: "DispatchQoS", attributes: .concurrent)
qosQueue.async(execute: qosItem1)
qosQueue.async(execute: qosItem2)

//运行结果：item1执行完，item2才开始打印xxxx。for循环次数需要调大一些，否则效果不明显。
  
let userQosQueue = DispatchQueue(label: "DispatchQoS.userInteractive", qos: .userInteractive, attributes: .concurrent)
let unspecQosQueue = DispatchQueue(label: "DispatchQoS.unspecified", qos: .unspecified, attributes: .concurrent)

@available(iOS 8.0, *, *)
let unspecItem = DispatchWorkItem(block: {
    for i in 0...9999{
        print("item2 -> \(i)  thread: \(Thread.current)")
    }
})

unspecQosQueue.async(execute: unspecItem)

@available(iOS 8.0, *, *)
let userItem = DispatchWorkItem(block: {
    for i in 0...9999{
        print("item1 -> \(i)  thread: \(Thread.current)")
    }
})
userQosQueue.async(execute: userItem)

//运行结果：item1执行完，item2才开始打印xxxx。
print("111")

//: [Next](@next)
