//
//  IRxSwift.swift
//  iSwift
//
//  Created by ibabyblue on 2024/12/16.
//

import Foundation
import RxSwift

enum IRxError: Error {
    case illegalArg(String)
    case outOfBounds(Int, Int)
    case outOfMemory
}

struct IRxSwift {
//MARK: - 基本用法
    //1、自定义普通可观察序列
    let nObservable = Observable<Int>.create { observer -> Disposable in
        observer.onNext(1)
        observer.onNext(2)
        observer.onCompleted()
        return Disposables.create()
    }
    
    //2、just方法
    let jObservable: Observable = Observable<Int>.just(1)
    //等价于
//    let jObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(1)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //3、from方法
    //数组
//    let fObservable = Observable.from([1, 2, 3])
    //字典
    let fObservable = Observable.from(["one": 1, "tow": 2,])
    //等价于
//    let fObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(1)
//        observer.onNext(2)
//        observer.onNext(3)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //4、map方法
    //map方法用于将原始序列的每个元素转换为新的元素
    let mObservable = Observable<Int>.just(1).map { $0 + 1 }
    //等价于
//    let mObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(2)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //5、flatMap方法
    //flatMap方法用于将原始序列的每个元素转换为新的序列
    let fmObservable = Observable<Int>.just(1).flatMap { Observable.just($0 + 1) }
    //等价于
//    let fmObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(2)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //6、filter方法
    //filter方法用于过滤原始序列的元素
    let fObservable2 = Observable<Int>.just(1).filter { $0 > 0 }
    //等价于
//    let fObservable2 = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(1)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //7、scan方法
    //scan方法用于将原始序列的元素进行累加
    let sObservable = Observable<Int>.of(1, 2, 3).scan(0) { $0 + $1 }
    //等价于
//    let sObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(0)
//        observer.onNext(1)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //8、combineLatest方法
    //combineLatest方法用于将多个序列的最新元素进行组合
    let cObservable = Observable.combineLatest(Observable.just(1), Observable.just(2)) { $0 + $1 }
    //等价于
//    let cObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(3)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //9、zip方法
    //zip方法用于将多个序列的元素进行组合
    let zObservable = Observable.zip(Observable.just(1), Observable.just(2)) { $0 + $1 }
    //等价于
//    let zObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(3)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //10、merge方法
    //merge方法用于将多个序列的元素进行合并
    let mgObservable = Observable.merge(Observable.just(1), Observable.just(2))
    //等价于
//    let mgObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(1)
//        observer.onNext(2)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //11、startWith方法
    //startWith方法用于在原始序列的元素前插入一个元素
    let swObservable = Observable.just(1).startWith(0)
    //等价于
//    let swObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(0)
//        observer.onNext(1)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //12、concat方法
    //concat方法用于将多个序列进行连接
    let ctObservable = Observable.concat(Observable.just(1), Observable.just(2))
    //等价于
//    let ctObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(1)
//        observer.onNext(2)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //13、distinctUntilChanged方法
    //distinctUntilChanged方法用于过滤掉连续重复的元素
    let dObservable = Observable.of(1, 1, 2, 2, 3, 3).distinctUntilChanged()
    //等价于
//    let dObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(1)
//        observer.onNext(2)
//        observer.onNext(3)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //14、take方法
    //take方法用于取前n个元素
    let tObservable = Observable.of(1, 2, 3).take(2)
    //等价于
//    let tObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(1)
//        observer.onNext(2)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //15、takeLast方法
    //takeLast方法用于取后n个元素
    let tlObservable = Observable.of(1, 2, 3).takeLast(2)
    //等价于
//    let tlObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(2)
//        observer.onNext(3)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //16、takeWhile方法
    //takeWhile方法用于取满足条件的元素，不满足条件立即终止序列，并不输出任何值
    let twObservable = Observable.of(1, 2, 3).take(while: { v in
        v > 2
    })
    //等价于
//    let twObservable = Observable<Int>.create { observer -> Disposable in
//        //直接结束序列，因为第一个元素不满足大于2的条件
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //17、skip方法
    //skip方法用于跳过前n个元素
    let skObservable = Observable.of(1, 2, 3).skip(1)
    //等价于
//    let skObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(2)
//        observer.onNext(3)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //18、skipWhile方法
    //skipWhile方法用于跳过满足条件的元素，不满足条件立即输出所有元素
    let swObservable2 = Observable.of(1, 2, 3).skip(while: { v in
        v > 2
    })
    //等价于
    //第一个元素1>2为假，停止跳过输出后面所有元素
//    let swObservable2 = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(1)
//        observer.onNext(2)
//        observer.onNext(3)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //19、elementAt方法
    //elementAt方法用于取指定位置的元素
    let eaObservable = Observable.of(1, 2, 3).element(at: 1)
    //等价于
//    let eaObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(2)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //20、ignoreElements方法
    //ignoreElements方法用于忽略所有元素，只输出错误或完成事件
    let ieObservable = Observable.of(1, 2, 3).ignoreElements()
    //等价于
//    let ieObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //21、toArray方法
    //toArray方法用于将所有元素转换为数组
    let taObservable = Observable.of(1, 2, 3).toArray()
    //等价于
//    let taObservable = Observable<[Int]>.create { observer -> Disposable in
//        observer.onNext([1, 2, 3])
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //22、reduce方法
    //reduce方法用于将所有元素进行累加
    let rObservable = Observable.of(1, 2, 3).reduce(0, accumulator: +)
    //等价于
//    let rObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(6)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //23、concatMap方法
    //concatMap方法用于将原始序列的每个元素转换为新的序列，并将这些序列进行连接
    let cmObservable = Observable.of(1, 2, 3).concatMap { Observable.just($0 + 1) }
    //等价于
//    let cmObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(2)
//        observer.onNext(3)
//        observer.onNext(4)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //24、switchLatest方法
    //switchLatest方法用于将原始序列的每个元素转换为新的序列，并只输出最新的序列
    let slObservable = Observable.of(1, 2, 3).map { Observable.just($0 + 1) }.switchLatest()
    //等价于
//    let slObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(2)
//        observer.onNext(3)
//        observer.onNext(4)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //25、amb方法
    //amb方法用于将多个序列进行竞争，只输出第一个发出元素的序列
    let aObservable = Observable.amb([Observable.of(1, 2, 3), Observable.of(4, 5, 6)])
    //等价于
//    let aObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(1)
//        observer.onNext(2)
//        observer.onNext(3)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //26、materialize方法
    //materialize方法用于将事件转换为元素
    let mtObservable = Observable.of(1, 2, 3).materialize()
    //等价于
//    let mtObservable = Observable<Event<Int>>.create { observer -> Disposable in
//        observer.onNext(.next(1))
//        observer.onNext(.next(2))
//        observer.onNext(.next(3))
//        observer.onNext(.completed)
//        return Disposables.create()
//    }
    
    //27、dematerialize方法
    //dematerialize方法用于将元素转换为事件
    let dmObservable = Observable.of(1, 2, 3).materialize().dematerialize()
    //等价于
//    let dmObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(1)
//        observer.onNext(2)
//        observer.onNext(3)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //28、timeout方法
    //timeout方法用于设置超时时间
    let toObservable = Observable.of(1, 2, 3).delay(.seconds(2), scheduler: MainScheduler.instance).timeout(.seconds(1), scheduler: MainScheduler.instance)
    //等价于
//    let toObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onError(RxError.timeout)
//        return Disposables.create()
//    }
    
    //29、delay方法
    //delay方法用于延迟发送元素
    let dlObservable = Observable.of(1, 2, 3).delay(.seconds(1), scheduler: MainScheduler.instance)
    //等价于
//    let dlObservable = Observable<Int>.create { observer -> Disposable in
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            observer.onNext(1)
//            observer.onNext(2)
//            observer.onNext(3)
//            observer.onCompleted()
//        }
//        return Disposables.create()
//    }
    
    //30、interval方法
    //interval方法用于定时发送元素
    let iObservable = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    //等价于
//    let iObservable = Observable<Int>.create { observer -> Disposable in
//        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
//        timer.schedule(deadline: .now(), repeating: 1)
//        timer.setEventHandler {
//            observer.onNext(0)
//        }
//        timer.resume()
//        return Disposables.create {
//            timer.cancel()
//        }
//    }
    
    //31、timer方法
    //timer方法用于延迟发送元素
    let tmObservable = Observable<Int>.timer(.seconds(1), scheduler: MainScheduler.instance)
    //等价于
//    let tmObservable = Observable<Int>.create { observer -> Disposable in
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            observer.onNext(0)
//            observer.onCompleted()
//        }
//        return Disposables.create()
//    }
    
    //32、never方法
    //never方法用于创建一个永不结束的序列
    let nvObservable = Observable<Int>.never()
    //等价于
//    let nvObservable = Observable<Int>.create { observer -> Disposable in
//        return Disposables.create()
//    }
    
    //33、empty方法
    //empty方法用于创建一个空的序列
    let emObservable = Observable<Int>.empty()
    //等价于
//    let emObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
    //34、error方法
    //error方法用于创建一个错误的序列
    let erObservable = Observable<Int>.error(RxError.unknown)
    //等价于
//    let erObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onError(RxError.unknown)
//        return Disposables.create()
//    }
    
    //35、deferred方法
    //deferred方法用于延迟创建序列,直到订阅发生,才创建 Observable,并且为每位订阅者创建全新的 Observable
    static var i = false
    let dfObservable = Observable.deferred {
        i = !i
        return i == true ?  Observable.of(1, 3, 5) : Observable.of(2, 4, 6)
    }
    //等价于
//    let dfObservable = Observable<Int>.create { observer -> Disposable in
//        observer.onNext(1)
//        observer.onNext(2)
//        observer.onNext(3)
//        observer.onCompleted()
//        return Disposables.create()
//    }
    
//MARK: - 进阶用法
//MARK: Single
    /*
     Single是另一种Observable,不像Observable可以发出多个元素,它要么发出一个元素,要么产生一个Error事件
     - 发出一个元素，或一个 error 事件
     - 不会共享状态变化
     */
    //模拟网络请求
    func getRepo(_ url: String) -> Single<Any>{
        let sgl = Single<Any>.create { singleEvent in
            let url = URL(string: "https://api.github.com/repos/\(url)")!
            let task = URLSession.shared.dataTask(with: url) {
                data, _, error in
                if let error = error {
                    singleEvent(.failure(error))
                    return
                }

                guard let data = data else {
                    let dataError = "data解析错误" as! Error
                    singleEvent(.failure(dataError))
                    return
                }
                singleEvent(.success(data))
            }

            task.resume()
            return Disposables.create()
        }
        return sgl
    }
    
//MARK: Completable
    /*
     Completable是另一种Observable,不像Observable可以发出多个元素,它要么产生一个completed事件,要么产生一个error事件
     - 发出一个 completed 事件，或一个 error 事件
     - 适用于那种只关心任务是否完成，而不需要在意任务返回值的情况
     */
    //模拟网络请求
    let completable = Completable.create { (cpt) -> Disposable in
        if arc4random() % 2 == 1 {
            cpt(.completed)
        } else {
            cpt(.error(IRxError.illegalArg("这是一个错误")))
        }
        return Disposables.create()
    }
}
