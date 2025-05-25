//
//  07-Operator.swift
//  iSwift
//
//  Created by ibabyblue on 2025/5/25.
//

import Foundation
import RxSwift
import RxCocoa

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
 而 flatMap 操作符会对源 Observable 的每一个元素应用一个转换方法，将他们转换成 Observables。 然后将这些 Observables 的元素合并之后再发送出来。即又将其 "拍扁"（降维）成一个 Observable 序列。
 这个操作符是非常有用的，例如，当 Observable 的元素本生拥有其他的 Observable 时，你可以将所有子 Observables 的元素发送出来。
 
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

