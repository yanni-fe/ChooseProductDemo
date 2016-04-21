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

    @IBOutlet weak var v1: UIView!
    @IBOutlet weak var v2: UIView!
    
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    
    typealias Product = (period: Int, multi: Int)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let a: [Product] = [(7, 1), (7, 2), (30, 1), (30, 3)]
        products = a.reduce([[String: String]](), combine: { (r, p) in
            var ret = [String: String]()
            ret["period"] = "\(p.period)"
            ret["multi"] = "\(p.multi)"
            return r + [ret]
        })
        createView(products)
    }
    var products = [[String: String]]()     // [[category: element]]
    var categories = [String: [String]]() // 每个category包含的选项 [category: [element]]
    var selected = [String: String]()  // [category: element]
    var base: [String: [String: MyView]] = [:]
    
    func createView(p: [[String: String]]) {
        let pair = ["period": v1, "multi": v2]
        p.forEach { product in
            product.forEach { (key, value) in
                categories[key] = categories[key].flatMap { $0.contains(value) ? $0 : $0 + [value] } ?? [value]
            }
        }
        
        categories.forEach { (category, elements) in
            guard let containerView = pair[category] else { return }
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(view)
            view.centerXAnchor.constraintLessThanOrEqualToAnchor(containerView.centerXAnchor).active = true
            view.centerYAnchor.constraintLessThanOrEqualToAnchor(containerView.centerYAnchor).active = true
            var views = [UIView]()
            elements.sort { _, _ in true/* TODO: */ }.forEach { element in
                let v = createElementView(category, element: element)
                views.append(v)
                view.addSubview(v)
                if let _ = base[category] {
                    base[category]![element] = v
                } else {
                    base[category] = [element: v]
                }
            }
            layout(views)
        }
    }
    
    private func createElementView(category: String, element: String) -> MyView {
        let view = MyView()
        view.addTarget(self, action: #selector(onTap(_:)), forControlEvents: .TouchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.category = category
        view.element = element
        view.setTitle(element, forState: .Normal)
        view.setBackgroundImage(createBackgroundImage(UIColor.greenColor(), corners: [], cornerRadius: 0), forState: .Normal)
        view.setBackgroundImage(createBackgroundImage(UIColor.redColor(), corners: [], cornerRadius: 0), forState: .Selected)
        view.setBackgroundImage(createBackgroundImage(UIColor.grayColor(), corners: [], cornerRadius: 0), forState: .Disabled)
        return view
    }

    private func layout(views: [UIView]) {
        guard views.count > 0 else { return }
        var pre = views[0]
        NSLayoutConstraint.fromVisualFormat("V:|-0-[pre(44)]-0-|", views: ["pre": pre]).forEach { $0.active = true }
        NSLayoutConstraint.fromVisualFormat("H:|-0-[pre(60)]", views: ["pre": pre]).forEach { $0.active = true }
        for i in 1..<views.count {
            let v = views[i]
            v.heightAnchor.constraintEqualToAnchor(pre.heightAnchor, multiplier: 1).active = true
            v.centerYAnchor.constraintEqualToAnchor(pre.centerYAnchor).active = true
            NSLayoutConstraint.fromVisualFormat("H:[pre]-12-[v(60)]", views: ["pre": pre, "v": v]).forEach { $0.active = true }
            pre = v
        }
        NSLayoutConstraint.fromVisualFormat("H:[pre]-0-|", views: ["pre": pre]).forEach { $0.active = true }
    }
    
    @objc private func onTap(sender: MyView) {
        let category = sender.category
        let element = sender.element
        if let ele = selected[category] {
            if ele == element {
                selected[category] = nil
                selected.removeValueForKey(category)
            } else {
                base[category]?[element]?.selected = true
                selected[category] = element
            }
            base[category]?[ele]?.selected = false
        } else {
            selected[category] = element
            base[category]?[element]?.selected = true
        }
        selectedChanged()
    }
    
    private func selectedChanged() {
        // 1. 改变类别element的状态
        base.forEach { category, value in
            var elements = [String]()
            products.forEach { p in
                for (scategory, selement) in selected {
                    guard scategory != category else { continue }
                    if p[scategory] != selement {
                        return
                    }
                }
                elements.append(p[category]!)
            }
            
            value.forEach { element, view in
                if elements.contains(element) {
                    view.enabled = true
                } else {
                    view.enabled = false
                }
            }
        }
        // 2. 底部button状态
        
    }
}
extension NSLayoutConstraint {
    class func fromVisualFormat(format: String, views: [String: AnyObject]) -> [NSLayoutConstraint] {
        return constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
    }
}

func createBackgroundImage(color: UIColor, corners: UIRectCorner, cornerRadius r: CGFloat) -> UIImage {
    let rect = CGRectMake(0, 0, r * 2 + 1, r * 2 + 1)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
    let ctx = UIGraphicsGetCurrentContext()
    UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSizeMake(r, r)).addClip()
    CGContextSetFillColorWithColor(ctx, color.CGColor)
    CGContextFillRect(ctx, rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image.resizableImageWithCapInsets(UIEdgeInsets(top: r, left: r, bottom: r, right: r))
}

class MyView: UIButton {
    var category: String = ""
    var element: String = ""
}

