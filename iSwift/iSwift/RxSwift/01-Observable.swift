//
//  01-Observable.swift
//  iSwift
//
//  Created by ibabyblue on 2025/5/24.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: - Observable可被监听的序列
/*
 Observable 可以用于描述元素异步产生的序列

 Observable 这个类就是 Rx 框架的基础，可以称它为可观察序列。它的作用就是可以异步地产生一系列的 Event（事件），即一个 Observable 对象会随着时间推移不定期地发出 event(element : T) 这样一个东西。
 而且这些 Event 还可以携带数据，它的泛型 就是用来指定这个 Event 携带的数据的类型
 有了可观察序列，还需要有一个 Observer（订阅者）来订阅它，这样这个订阅者才能收到 Observable 不时发出的 Event。
 */

//MARK: - Event事件
public enum Event<Element> {
    case next(Element)
    case error(Swift.Error)
    case completed
}
/*
 next - 序列产生了一个新的元素
 error - 创建序列时产生了一个错误，导致序列终止
 completed - 序列的所有元素都已经成功产生，整个序列已经完成
 */

//MARK: - DisposeBag清除包
/*
 因为我们用的是 Swift ，所以我们更习惯于使用 ARC 来管理内存。那么我们能不能用 ARC 来管理订阅的生命周期了。答案是肯定了，你可以用 清除包（DisposeBag） 来实现这种订阅管理机制。当 清除包 被释放的时候，清除包 内部所有 可被清除的资源（Disposable） 都将被清除

 如何创建序列
 创建序列最直接的方法就是调用 Observable.create，然后在构建函数里面描述元素的产生过程

 create方法
 该方法接受一个 block 形式的参数，任务是对每一个过来的订阅进行处理。

 代码:
 */

func disposeMethod() {
    let disposeBag = DisposeBag()
    let observable = Observable<Any>.create { (observer) -> Disposable in
        
        observer.onNext("测试create1")
        observer.onNext("测试create2")
        observer.onNext("测试create3")
        observer.onCompleted()
        
        return Disposables.create()
    }

    //订阅测试
    observable.subscribe(onNext: { (result) in
        print(result)
    }, onError: { (error) in
        print(error)
    }, onCompleted: {
        print("结束")
    }).disposed(by: disposeBag)
}

//打印结果
//
//测试create1
//测试create2
//测试create3
//结束

//MARK: - just方法
/*
 该方法通过传入一个默认值来初始化。 just 下面样例我们显式地标注出了 observable 的类型为 Observable，
 即指定了这个 Observable 所发出的事件携带的数据类型必须是 Int 类型的。
 */

//核心代码
/*
 let observable = Observable<Int>.just(5)
 
 //其实它是相当于
 
 let id = Observable<Int>.create { observer in
     observer.onNext(5)
     observer.onCompleted()
     return Disposables.create()
 }
 */

//全部代码
func setUPJust(){
    let disposeBag = DisposeBag()
    let observable = Observable<Int>.just(5)
    observable.subscribe(onNext: { (result) in
        print(result)
    }, onError: { (error) in
        
    }, onCompleted: {
        print("结束")
    }).disposed(by: disposeBag)
}

//打印结果
//
//5
//结束

//MARK: - from方法
/*
 将其他类型或者数据结构转换为 Observable
 当你在使用 Observable 时，如果能够直接将其他类型转换为 Observable，这将是非常省事的。from 操作符就提供了这种功能。
 
 将一个数组转换为 Observable：
 let numbers = Observable.from([1,2,3,4,5])
 它相当于：
 let numbers = Observable<Int>.create { observer in
     observer.onNext(1)
     observer.onNext(2)
     observer.onNext(3)
     observer.onNext(4)
     observer.onNext(5)
     observer.onCompleted()
     return Disposables.create()
 }
 */
func setUPFrom() {
    let disposeBag = DisposeBag()
//    let observable = Observable.from([1,2,3,4,5])
    let observable = Observable.from(["1":"one","2":"two"])
    
    observable.subscribe(onNext: { (result) in
        print(result)
    }, onError: { (error) in
        
    }, onCompleted: {
        print("结束")
    }).disposed(by: disposeBag)
}

//打印结果1
//
//1
//2
//3
//4
//5
//结束

//打印结果2
//
//(key: "2", value: "two")
//(key: "1", value: "one")
//结束

//MARK: - repeatElement方法
/*
 该方法创建一个可以无限发出给定元素的 Event 的 Observable 序列（永不终止）。
 创建 Observable 重复的发出某个元素：
 let id = Observable.repeatElement(0)
 */

//MARK: - deferred
/*
 直到订阅发生，才创建 Observable，并且为每位订阅者创建全新的 Observable

 deferred 操作符将等待观察者订阅它，才创建一个 Observable，它会通过一个构建函数为每一位订阅者创建新的 Observable。看上去每位订阅者都是对同一个 Observable 产生订阅，实际上它们都获得了独立的序列。

 在一些情况下，直到订阅时才创建 Observable 是可以保证拿到的数据都是最新的。
 */
func setUPDeferredt() {
    let disposeBag = DisposeBag()
    //用于标记是奇数、还是偶数
    var isOdd = true
    
    //使用deferred()方法延迟Observable序列的初始化，通过传入的block来实现Observable序列的初始化并且返回。
    let factory : Observable<Int> = Observable.deferred {
        
        //让每次执行这个block时候都会让奇、偶数进行交替
        isOdd = !isOdd
        
        //根据isOdd参数，决定创建并返回的是奇数Observable、还是偶数Observable
        if isOdd {
            return Observable.of(1, 3, 5 ,7)
        }else {
            return Observable.of(2, 4, 6, 8)
        }
    }
    
    //第1次订阅测试
    factory.subscribe { event in
        print("\(isOdd)", event)
    }.disposed(by: disposeBag)
    
    //第2次订阅测试
    factory.subscribe { event in
        print("\(isOdd)", event)
    }.disposed(by: disposeBag)
}

//打印结果
//
//false next(2)
//false next(4)
//false next(6)
//false next(8)
//false completed
//true next(1)
//true next(3)
//true next(5)
//true next(7)
//true completed

//MARK: - Interval
/*
 interval 操作符将创建一个 Observable，它每隔一段设定的时间，发出一个索引数的元素(索引递增)。它将发出无数个元素。
 */
func intervalMethod() {
    let disposeBag = DisposeBag()
    let observable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    observable.subscribe { event in
        print(event)
    }.disposed(by: disposeBag)
}

//MARK: - timer
func timerMethod() {
    let disposeBag = DisposeBag()
    let observable = Observable<Int>.timer(.seconds(5), scheduler: MainScheduler.instance)
//    let observable = Observable<Int>.timer(5, period: 1, scheduler: MainScheduler.instance)
    observable.subscribe { event in
        print(event)
    }.disposed(by: disposeBag)
}

//MARK: - empty
/*
 该方法创建一个空内容的 Observable 序列。
 let _ = Observable<String>.empty()
 */

//MARK: - never
/*
 创建一个永远不会发出元素的 Observable never 操作符将创建一个 Observable，这个 Observable 不会产生任何事件。
 let id = Observable<Int>.never()
 相当于：
 let id = Observable<Int>.create { observer in
    return Disposables.create()
 }

 */
