//
//  PriceRangeSlider.swift
//  CustomSlider
//
//  Created by Antoine Lassoujade on 09/02/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit
import QuartzCore

class RangeSlider: UIControl {

    // Properties
    
    let trackLayer = CALayer()
    let lowerThumbLayer = RangeSliderThumbLayer()
    let upperThumbLayer = RangeSliderThumbLayer()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: CGFloat(bounds.width), height: 30)
    }
    
    override func layoutSubviews() {
        updateLayerFrames()
    }
    
    var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    var previousLocation = CGPoint()
    var minimumValue: Double = 0.0
    var maximumValue: Double = 1.0
    var lowerValue: Double = 0.2
    var upperValue = 0.8
    
    // MARK: Range Slider Initialization
    
    init(){
        super.init(frame: .zero)
        addSublayers()
        updateLayerFrames()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override tracking UIControls methods
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        lowerThumbLayer.isHighlighted = lowerThumbLayer.frame.contains(previousLocation)
        upperThumbLayer.isHighlighted = upperThumbLayer.frame.contains(previousLocation)
        return lowerThumbLayer.isHighlighted || upperThumbLayer.isHighlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - thumbWidth)
        if lowerThumbLayer.isHighlighted {
            lowerValue += deltaValue
            lowerValue = boundValue(value: lowerValue, to: minimumValue, upperValue: upperValue)
        } else if upperThumbLayer.isHighlighted {
            upperValue += deltaValue
            upperValue = boundValue(value: upperValue, to: lowerValue, upperValue: maximumValue)
        }
        previousLocation = location
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        updateLayerFrames()
        CATransaction.commit()
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        // todo
    }
    
    func addSublayers() {
        trackLayer.backgroundColor = UIColor.blue.cgColor
        layer.addSublayer(trackLayer)
        lowerThumbLayer.backgroundColor = UIColor.green.cgColor
        lowerThumbLayer.rangeSlider = self
        layer.addSublayer(lowerThumbLayer)
        upperThumbLayer.backgroundColor = UIColor.green.cgColor
        upperThumbLayer.rangeSlider = self
        layer.addSublayer(upperThumbLayer)
    }
    
    func updateLayerFrames() {
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height/3)
        trackLayer.setNeedsDisplay()
        let lowerThumbCenter = CGFloat(position(for: lowerValue))
        let upperThumbCenter = CGFloat(position(for: upperValue))
        lowerThumbLayer.frame = CGRect(
            x: lowerThumbCenter - thumbWidth / 2,
            y: 0.0,
            width: thumbWidth,
            height: thumbWidth)
        upperThumbLayer.frame = CGRect(
            x: upperThumbCenter - thumbWidth / 2,
            y: 0.0,
            width: thumbWidth,
            height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        upperThumbLayer.setNeedsDisplay()
    }
    
    func position(for value: Double) -> Double {
        return Double(bounds.width - thumbWidth) * (value - minimumValue) / (maximumValue - minimumValue) + Double(thumbWidth / 2.0)
    }
    
    func boundValue(value: Double, to lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }

}

class RangeSliderThumbLayer: CALayer {
    var isHighlighted = false
    weak var rangeSlider: RangeSlider?
}
