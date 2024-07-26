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


//: [Next](@next)
