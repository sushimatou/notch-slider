//
//  NotchView.swift
//  CustomSlider
//
//  Created by Antoine Lassoujade on 30/01/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

class NotchView: UIView {
    
    let value: Int
    
    init(value: Int, point: CGPoint, radius: Float) {
        self.value = value
        super.init(frame: .zero)
        let pointView: UIView = {
            let view = UIView()
            view.layer.cornerRadius = CGFloat(radius)
            view.clipsToBounds = true
            return view
        }()
        let valueLabel: UILabel = {
            let label = UILabel()
            label.text = "\(value)"
            label.sizeToFit()
            return label
        }()
        addSubview(pointView)
        addSubview(valueLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

