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
    //private var pointView: UIView
//    private var valueLabel: UILabel
    
    init(value: Int, point: CGPoint, radius: Float) {
        self.value = value
        
        super.init(frame: .zero)
//        self.valueLabel.text = "\(value)"
//        addSubview(valueLabel)
//        addSubview(pointView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

