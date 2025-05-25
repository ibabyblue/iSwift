//
//  08-Driver.swift
//  iSwift
//
//  Created by ibabyblue on 2025/5/25.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: - Driver
/*
 Driver是一个精心准备的特征序列。它主要是为了简化 UI 层的代码。不过如果你遇到的序列具有以下特征，你也可以使用它：
    - 不会产生 error 事件
    - 一定在主线程监听（MainScheduler）
    - 共享状态变化（shareReplayLatestWhileConnected）
 
 为什么要使用 Driver?
    Driver 最常使用的场景应该就是需要用序列来驱动应用程序的情况了，比如：
        - 通过 CoreData 模型驱动 UI
        - 使用一个 UI 元素值（绑定）来驱动另一个 UI 元素值
 
 使用样例：
 ● 初学者使用 Observable 序列加 bindTo 绑定来实现这个功能的话可能会这么写：
 let disposeBag = DisposeBag()
 let results = query.rx.text
 .throttle(0.3, scheduler: MainScheduler.instance) //在主线程中操作，0.3秒内值若多次改变，取最后一次
 .flatMapLatest { query in //筛选出空值, 拍平序列
    fetchAutoCompleteItems(query) //向服务器请求一组结果
 }

 //将返回的结果绑定到用于显示结果数量的label上
 results
 .map { "\($0.count)" }
 .bind(to: resultCount.rx.text)
 .disposed(by: disposeBag)

 //将返回的结果绑定到tableView上
 results
 .bind(to: resultsTableView.rx.items(cellIdentifier: "Cell")) { (_, result, cell) in
    cell.textLabel?.text = "\(result)"
 }
 .disposed(by: disposeBag)
 
 但这个代码存在如下 3 个问题：
 - 如果 fetchAutoCompleteItems 的序列产生了一个错误（网络请求失败），这个错误将取消所有绑定，当用户输入一个新的关键字时，是无法发起新的网络请求。
 - 如果 fetchAutoCompleteItems 在后台返回序列，那么刷新页面也会在后台进行，这样就会出现异常崩溃。
 - 返回的结果被绑定到两个 UI 元素上。那就意味着，每次用户输入一个新的关键字时，就会分别为两个 UI 元素发起 HTTP 请求，这并不是我们想要的结果。
 
 ● 把上面几个问题修改后的代码是这样的：
 let disposeBag = DisposeBag()
 let results = query.rx.text
 .throttle(0.3, scheduler: MainScheduler.instance)//在主线程中操作，0.3秒内值若多次改变，取最后一次
 .flatMapLatest { query in //筛选出空值, 拍平序列
    fetchAutoCompleteItems(query)   //向服务器请求一组结果
    .observeOn(MainScheduler.instance)  //将返回结果切换到到主线程上
    .catchErrorJustReturn([])       //错误被处理了，这样至少不会终止整个序列
 }
 .shareReplay(1)                //HTTP 请求是被共享的

 //将返回的结果绑定到显示结果数量的label上
 results
 .map { "\($0.count)" }
 .bind(to: resultCount.rx.text)
 .disposed(by: disposeBag)

 //将返回的结果绑定到tableView上
 results
 .bind(to: resultsTableView.rx.items(cellIdentifier: "Cell")) { (_, result, cell) in
    cell.textLabel?.text = "\(result)"
 }
 .disposed(by: disposeBag)
 
    
 ● 使用 Driver 来实现
 let disposeBag = DisposeBag()
 let results = query.rx.text.asDriver()        // 将普通序列转换为 Driver
 .throttle(0.3, scheduler: MainScheduler.instance)
 .flatMapLatest { query in
    fetchAutoCompleteItems(query)
    .asDriver(onErrorJustReturn: [])  // 仅仅提供发生错误时的备选返回值
 }

 //将返回的结果绑定到显示结果数量的label上
 results
 .map { "\($0.count)" }
 .drive(resultCount.rx.text) // 这里使用 drive 而不是 bindTo
 .disposed(by: disposeBag)

 //将返回的结果绑定到tableView上
 results
 .drive(resultsTableView.rx.items(cellIdentifier: "Cell")) { //  同样使用 drive 而不是 bindTo
    (_, result, cell) in
    cell.textLabel?.text = "\(result)"
 }
 .disposed(by: disposeBag)
 由于 drive 方法只能被 Driver 调用。这意味着，如果代码存在 drive，那么这个序列不会产生错误事件并且一定在主线程监听。这样我们就可以安全的绑定 UI 元素
 
 解释
 - 首先第一个 asDriver 方法将 ControlProperty 转换为 Driver
 - 第二个变化.asDriver(onErrorJustReturn: [])
 
 asDriver(onErrorJustReturn: []) 相当于以下代码

 let safeSequence = xs
 .observeOn(MainScheduler.instance)       // 主线程监听
 .catchErrorJustReturn(onErrorJustReturn) // 无法产生错误
 .share(replay: 1, scope: .whileConnected)// 共享状态变化（自动共享序列,多次订阅也只请求一次网络）
 return Driver(raw: safeSequence)           // 封装
 */

//MARK: - Driver的使用(网络上其他例子)
/*
 //模拟网络请求代码
 func dealData(inputText: String) -> Observable<Any>{
    return Observable<Any>.create({ (ob) -> Disposable in
        //模拟发出错误
        if inputText == "1234" {
            ob.onError(NSError(domain: "testError", code: 1001, userInfo: nil))
        }
        //异步发送信号
        DispatchQueue.global().async {
            print("模拟网络请求返回")
            ob.onNext("输入了:\(inputText)")
            ob.onCompleted()
        }
        return Disposables.create()
    })
 }
 
 //创建普通序列
 let result = textField.rx.text.orEmpty.skip(1)
     .flatMap { [weak self] (text) -> Observable<Any> in
         return (self?.dealData(inputText: text))!
         //执行订阅时回到主线程,如果不加,执行订阅时会在子线程
         .observeOn(MainScheduler.instance)
             .catchErrorJustReturn("监测到错误")
 }
     //共享observer序列,防止多次订阅时多次请求网络
     .share(replay: 1, scope: .whileConnected)
 
 result.subscribe(onNext: { (value) in
     print("订阅到:\(value)")
 }).disposed(by: disposebag)
 
 //创建Driver 序列
 //自动共享序列,多次订阅也只请求一次网络
 //绑定到UI,自动回到主线程
 let result2 = textField.rx.text.orEmpty
    .asDriver()
        .flatMap { (text) -> Driver<Any> in
            return self.dealData(inputText: text)
             .asDriver(onErrorJustReturn: "监测到错误")
        }
 result2.map { (text) -> String in
     return "绑定文字到label"
 }.drive(label.rx.text)
 .disposed(by: disposebag)
 
 result2.map{"绑定到button" + ($0 as! String)}
 .drive(button.rx.title())
 .disposed(by: disposebag)
 */
