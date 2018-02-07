//
//  RangeSlider.swift
//  CustomSlider
//
//  Created by Antoine Lassoujade on 07/02/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

class RangeSlider: UIControl {
    
    private final class RangeSliderThumbLayer {
        
        var isHighlighted: Bool = false
        weak var rangeSlider: RangeSlider?
        
    }
    
    // MARK: Properties
    
    let minimumValue: Int
    let maximumValue: Int
    let primaryColor: UIColor
    let secondaryColor: UIColor
    let trackLayer = CALayer()
    let minimumThumbLayer = CALayer()
    let maximulThumbLayer = CALayer()
    
    var thumbHeight: CGFloat {
        return 2
    }
    
    init(minimumValue: Int, maximumValue: Int, primaryColor: UIColor, secondaryColor: UIColor) {
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        super.init(frame: .zero)
        addSublayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSublayers() {
        layer.addSublayer(trackLayer)
        layer.addSublayer(minimumThumbLayer)
        layer.addSublayer(maximulThumbLayer)
    }
    
    // UI rendering
    
    private func layout() {
        
    }
    
    private func render() {
        
    }
    
    
    
    
    
//    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//
//    }
//
//    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
//
//    }

}
