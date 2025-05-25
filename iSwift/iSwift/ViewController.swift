//
//  ViewController.swift
//  iSwift
//
//  Created by ibabyblue on 2024/5/16.
//

import UIKit
import SwiftUI

struct X {
    //存储属性
    var x : Int = 0
    
    //存储属性-闭包形式
    var y : Int = {
       0
    }()
    
    //存储属性-属性观察器
    var z : Int {
        willSet {
            print(newValue)
        }
        didSet {
            print(oldValue)
        }
    }
    
    //计算属性
    var point : (Int, Int) {
        get {
            (x, y)
        }
        
        set {
            x = newValue.0
            y = newValue.1
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //测试混编
        ISwiftBridging().invokeFoo()
        
        let _ = X(z: 0)
//        //SwiftUI -> 文本
//        let iText = IText()
//        let hostVc = UIHostingController(rootView: iText)
        
        //空页面
        let eView = IEmpty()
        let hostVc = UIHostingController(rootView: eView)
        
        self.addChild(hostVc)
        self.view.addSubview(hostVc.view)
        hostVc.didMove(toParent: self)
        hostVc.view.frame = self.view.frame;
        
        //RxSwiftDemo
//        let idemorxs: IDemoForRxSwift = IDemoForRxSwift()
    }
    
}

