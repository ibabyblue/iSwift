//
//  07-Operator.swift
//  iSwift
//
//  Created by ibabyblue on 2025/5/25.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: --- 变换操作符
//MARK: - map
/*
 通过一个转换函数，将observable的每一个元素转换一遍
 Observable.of(1, 2, 3)
 .map { $0 * 10 }
 .subscribe(onNext: { print($0) })
 .disposed(by: disposeBag)
 
 打印结果
 10
 20
 30
 */

//MARK: - flatMap
/*
 将observable的元素转化成其他的observable，然后将这些observable合并，
 flatMap 操作符将源 Observable 的每一个元素应用一个转换方法，将他们转换成 Observables。 然后将这些 Observables 的元素合并之后再发送出来
 map 在做转换的时候容易出现“升维”的情况。即转变之后，从一个序列变成了一个序列的序列。
 而 flatMap 操作符会对源 Observable 的每一个元素应用一个转换方法，将它们转换成 Observables。 然后将这些 Observables 的元素合并之后再发送出来。即又将其 "拍扁"（降维）成一个 Observable 序列。
 这个操作符是非常有用的，例如，当 Observable 的元素本生拥有其他的 Observable 时，可以将所有子 Observables 的元素发送出来。
 
 let disposeBag = DisposeBag()

 let subject1 = BehaviorSubject(value: "A")
 let subject2 = BehaviorSubject(value: "1")

 let relay = BehaviorRelay<Observable<String>>(value: subject1)

 relay
     .asObservable()
     .flatMap{ $0 }
     .subscribe(onNext: { print($0) })
     .disposed(by: disposeBag)

 subject1.onNext("B")
 relay.accept(subject2)
 subject2.onNext("2")
 subject1.onNext("C")
 
 打印结果:
 A
 B
 1
 2
 C
 */

//MARK: - flatMapLatest
/*
 将observable的元素转化成其他的observable，然后取这些observable中最新的一个
 let disposeBag = DisposeBag()

 let subject1 = BehaviorSubject(value: "A")
 let subject2 = BehaviorSubject(value: "1")

 let relay = BehaviorRelay<Observable<String>>(value: subject1)

 relay
     .asObservable()
     .flatMapLatest{ $0 }
     .subscribe(onNext: { print($0) })
     .disposed(by: disposeBag)

 subject1.onNext("B")
 relay.accept(subject2)
 subject2.onNext("2")
 subject1.onNext("C")
 
 打印结果:
 A
 B
 1
 2
 */

//MARK: - concatMap
/*
 将 Observable 的元素转换成其他的 Observable，然后将这些 Observables 串连起来
 concatMap 操作符将源 Observable 的每一个元素应用一个转换方法，将他们转换成 Observables。然后让这些 Observables 按顺序的发出元素，当前一个 Observable 元素发送完毕后，后一个 Observable 才可以开始发出元素。等待前一个 Observable 产生完成事件后，才对后一个 Observable 进行订阅
 concatMap 与 flatMap 的唯一区别是：当前一个 Observable 元素发送完毕后，后一个Observable 才可以开始发出元素。或者说等待前一个 Observable 产生完成事件后，才对后一个 Observable 进行订阅。
 
 let disposeBag = DisposeBag()
 let subject1 = BehaviorSubject(value: "A")
 let subject2 = BehaviorSubject(value: "1")

 let relay = BehaviorRelay<Observable<String>>(value: subject1)

 relay
     .asObservable()
     .concatMap{ $0 }
     .subscribe(onNext: { print($0) })
     .disposed(by: disposeBag)

 subject1.onNext("B")
 relay.accept(subject2)
 subject2.onNext("2")
 subject1.onNext("C")
 subject1.onCompleted() //只有前一个序列结束后，才能接收下一个序列
 
 打印结果:
 A
 B
 C
 2
 */

//MARK: - scan
/*
 scan 就是先给一个初始化的数，然后不断的拿前一个结果和最新的值进行处理操作
 
 let disposeBag = DisposeBag()
 Observable.of(2, 4, 6)
 .scan(1) { aggregateValue, newValue in
    aggregateValue * newValue
 }
 .subscribe(onNext: { print($0) })
 .disposed(by: disposeBag)
 
 打印结果:
 2
 8
 48
 */

//MARK: -
//MARK: --- 过滤操作符
/*
 过滤操作指的是从源 Observable 中选择特定的数据发送。
    - 通过判定条件过滤出一些元素：filter
    - 仅仅发出第几个元素：elementAt
    - 跳过开头几个元素
        - 跳过开头几个元素：skip
        - 跳过 Observable 中开头几个元素，直到另一个 Observable 发出一个元素 ：skipUntil
    - 只取开头几个元素
        - 只取开头几个满足判定的元素：takeWhile，takeWhileWithIndex
        - 只取某段时间内产生的开头几个元素：take
        - 只取开头几个元素直到另一个observable发出一个元素：takeUntil
        - 仅仅发出尾部几个元素：takeLast
    - 周期性对observable抽样：sample
    - 发出哪些元素，这些元素产生后的特定时间内没有新元素产生：debounce（防抖）
    - 直到元素的值发生变化才发出新的元素：distinctUntilChanged
 */

//MARK: - filter
/*
 - 该操作符就是用来过滤掉某些不符合要求的事件。
 
 let disposeBag = DisposeBag()
 Observable.of(2, 30, 22, 5, 60, 3, 40 ,9)
 .filter {
    $0 > 10
 }
 .subscribe(onNext: { print($0) })
 .disposed(by: disposeBag)
 
 结果:
 30
 22
 60
 40
 */

//MARK: - elementAt
/*
 - 该方法实现只处理在指定位置的事件
 
 let disposeBag = DisposeBag()
 Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
 .elementAt(2)
 .subscribe(onNext: { print($0) })
 .disposed(by: disposeBag)
 
 打印结果:
 🐶
 */

//MARK: - skip
/*
 - skip 跳过Observable的开头几个元素
 let disposeBag = DisposeBag()
 Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
 .skip(2)
 .subscribe(onNext: { print($0) })
 .disposed(by: disposeBag)
 
 打印结果：
 🐶
 🐸
 🐷
 🐵
 */

//MARK: - skipUntil
/*
 - 跳过observable中开头几个元素，直到另一个observable发出第一个元素
 
 let disposeBag = DisposeBag()
 let sourceSequence1 = PublishSubject<Any>()
 let referenceSequence1 = PublishSubject<Any>()

 sourceSequence1
 .skipUntil(referenceSequence1)
 .subscribe(onNext: { print($0,"->skipUntil") })
 .disposed(by: disposeBag)
 
 sourceSequence1.onNext("🐱")
 sourceSequence1.onNext("🐰")
 sourceSequence1.onNext("🐶")
 referenceSequence1.onNext("🔴")
 sourceSequence1.onNext("🐸")
 sourceSequence1.onNext("🐷")
 sourceSequence1.onNext("🐵")
 
 打印结果：
 🐸 ->skipUntil
 🐷 ->skipUntil
 🐵 ->skipUntil
 */

//MARK: - take
/*
 - 只取某段时间内产生的开头几个元素
 let disposeBag = DisposeBag()
 Observable.of("1","2","3","4","5")
 .take(2)
 .subscribe(onNext: {print($0)})
 .disposed(by: disposeBag)
 
 打印结果:
 1
 2
 */

//MARK: - takeLast
/*
 - 仅仅从observable中发出尾部的n个元素
 
 takeLast(1)
 */

//MARK: - takeUntil
/*
 除了订阅源 Observable 外，通过 takeUntil 方法我们还可以监视另外一个 Observable， 即 notifier
 如果 notifier 发出值或 complete 通知，那么源 Observable 便自动完成，停止发送事件。
 
 let disposeBag = DisposeBag()
 let source = PublishSubject<String>()
 let notifier = PublishSubject<String>()

 source
 .takeUntil(notifier)
 .subscribe(onNext: { print($0) })
 .disposed(by: disposeBag)

 source.onNext("1")
 source.onNext("2")


 //停止接收消息
 notifier.onNext("0")

 source.onNext("3")
 source.onNext("4")
 
 打印结果:
 1
 2
 */

//MARK: - takeWhile
/*
 - 该方法依次判断 Observable 序列的每一个值是否满足给定的条件。 当第一个不满足条件的值出现时，它便自动完成。
 
 let disposeBag = DisposeBag()
 Observable.of(2, 3, 4, 5, 6)
 .takeWhile { $0 < 4 }
 .subscribe(onNext: { print($0) })
 .disposed(by: disposeBag)
 
 打印结果:
 2
 3
 */

//MARK: - sample
/*
 - Sample 除了订阅源 Observable 外，还可以监视另外一个 Observable， 即 notifier 。
 每当收到 notifier 事件，就会从源序列取一个最新的事件并发送。而如果两次 notifier 事件之间没有源序列的事件，则不发送值。
 
 let disposeBag = DisposeBag()
 let source = PublishSubject<Int>()
 let notifier = PublishSubject<String>()
 source
 .sample(notifier)
 .subscribe(onNext: { print($0) })
 .disposed(by: disposeBag)
 
 source.onNext(1)
 //让源序列接收接收消息
 notifier.onNext("A")
 
 source.onNext(2)
 //让源序列接收接收消息
 notifier.onNext("B")
 notifier.onNext("C")
 source.onNext(3)
 source.onNext(4)
 
 //让源序列接收接收消息
 notifier.onNext("D")
 source.onNext(5)
 source.onNext(6)
 
 //让源序列接收接收消息
 notifier.onCompleted()
 
 打印结果:
 1
 2
 4
 6
 */

//MARK: - debounce
/*
 - debounce 操作符可以用来过滤掉高频产生的元素，它只会发出这种元素：该元素产生后，一段时间内没有新元素产生。 换句话说就是，队列中的元素如果和下一个元素的间隔小于了指定的时间间隔，那么这个元素将被过滤掉。 debounce 常用在用户输入的时候，不需要每个字母敲进去都发送一个事件，而是稍等一下取最后一个事件。
 
 //定义好每个事件里的值以及发送的时间
 let times: [[String: Any]] = [
     [ "value": 1, "time": 1 ],
     [ "value": 2, "time": 1 ],
     [ "value": 3, "time": 1 ],
     [ "value": 4, "time": 2 ],
     [ "value": 5, "time": 3 ],
     [ "value": 6, "time": 5 ]
 ]

 let disposeBag = DisposeBag()
 
 Observable.from(times)
     .flatMap { item -> Observable<Int> in
         guard let value = item["value"] as? Int,
               let delay = item["time"] as? Int else {
             return Observable.empty()
         }
         return Observable.just(value)
             .delaySubscription(.seconds(0), scheduler: MainScheduler.instance)
     }
     .debounce(.seconds(1), scheduler: MainScheduler.instance) //大于1秒的事件才会被发送
     .subscribe(onNext: { print($0) })
     .disposed(by: disposeBag)
 }
 
 打印结果:
 1
 4
 5
 6
 
 !!!: 这里有个问题 delaySubscription 和 delay方法都无效原因还未知？？
 */

//MARK: - distinctUntilChanged
/*
 阻止observable发出相同的元素，如果前一个元素和后一个元素是相同的，那么这个元素将不会被发出来，仅仅判断相邻的两个元素
 Observable.of("1","2","1","1","2","2","0")
 .distinctUntilChanged()
 .subscribe(onNext: {print($0)})
 .disposed(by: disposeBag)
 
 打印结果:
 1
 2
 1
 2
 0
 */

//MARK: -
//MARK: --- 结合操作
//结合操作（或者称合并操作）指的是将多个 Observable 序列进行组合，拼装成一个新的 Observable 序列。

//MARK: - merge
//将多个observable合并成一个
/*
 let disposeBag = DisposeBag()
 let subject1 = PublishSubject<String>()
 let subject2 = PublishSubject<String>()
 Observable.of(subject1,subject2)
 .merge()
 .subscribe(onNext: {print($0)})
 .disposed(by: disposeBag)

 subject1.onNext("A")
 subject1.onNext("B")
 subject2.onNext("1")
 subject1.onNext("C")
 subject2.onNext("2")
 
 打印结果:
 A
 B
 1
 C
 2
 */

//MARK: - concat
//让多个observable按顺序串联起来。
/*
 let disposeBag = DisposeBag()
 let subject1 = BehaviorSubject(value: 1)
 let subject2 = BehaviorSubject(value: 2)
 
 let concat = BehaviorRelay<Observable<Int>>(value: subject1)
 concat
 .concat()
 .subscribe(onNext: { print($0) })
 .disposed(by: disposeBag)

 subject2.onNext(2)
 subject1.onNext(1)
 subject1.onNext(1)
 subject1.onCompleted()

 concat.accept(subject2)
 subject2.onNext(2)
 
 打印结果:
 1
 1
 1
 2
 2
 */

//MARK: - zip
//通过一个函数将多个observable的元素组合起来，然后将每一个组合的结果发出来
//zip 操作符将多个(最多不超过8个) Observables 的元素通过一个函数组合起来，然后将这个组合的结果发出来。它会严格的按照序列的索引数进行组合。
/*
 let disposeBag = DisposeBag()
 let subject1 = PublishSubject<String>()
 let subject2 = PublishSubject<String>()
 Observable.zip(subject1,subject2){
     "\($0)\($1)"
 }
 .subscribe(onNext: {print($0)})
 .disposed(by: disposeBag)

 subject1.onNext("A")
 subject1.onNext("B")
 subject2.onNext("1")
 subject1.onNext("C")
 subject2.onNext("2")
 
 打印结果:
 A1
 B2
 */

//MARK: - combineLatest
//该方法同样是将多个（两个或两个以上的）Observable 序列元素进行合并。 但与 zip 不同的是，每当任意一个 Observable 有新的事件发出时，它会将每个 Observable 序列的最新的一个事件元素进行合并。
/*
 let disposeBag = DisposeBag()
 let subject1 = PublishSubject<String>()
 let subject2 = PublishSubject<String>()
 Observable.combineLatest(subject1,subject2){
     "\($0)\($1)"
 }
 .subscribe(onNext: {print($0)})
 .disposed(by: disposeBag)

 subject1.onNext("A")
 subject1.onNext("B")
 subject2.onNext("1")
 subject1.onNext("C")
 subject2.onNext("2")
 
 打印结果:
 B1
 C1
 C2
 */

