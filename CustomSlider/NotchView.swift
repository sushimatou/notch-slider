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
    private let pointView = UIView ()
    private let valueLabel = UILabel()
    
    init(value: Int, point: CGPoint, radius: Float) {
        self.value = value
        super.init(frame: .zero)
        self.pointView = UIView(frame: CGRect(
            x: <#T##CGFloat#>,
            y: <#T##CGFloat#>,
            width: <#T##CGFloat#>,
            height: <#T##CGFloat#>))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

