//
//  ViewController.swift
//  SmallViewDemo
//
//  Created by Yu Pengyang on 4/14/16.
//  Copyright © 2016 Caishuo. All rights reserved.
//

import UIKit
import XAutoLayout

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let v = UIView()
        v.backgroundColor = .grayColor()
        let v1 = UIView(), v2 = UIView()
        v1.backgroundColor = .redColor()
        v2.backgroundColor = .greenColor()
        view.addSubview(v)
        v.addSubview(v1)
        v.addSubview(v2)
        v.translatesAutoresizingMaskIntoConstraints = false
        v2.translatesAutoresizingMaskIntoConstraints = false
        v1.translatesAutoresizingMaskIntoConstraints = false
        xmakeConstraints { 
            v.xSize =/ [100, 100]
            v.xCenter =/ self.view.xCenter
            v1.xEdge =/ [10, 10, -10, -10]
            v2.xSize =/ [72, 50]
            v2.xTop =/ v1.xTop
            v2.xLeading =/ v1.xTrailing.m(0.2)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

