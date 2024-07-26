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
        
        let x = X(z: 0)
        
        let iText = IText()
        let hostVc = UIHostingController(rootView: iText)
        
        self.addChild(hostVc)
        self.view.addSubview(hostVc.view)
        hostVc.didMove(toParent: self)
        
        hostVc.view.frame = self.view.frame;
        
    }
    
}

