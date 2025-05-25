//
//  09-UI.swift
//  iSwift
//
//  Created by ibabyblue on 2025/5/25.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: - UILabel
/*
 RxSwift 是一个用于与 Swift 语言交互的框架，但它只是基础，并不能用来进行用户交互、网络请求等。

 而 RxCocoa 是让 Cocoa APIs 更容易使用响应式编程的一个框架。RxCocoa 能够让我们方便地进行响应式网络请求、响应式的用户交互、绑定数据模型到 UI 控件等等。而且大多数的 UIKit 控件都有响应式扩展，它们都是通过 rx 属性进行使用
 */

class FooLabel {
    let label1: UILabel
    let label2: UILabel
    let disposeBag = DisposeBag()
    
    init(label1: UILabel, label2: UILabel) {
        self.label1 = label1
        self.label2 = label2
    }
    
    func test() {
        //创建一个计时器（每1秒发送一个索引数）
        let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        timer.map{[weak self] _ in self?.transform()}
            .bind(to: label1.rx.text)
            .disposed(by: disposeBag)
        
        //将数据绑定到 attributedText 属性上（富文本）
        timer.map{[weak self] _ in self?.formatTimeInterval(text: (self?.transform())!)}
            .bind(to: label2.rx.attributedText)
            .disposed(by: disposeBag)
    }
    
    func transform() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        return dateFormatter.string(from: Date())
    }
    
    //将数字转成对应的富文本
    func formatTimeInterval(text: String) -> NSMutableAttributedString {
        //富文本设置
        let attributeString = NSMutableAttributedString(string: text)
        //从文本0开始6个字符字体HelveticaNeue-Bold,16号
        attributeString.addAttribute(NSAttributedString.Key.font,
                                     value: UIFont(name: "HelveticaNeue-Bold", size: 16)!,
                                     range: NSMakeRange(0, 10))
        //设置字体颜色
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor,
                                     value: UIColor.white, range: NSMakeRange(0, 10))
        //设置文字背景颜色
        attributeString.addAttribute(NSAttributedString.Key.backgroundColor,
                                     value: UIColor.orange, range: NSMakeRange(0, 10))
        return attributeString
    }
}

//MARK: - UITextField\UITextView
//.orEmpty 可以将 String? 类型的 ControlProperty 转成 String，省得我们再去解包。
struct FooText {
    let acountTF: UITextField
    let textView: UITextView
    let login: UIButton
    
    let disposeBag = DisposeBag()
    
    init(acountTF: UITextField, textView: UITextView, login: UIButton) {
        self.acountTF = acountTF
        self.textView = textView
        self.login = login
    }
    
    func textFieldPrint() {
        //打印输入框内容
        let sub = acountTF.rx.text
        sub.orEmpty
            .subscribe(onNext: {
                print("您输入的是：\($0)")
            })
            .disposed(by: disposeBag)
    }
    
    func textFieldBind() {
        let observable = acountTF.rx.text
        observable.orEmpty.asDriver()
            .throttle(.seconds(1))
            .map({ (text) -> String in
                return "输出：" + text
            })
            .drive(login.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
}

/*
 - 事件监听
 通过 rx.controlEvent 可以监听输入框的各种事件，且多个事件状态可以自由组合。除了各种 UI 控件都有的 touch 事件外，输入框还有如下几个独有的事件：
    - editingDidBegin：开始编辑（开始输入内容）
    - editingChanged：输入内容发生改变
    - editingDidEnd：结束编辑
    - editingDidEndOnExit：按下 return 键结束编辑
    - allEditingEvents：包含前面的所有编辑相关事件
 */
extension FooText {
    func eventObserver() {
        acountTF.rx.controlEvent([.editingDidBegin]) //状态可以组合
            .asObservable()
            .subscribe(onNext: { _ in
                print("开始编辑内容!")
            }).disposed(by: disposeBag)
    }
}

/*
 UITextView 独有的方法
 UITextView 还封装了如下几个委托回调方法：
    - didBeginEditing：开始编辑
    - didEndEditing：结束编辑
    - didChange：编辑内容发生改变
    - didChangeSelection：选中部分发生变化
 */

extension FooText {
    func textViewObserver() {
        //开始编辑响应
        textView.rx.didBeginEditing
            .subscribe(onNext: {
                print("开始编辑")
            })
            .disposed(by: disposeBag)
        
        //结束编辑响应
        textView.rx.didEndEditing
            .subscribe(onNext: {
                print("结束编辑")
            })
            .disposed(by: disposeBag)
        
        //内容发生变化响应
        textView.rx.didChange
            .subscribe(onNext: {
                print("内容发生改变")
            })
            .disposed(by: disposeBag)
        
        //选中部分变化响应
        textView.rx.didChangeSelection
            .subscribe(onNext: {
                print("选中部分发生变化")
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - 登录场景
struct Login {
    let account: UITextField
    let password: UITextField
    let loginButton: UIButton
    
    let disposeBag = DisposeBag()
    
    init(account: UITextField, password: UITextField, loginButton: UIButton) {
        self.account = account
        self.password = password
        self.loginButton = loginButton
    }
    
    func login() {
        //监听输入框内容变化
        let accountValid = account.rx.text.orEmpty.map { $0.count > 6 }
        let passwordValid = password.rx.text.orEmpty.map { $0.count > 6 }
        
        //合并两个输入框的状态
        let everythingValid = Observable.combineLatest(accountValid, passwordValid) { $0 && $1 }
        
        //绑定登录按钮的 enabled 属性
        everythingValid.bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        //设置登录按钮的颜色
        everythingValid.map { $0 ? UIColor.blue : UIColor.gray }
            .bind(to: loginButton.rx.backgroundColor)
            .disposed(by: disposeBag)
    }
}

//MARK: - UIButton
class FooButton : UIViewController {
    var btn: UIButton
    var label: UILabel
    let disposeBag = DisposeBag()
    
    init(button: UIButton, label: UILabel) {
        self.btn = button
        self.label = label
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonPrint() {
        //监听按钮点击事件
        btn.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print("按钮被点击了")
            })
            .disposed(by: disposeBag)
    }
    
    func buttonBind() {
        //将按钮的点击事件绑定到 label 上
        btn.rx.tap
            .map { "按钮被点击了" }
//            .bind(to: label.rx.text )
            .bind(onNext: { [weak self] in
                self?.label.text = $0
            })
            .disposed(by: disposeBag)
    }
    
    //事件绑定
    func buttonEvent1() {
        let btn = btn.rx.tap
        btn.throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.showMessage("点击button")
            })
            .disposed(by: disposeBag)
        
    }
    
    //显示消息提示框
    func showMessage(_ text: String) {
        let alertController = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
    
    //按钮标题（title）的绑定
    func bindTitle() {
        //创建一个计时器（每1秒发送一个索引数）
        let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        //根据索引数拼接最新的标题，并绑定到button上
        timer.map{"计数\($0)"}
            .bind(to: btn.rx.title(for: .normal))
            .disposed(by: disposeBag)
    }
    
    //按钮图标（image）的绑定
    func bindImage() {
        //创建一个计时器（每1秒发送一个索引数）
        let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        
        //根据索引数选择对应的按钮图标，并绑定到button上
        timer.map({
            let name = $0 % 2 == 0 ? "back" : "forward"
            return UIImage(named: name)!
        })
        .bind(to: btn.rx.image())
        .disposed(by: disposeBag)
    }
}

    
