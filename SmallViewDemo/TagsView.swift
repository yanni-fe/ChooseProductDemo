//
//  TagsView.swift
//  SmallViewDemo
//
//  Created by Yu Pengyang on 4/14/16.
//  Copyright © 2016 Caishuo. All rights reserved.
//

import UIKit

class TagsView: UIView {
    var tags: [String] = [] {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    init(tags: [String] = []) {
        self.tags = tags
        super.init(frame: CGRectZero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func intrinsicContentSize() -> CGSize {
        if tags.count == 0 {
            return CGSize(width: UIViewNoIntrinsicMetric, height: UIViewNoIntrinsicMetric)
        }
        return CGSize(width: 100, height: 20)
    }
}
