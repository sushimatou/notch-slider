//
//  RangeSlider.swift
//  CustomSlider
//
//  Created by Antoine Lassoujade on 07/02/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

class RangeSlider: UIControl {
    
    // MARK: Range slider thumb layer
    
    private final class RangeSliderThumbLayer: CALayer {
        
        var isHighlighted: Bool = false
        weak var rangeSlider: RangeSlider?
        
    }
    
    // MARK: Properties
    
    private let minimumValue: Int
    private let maximumValue: Int
    private let primaryColor: UIColor
    private let secondaryColor: UIColor
    private let trackLayer = CALayer()
    private let minimumThumbLayer = RangeSliderThumbLayer()
    private let maximumThumbLayer = RangeSliderThumbLayer()
    private var previousLocation = CGPoint()
    
    var thumbHeight: CGFloat {
        return 2
    }
    
    init(minimumValue: Int, maximumValue: Int, primaryColor: UIColor, secondaryColor: UIColor) {
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        super.init(frame: .zero)
        minimumThumbLayer.rangeSlider = self
        maximumThumbLayer.rangeSlider = self
        addSublayers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSublayers() {
        layer.addSublayer(trackLayer)
        layer.addSublayer(minimumThumbLayer)
        layer.addSublayer(maximumThumbLayer)
    }
    
    // MARK: UIControl override methods
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        minimumThumbLayer.isHighlighted = minimumThumbLayer.frame.contains(previousLocation)
        maximumThumbLayer.isHighlighted = maximumThumbLayer.frame.contains(previousLocation)
        return minimumThumbLayer.isHighlighted || maximumThumbLayer.isHighlighted
    }
    
    // UI rendering
    
    private func layout() {
        
    }
    
    private func render() {
        
    }
    
}
