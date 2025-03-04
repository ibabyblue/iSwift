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

//队列-主队列
let mainQueue = DispatchQueue.main
mainQueue.async(execute: item1)

//队列-全局队列
let globalQueue = DispatchQueue.global()
globalQueue.async(execute:item1)

//队列-自定义串行队列
let serialQueue = DispatchQueue(label: "Serial")
serialQueue.async(execute: item1)
serialQueue.async(execute: item2)

//队列-自定义并行队列
let concurrentQueue = DispatchQueue(label: "Concurrent", attributes: .concurrent)
concurrentQueue.async(execute: item1)
concurrentQueue.async(execute: item2)

//队列-非自动执行任务队列（默认：串行队列）
let inactiveQueue = DispatchQueue(label: "inactive", qos: .default, attributes: .initiallyInactive ,autoreleaseFrequency: .inherit, target: nil)
inactiveQueue.async {
    print("thread -> \(Thread.current)")
}
//开始执行任务
inactiveQueue.activate()

//队列-自动释放参数
/*
 .inherit:
    - 这个选项是默认值，表示当前队列将继承调用者队列的 AutoreleaseFrequency 行为。
    - 如果上一级队列中已经有自动释放池的策略，它会继续沿用这个策略。
    - 如果没有特别配置，系统默认的 GCD 队列通常采用 workItem 策略。
 .workItem:
    - 每次执行一个任务时，系统会创建并自动销毁一个自动释放池。这个选项确保每个任务结束后，自动释放池会被清空，释放自动释放的对象。
    - 这是处理大部分异步任务时的默认和推荐选择，因为它确保每个任务执行后及时释放不再使用的对象，避免内存累积。
 .never:
    - 当选择此选项时，GCD 不会自动创建或清理自动释放池。开发者需要手动管理内存中的自动释放对象（通常在某些高性能需求场景下）。
    - 这意味着在没有显式的 @autoreleasepool 包围的情况下，任何 autorelease 对象将不会被释放，直到你明确调用自动释放池，或者程序结束。
 */
let autoreleaseQueue = DispatchQueue(label: "autoreleaseFrequency", autoreleaseFrequency: .workItem)
autoreleaseQueue.async {
    print("thread -> \(Thread.current)")
}

//MARK: - DispatchGroup
//1.1 使用方法1
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

////1.2 使用方法2
//let workQueue = DispatchQueue.global()
//let workGroup = DispatchGroup()
//    
//workGroup.enter()
//workQueue.async {
//    Thread.sleep(forTimeInterval: 1)
//    print("A action")
//    workGroup.leave()
//}
//    
//workGroup.enter()
//workQueue.async {
//    Thread.sleep(forTimeInterval: 2)
//    print("B action")
//    workGroup.leave()
//}
//    
//workGroup.notify(queue: workQueue) {
//    print("A and B done!")
//}

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
 DispatchQoS类型（优先级从高到低依次如下）：
    - userInteractive: 最高优先级，表示任务需要立即执行来更新用户界面，通常是用户期望的即时反馈操作。例如，处理触摸事件、屏幕刷新或动画。
    - userInitiated: 由用户发起并期望立即结果的任务。通常用于需要快速完成，但不直接影响 UI 响应的任务。
    - default: 系统默认的优先级，没有明确分配特定优先级的任务将使用此QoS。
    - utility: 用于长时间运行的任务，用户不需要立即结果。通常这些任务会消耗系统资源，耗时较长，系统会尽量减少它们的执行对性能的影响。
    - background: 适用于用户无感知的任务，比如数据同步、备份、缓存清理等。
    - unspecified: 未指定的QoS，表示无明确的优先级要求。
 
 print("userInteractive:\(DispatchQoS.userInteractive.qosClass.rawValue)\n",
       "userInitiated:\(DispatchQoS.userInitiated.qosClass.rawValue)\n",
       "default:\(DispatchQoS.default.qosClass.rawValue)\n",
       "utitly:\(DispatchQoS.utility.qosClass.rawValue)\n",
       "background:\(DispatchQoS.background.qosClass.rawValue)\n",
       "unspecified:\(DispatchQoS.unspecified.qosClass.rawValue)\n")

 /*
  打印结果：
  userInteractive:qos_class_t(rawValue: 33)
  userInitiated:qos_class_t(rawValue: 25)
  default:qos_class_t(rawValue: 21)
  utitly:qos_class_t(rawValue: 17)
  background:qos_class_t(rawValue: 9)
  unspecified:qos_class_t(rawValue: 0)
  */
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

qosQueue.async(execute: qosItem2)
qosQueue.async(execute: qosItem1)

//运行结果：并行队列 qosItem1 的执行优先级高于 qosItem2，qosItem1将占用较多资源先行打印完成，qosItem2占用较少资源后续打印完成
  
let userQosQueue = DispatchQueue(label: "DispatchQoS.userInteractive", qos: .userInteractive, attributes: .concurrent)
let unspecQosQueue = DispatchQueue(label: "DispatchQoS.unspecified", qos: .unspecified, attributes: .concurrent)

@available(iOS 8.0, *, *)
let unspecItem = DispatchWorkItem(block: {
    for i in 0...9999{
        print("item2 -> \(i)  thread: \(Thread.current)")
    }
})

@available(iOS 8.0, *, *)
let userItem = DispatchWorkItem(block: {
    for i in 0...9999{
        print("item1 -> \(i)  thread: \(Thread.current)")
    }
})

userQosQueue.async(execute: userItem)
unspecQosQueue.async(execute: unspecItem)

//运行结果：不同优先级队列 userQosQueue 的执行优先级高于 unspecQosQueue，userQosQueue将占用较多资源执行任务，unspecQosQueue占用较少资源执行任务

//MARK: - target
let parentQueue = DispatchQueue(label: "com.example.parentQueue")
let childQueue1 = DispatchQueue(label: "com.example.childQueue1", attributes: .concurrent, target: parentQueue)
let childQueue2 = DispatchQueue(label: "com.example.childQueue2", attributes: .concurrent, target: parentQueue)

childQueue1.async {
    print("Task from childQueue1")
}

childQueue2.async {
    print("Task from childQueue2")
    sleep(3)
}

parentQueue.async {
    print("Task from parentQueue")
}
/*
 1、parentQueue为串行队列
 结果:
 Task from childQueue1
 Task from childQueue2
 Task from parentQueue（三秒后打印）
 
 2、parentQueue为并行队列
 结果：
 打印顺序不定
 
 总结：childQueue提交的任务最终均会被提交至parentQueue并按parentQueue的规则执行任务。
 */


//MARK: - DispatchSource
var seconds = 5
let timer: DispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
timer.schedule(deadline: .now(), repeating: 1)
timer.setEventHandler(handler: DispatchWorkItem(block: {
    seconds -= 1
    if seconds < 0 {
        timer.cancel()
    } else {
        print(seconds)
    }
}))
timer.resume()
timer.setCancelHandler(handler: DispatchWorkItem(block: {
    //调用timer.cancel()之后，会调用此CancelHandler
    print("---cleaning up resources");
}))

//: [Next](@next)
