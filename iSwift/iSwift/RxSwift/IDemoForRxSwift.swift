//
//  IDemoForRxSwift.swift
//  iSwift
//
//  Created by ibabyblue on 2024/12/16.
//

import Foundation
import RxSwift
import RxCocoa

struct IDemoForRxSwift {
    init() {
        foo()
    }
    
    func foo() {
        //清除包
        let disposeBag = DisposeBag()

//MARK: - 基础使用
        //RxSwift示例
        let irx: IRxSwift = IRxSwift.init()
        
        //1、普通可观察序列
        irx.nObservable.subscribe { result in
            print("nObservable:", result)
        } onError: { error in
            print("nObservable:", error)
        } onCompleted: {
            print("nObservable: onCompleted")
        }.disposed(by: disposeBag)
        
        //2、just方法
        irx.jObservable.subscribe { result in
            print("jObservable: \(result)")
        } onError: { error in
            print("jObservable:", error)
        } onCompleted: {
            print("jObservable: onCompleted")
        }.disposed(by: disposeBag)

        //3、from方法
        irx.fObservable.subscribe { result in
            print("fObservable: \(result)")
        } onError: { error in
            print("fObservable:", error)
        } onCompleted: {
            print("fObservable: onCompleted")
        }.disposed(by: disposeBag)

        //4、map方法
        irx.mObservable.subscribe { result in
            print("mObservable: \(result)")
        } onError: { error in
            print("mObservable:", error)
        } onCompleted: {
            print("mObservable: onCompleted")
        }.disposed(by: disposeBag)
        
        //5、flatMap方法
        irx.fmObservable.subscribe { result in
            print("fmObservable: \(result)")
        } onError: { error in
            print("fmObservable:", error)
        } onCompleted: {
            print("fmObservable: onCompleted")
        }.disposed(by: disposeBag)
        
        //6、filter方法
        irx.fObservable2.subscribe { result in
            print("fObservable2: \(result)")
        } onError: { error in
            print("fObservable2:", error)
        } onCompleted: {
            print("fObservable2: onCompleted")
        }.disposed(by: disposeBag)
        
        //7、scan方法
        irx.sObservable.subscribe { result in
            print("sObservable: \(result)")
        } onError: { error in
            print("sObservable:", error)
        } onCompleted: {
            print("sObservable: onCompleted")
        }.disposed(by: disposeBag)
        
        //8、combineLatest方法
        irx.cObservable.subscribe { result in
            print("cObservable: \(result)")
        } onError: { error in
            print("cObservable:", error)
        } onCompleted: {
            print("cObservable: onCompleted")
        }.disposed(by: disposeBag)
        
        //9、zip方法
        irx.zObservable.subscribe { result in
            print("zObservable: \(result)")
        } onError: { error in
            print("zObservable:", error)
        } onCompleted: {
            print("zObservable: onCompleted")
        }.disposed(by: disposeBag)
        
        //10、merge方法
        irx.mgObservable.subscribe { result in
            print("mgObservable: \(result)")
        } onError: { error in
            print("mgObservable:", error)
        } onCompleted: {
            print("tObservable: onCompleted")
        }.disposed(by: disposeBag)
        
        //11、startWith方法
        irx.swObservable.subscribe { result in
            print("swObservable: \(result)")
        } onError: { error in
            print("swObservable:", error)
        } onCompleted: {
            print("swObservable: onCompleted")
        }.disposed(by: disposeBag)
        
        //12、concat方法
        irx.ctObservable.subscribe { result in
            print("ctObservable: \(result)")
        } onError: { error in
            print("ctObservable:", error)
        } onCompleted: {
            print("ctObservable: onCompleted")
        }.disposed(by: disposeBag)
        
        //13、distinctUntilChanged方法
        irx.dObservable.subscribe { result in
            print("dObservable: \(result)")
        } onError: { error in
            print("dObservable:", error)
        } onCompleted: {
            print("dObservable: onCompleted")
        }.disposed(by: disposeBag)
        
        //14、take方法
        irx.tObservable.subscribe { result in
            print("tObservable: \(result)")
        } onError: { error in
            print("tObservable:", error)
        } onCompleted: {
            print("tObservable: onCompleted")
        }.disposed(by: disposeBag)
        
        //15、takeLast方法
        irx.tlObservable.subscribe { result in
            print("tlObservable: \(result)")
        } onError: { error in
            print("tlObservable:", error)
        } onCompleted: {
            print("tlObservable: onCompleted")
        }.disposed(by: disposeBag)
        
        //16、takeWhile方法
        irx.twObservable.subscribe { result in
            print("twObservable: \(result)")
        } onError: { error in
            print("twObservable:", error)
        } onCompleted: {
            print("twObservable: onCompleted")
        }.disposed(by: disposeBag)
        
        //17、skip方法
        irx.skObservable.subscribe { result in
            print("skObservable: \(result)")
        } onError: { error in
            print("skObservable:", error)
        } onCompleted: {
            print("skObservable: onCompleted")
        }.disposed(by: disposeBag)
        
        //18、skipWhile方法
        irx.swObservable2.subscribe { result in
            print("swObservable2: \(result)")
        } onError: { error in
            print("swObservable2:", error)
        } onCompleted: {
            print("swObservable2: onCompleted")
        }.disposed(by: disposeBag)
        
        //19、elementAt方法
        irx.eaObservable.subscribe { result in
            print("eaObservable: \(result)")
        } onError: { error in
            print("eaObservable:", error)
        } onCompleted: {
            print("eaObservable: onCompleted")
        }.disposed(by: disposeBag)
        
        //20、ignoreElements方法，忽略所有元素，只接收onCompleted和onError事件
        irx.ieObservable.subscribe { result in
            //永远不会执行此代码
            print("ieObservable: \(result)")
        } onError: { error in
            print("ieObservable:", error)
        } onCompleted: {
            print("ieObservable: onCompleted")
        }.disposed(by: disposeBag)
        
        //21、toArray方法，将所有元素转为数组
        irx.taObservable.subscribe { result in
            print("taObservable:", result)
        } onFailure: { error in
            print("taObservable:", error)
        } onDisposed: {
            print("taObservable: onCompleted")
        }.disposed(by: disposeBag)

        //22、reduce方法，将所有元素合并为一个元素
        irx.rObservable.subscribe { result in
            print("rObservable:", result)
        } onError: { error in
            print("rObservable:", error)
        } onCompleted: {
            print("rObservable: onCompleted")
        }.disposed(by: disposeBag)
        
        //23、concatMap方法
        irx.cmObservable.subscribe { result in
            print("cmObservable:", result)
        } onError: { error in
            print("cmObservable:", error)
        } onCompleted: {
            print("cmObservable: onCompleted")
        }.disposed(by: disposeBag)
        
        //24、deferred方法
        //第1次订阅
        irx.dfObservable.subscribe { result in
            print("dfObservable:", result)
        }.disposed(by: disposeBag)

        //第2次订阅
        irx.dfObservable.subscribe { result in
            print("dfObservable:", result)
        }.disposed(by: disposeBag)
        
//MARK: - 进阶用法
        //1、Single方法
        irx.getRepo("xx/xx").subscribe { data in
            let dict = try? JSONSerialization.jsonObject(with: data as! Data, options: []) as? [String: AnyObject]
            print("返回结果：\(String(describing: dict))")
        } onFailure: { error in
            print("Error: ", error)
        }.disposed(by: disposeBag)
        
        //2、Completable方法
        irx.completable.subscribe(onCompleted: {
            print("cpt")
        }, onError: { error in
            print("cpt error: ", error)
        }).disposed(by: disposeBag)
        
        //3、bind方法在RxCocoa模块中
        //绑定数据到UILabel的text属性
        let label = UILabel()
        let binder = Binder(label) { obj, text in
            obj.text = text
        }
        
        Observable<String>.just("Hello, RxSwift!")
            .bind(to: binder)
            .disposed(by: disposeBag)
        
        //4、观察者-AnyObserver
        let aObserver: AnyObserver<Int> = AnyObserver { event in
            switch event {
            case .next(let value):
                print("Next: \(value)")
            case .error(let error):
                print("Error: \(error)")
            case .completed:
                print("Completed")
            }
        }
        
        let aObservable = Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance)
        aObservable.subscribe(aObserver).disposed(by: disposeBag)
        
//MARK: Subjects 即是订阅者 又是Observable
        //Subject种类:PublishSubject、BehaviorSubject、ReplaySubject、AsyncSubject
        //MARK: 1.AsyncSubject
        /*
         注释：
         1、AsyncSubject将在源Observable产生完成事件后，发出最后一个元素（仅仅只有最后一个元素），如果源Observable没有发出任何元素，“只有一个完成事件。那AsyncSubject也只有一个完成事件。”
         2、如果源Observable因为产生了一个error事件而中止，AsyncSubject就不会发出任何元素，而是将这个error事件发送出来”
         */
        let asyncSubject = AsyncSubject<String>()
        asyncSubject.subscribe { event in
            print("asyncSubject: \(event)")
        }.disposed(by: disposeBag)
        
        asyncSubject.onNext("🐶")
        asyncSubject.onNext("🐱")
        asyncSubject.onNext("🐹")
        asyncSubject.onCompleted()
        
        /*
         输出结果：
         Subscription: 1 Event: next(🐹)
         Subscription: 1 Event: completed
         */
        
        //MARK: 2.PublishSubject
        /*
         注释:
         1、PublishSubject的订阅者从他们开始订阅的时间点起，可以收到订阅后Subject发出的新Event，而不会收到他们在订阅前已发出的 Event
         2、如果源Observable因为产生了一个error事件而中止，PublishSubject就不会发出任何元素，而是将这个error事件发送出来
         */
        let publishSubject = PublishSubject<String>()
        publishSubject.onNext("此时没有订阅者，所以这条信息不会输出到控制台")
        
        publishSubject.subscribe { event in
            print("publishSubject1: \(event)")
        }.disposed(by: disposeBag)

        publishSubject.onNext("🐶")
        publishSubject.onNext("🐱")

        publishSubject
        .subscribe { print("Subscription: 2 Event:",$0) }
        .disposed(by: disposeBag)

        publishSubject.onNext("🅰️")
        publishSubject.onNext("🅱️")
        /*
         输出结果：
         Subscription: 1 Event: next(🐶)
         Subscription: 1 Event: next(🐱)
         Subscription: 1 Event: next(🅰️)
         Subscription: 2 Event: next(🅰️)
         Subscription: 1 Event: next(🅱️)
         Subscription: 2 Event: next(🅱️)
         */
         
        //MARK: 3.ReplaySubject
        /*
         注释:
            1、ReplaySubject在创建时候需要设置一个bufferSize，表示它对于它发送过的event的缓存个数。
            2、比如一个ReplaySubject的bufferSize设置为2，它发出了3个.next的event，那么它会将后两个（最近的两个）event 给缓存起来。此时如果有一个subscriber订阅了这个ReplaySubject，那么这个subscriber就会立即收到前面缓存的两个 .next的event。
            3、如果一个subscriber订阅已经结束的ReplaySubject，除了会收到缓存的.next的event外，还会收到那个终结的.error或者 .complete的event。
            4、如果把ReplaySubject当作观察者来使用，注意不要在多个线程调用onNext, onError或onCompleted。这样会导致无序调用，将造成意想不到的结果
         */
        let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
        //连续发送3个next事件
        replaySubject.onNext("1")
        replaySubject.onNext("2")
        replaySubject.onNext("3")
        
        //第一个订阅
        replaySubject.subscribe {
            print("第1次订阅",$0)
        }.disposed(by: disposeBag)
        
        //再发送一个next事件
        replaySubject.onNext("4")
        
        //第二个订阅
        replaySubject.subscribe { event in
            print("第2次订阅：", event)
        }.disposed(by: disposeBag)

        //让subject结束
        replaySubject.onCompleted()
        
        //第3次订阅subject
        replaySubject.subscribe { event in
            print("第3次订阅：", event)
        }.disposed(by: disposeBag)
        
        /*
         输出结果：
         第1次订阅： next(2)
         第1次订阅： next(3)
         第1次订阅： next(4)
         第2次订阅： next(3)
         第2次订阅： next(4)
         第1次订阅： completed
         第2次订阅： completed
         第3次订阅： next(3)
         第3次订阅： next(4)
         第3次订阅： completed
         */
        
        //MARK: 4.BehaviorSubject
        /*
         1、当观察者对BehaviorSubject进行订阅时，它会将源Observable中最新的元素发送出来（如果不存在最新的元素，就发出默认元素）。然后将随后产生的元素发送出来。
         2、如果源Observable因为产生了一个error事件而中止，BehaviorSubject就不会发出任何元素，而是将这个error事件发送出来
         */
        let behaviorSubject = BehaviorSubject(value: "1")
        behaviorSubject.onNext("2")
        behaviorSubject.onNext("3")
        
        //第一次订阅behaviorSubject
        behaviorSubject.subscribe {
            print("第1次订阅：", $0)
        }.disposed(by: disposeBag)
        
        behaviorSubject.onNext("4")
        behaviorSubject.onNext("5")
        
        behaviorSubject.onError(NSError(domain: "com.ibabyblue", code: -1))
        
        behaviorSubject.subscribe { event in
            print("第2次订阅：", event)
        }.disposed(by: disposeBag)
        
        /*
         输出结果:
         第1次订阅： next(3)
         第1次订阅： next(4)
         第1次订阅： next(5)
         第1次订阅： error(Error Domain=local Code=0 "(null)")
         第2次订阅： error(Error Domain=local Code=0 "(null)")
         */
        
    }
}
