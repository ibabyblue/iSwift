//
//  10-Event.swift
//  iSwift
//
//  Created by ibabyblue on 2025/5/25.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: - 接收target Action事件
/*
 传统方法:
 button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

 func buttonTapped() {
    print("button Tapped")
 }
 
 通过rx实现:
 button.rx.tap
 .subscribe(onNext: {
    print("button Tapped")
 })
 .disposed(by: disposeBag)
 */

//MARK: - 接收代理事件
/*
 传统方法:
 class ViewController: UIViewController {
 ...
 override func viewDidLoad() {
    super.viewDidLoad()
    scrollView.delegate = self
 }
 }

 extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("contentOffset: \(scrollView.contentOffset)")
    }
 }
 
 通过rx实现:
 class ViewController: UIViewController {
 ...
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.rx.contentOffset
        .subscribe(onNext: { contentOffset in
            print("contentOffset: \(contentOffset)")
        })
        .disposed(by: disposeBag)
    }
 }
 */

//MARK: - 接收通知事件
/*
 传统方法:
 var ntfObserver: NSObjectProtocol!
 override func viewDidLoad() {
     super.viewDidLoad()

     ntfObserver = NotificationCenter.default.addObserver(
     forName: .UIApplicationWillEnterForeground,
     object: nil, queue: nil) { (notification) in
        print("Application Will Enter Foreground")
     }
 }

 deinit {
     NotificationCenter.default.removeObserver(ntfObserver)
 }
 
 通过 Rx 来实现：
 override func viewDidLoad() {
    super.viewDidLoad()

     NotificationCenter.default.rx
     .notification(.UIApplicationWillEnterForeground)
     .subscribe(onNext: { (notification) in
        print("Application Will Enter Foreground")
     })
     .disposed(by: disposeBag)
 }
 */

//MARK: - KVO
/*
 传统实现方法：
 private var observerContext = 0

 override func viewDidLoad() {
     super.viewDidLoad()
     user.addObserver(self, forKeyPath: #keyPath(User.name), options: [.new, .initial], context: &observerContext)
 }

 override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
     if context == &observerContext {
     let newValue = change?[.newKey] as? String
        print("do something with newValue")
     } else {
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
     }
 }

 deinit {
    user.removeObserver(self, forKeyPath: #keyPath(User.name))
 }
 
 通过 Rx 来实现：
 override func viewDidLoad() {
    super.viewDidLoad()

     user.rx.observe(String.self, #keyPath(User.name))
     .subscribe(onNext: { newValue in
        print("do something with newValue")
     })
     .disposed(by: disposeBag)
 }
 */

//MARK: - 多个任务之间有依赖关系
/*
 传统实现方法:

 /// 用回调的方式封装接口
 enum Api {
    /// 通过用户名密码取得一个 token
    static func token(username: String, password: String,
    success: (String) -> Void,
    failure: (Error) -> Void) { ... }
 
    /// 通过 token 取得用户信息
    static func userinfo(token: String,
    success: (UserInfo) -> Void,
    failure: (Error) -> Void) { ... }
 }
 
 /// 通过用户名和密码获取用户信息
 Api.token(username: "beeth0ven", password: "987654321",
 success: { token in
     Api.userInfo(token: token,
     success: { userInfo in
        print("获取用户信息成功: \(userInfo)")
     },
     failure: { error in
        print("获取用户信息失败: \(error)")
     })
 },
 failure: { error in
    print("获取用户信息失败: \(error)")
 })
 
 通过 Rx 来实现：
 // 用 Rx 封装接口
 enum Api {
    /// 通过用户名密码取得一个 token
    static func token(username: String, password: String) -> Observable<String> { ... }

    /// 通过 token 取得用户信息
    static func userInfo(token: String) -> Observable<UserInfo> { ... }
 }

 /// 通过用户名和密码获取用户信息
 Api.token(username: "beeth0ven", password: "987654321")
 .flatMapLatest(Api.userInfo)
 .subscribe(onNext: { userInfo in
    print("获取用户信息成功: \(userInfo)")
 }, onError: { error in
    print("获取用户信息失败: \(error)")
 })
 .disposed(by: disposeBag)
 */

//MARK: - 等待多个并发任务完成后处理结果
/*
 例如，需要将两个网络请求合并成一个，

 通过 Rx 来实现：
 /// 用 Rx 封装接口
 enum Api {
    /// 取得老师的详细信息
    static func teacher(teacherId: Int) -> Observable<Teacher> { ... }

    /// 取得老师的评论
    static func teacherComments(teacherId: Int) -> Observable<[Comment]> { ... }
 }
 
 /// 同时取得老师信息和老师评论
 Observable.zip(
    Api.teacher(teacherId: teacherId),
    Api.teacherComments(teacherId: teacherId)
 ).subscribe(onNext: { (teacher, comments) in
    print("获取老师信息成功: \(teacher)")
    print("获取老师评论成功: \(comments.count) 条")
 }, onError: { error in
    print("获取老师信息或评论失败: \(error)")
 })
 .disposed(by: disposeBag)
 */


    

