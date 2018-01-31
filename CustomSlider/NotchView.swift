//
//  NotchView.swift
//  CustomSlider
//
//  Created by Antoine Lassoujade on 30/01/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

class NotchView: UIView {
    private let value: Int
    private let pointView: UIView
    private var valueLabel: UILabel
    
    init(value: Int, point: CGPoint, radius: Float) {
        self.value = value
        self.pointView = UIView(frame: CGRect(
            x: self.frame.midX,
            y: 0,
            width: CGFloat(radius),
            height: CGFloat(radius)))
        self.valueLabel.text = "\(value)"
        addSubview(valueLabel)
        addSubview(pointView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

