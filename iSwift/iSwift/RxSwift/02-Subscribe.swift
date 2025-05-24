//
//  02-Subscribe.swift
//  iSwift
//
//  Created by ibabyblue on 2025/5/24.
//

import Foundation
import RxSwift
import RxCocoa

//有了 Observable，我们还要使用 subscribe() 方法来订阅它，接收它发出的 Event。

/*
 第一种用法
 我们使用 subscribe() 订阅了一个 Observable 对象，该方法的 block 的回调参数就是被发出的 event 事件，我们将其直接打印出来。
 */
func firstMethod() {
    let disposeBag = DisposeBag()
    let observable = Observable.of("A", "B", "C")
    observable.subscribe { event in
        print(event)
//        print(event.element ?? "")
    }.disposed(by: disposeBag)
}
//打印结果1
//
//next(A)
//next(B)
//next(C)
//completed

//打印结果2
//
//A
//B
//C

/*
 第二种用法
 RxSwift 还提供了另一个 subscribe 方法，它可以把 event 进行分类：
 - 通过不同的 block 回调处理不同类型的 event。
 - 同时会把 event 携带的数据直接解包出来作为参数，方便我们使用
 */

func secondMethod() {
    let disposeBag = DisposeBag()
    let observable = Observable.of("A", "B", "C")
    
    observable.subscribe(onNext: { element in
        print(element)
    }, onError: { error in
        print(error)
    }, onCompleted: {
        print("completed")
    }, onDisposed: {
        print("disposed")
    }).disposed(by:disposeBag)
}
/*
 subscribe() 方法的 onNext、onError、onCompleted 和 onDisposed 这四个回调 block 参数都是有默认值的，
 即它们都是可选的。所以我们也可以只处理 onNext 而不管其他的情况。
 */


