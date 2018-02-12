//
//  PriceRangeSlider.swift
//  CustomSlider
//
//  Created by Antoine Lassoujade on 09/02/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

protocol RangeSliderDelegate : NSObjectProtocol {
    func valuesDidChanged(values: (lowerValue: Double, upperValue: Double))
}

class RangeSlider: UIControl {
    
    // MARK: Track Layer declaration
    
    private final class RangeSliderTrackLayer: CALayer {
        weak var rangeSlider: RangeSlider?
        
        override func draw(in ctx: CGContext) {
            if let slider = rangeSlider {
                let lowerPositionValue = CGFloat(slider.position(for: slider.lowerValue))
                let upperPositionValue = CGFloat(slider.position(for: slider.upperValue))
                let rect = CGRect(
                    x: lowerPositionValue,
                    y: 0.0,
                    width: upperPositionValue - lowerPositionValue,
                    height: bounds.height)
                
                // clip
                let cornerRadius = bounds.height * slider.curvaceousness / 2.0
                let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
                ctx.addPath(path.cgPath)
                
                // track
                ctx.setFillColor(slider.trackTintColor.cgColor)
                ctx.addPath(path.cgPath)
                ctx.fillPath()
                
                //highlight
                ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
                ctx.fill(rect)
            }
        }
        
    }
    
    // MARK: Thumb Layer declaration
    
    private final class RangeSliderThumbLayer: CALayer {
        var isHighlighted = false
        weak var rangeSlider: RangeSlider?
        
        override func draw(in ctx: CGContext) {
            if let slider = rangeSlider {
                let thumbFrame = bounds.insetBy(dx: 5, dy: 5)
                let cornerRadius = thumbFrame.height * slider.curvaceousness / 2.0
                let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)
                let shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.2).cgColor
                ctx.setShadow(offset: CGSize(width: 0, height: 2) , blur: 4, color: shadowColor)
                ctx.setFillColor(slider.thumbTintColor.cgColor)
                ctx.addPath(thumbPath.cgPath)
                ctx.fillPath()
            }
        }
        
    }

    // Properties
    
    private let trackLayer = RangeSliderTrackLayer()
    private let lowerThumbLayer = RangeSliderThumbLayer()
    private let upperThumbLayer = RangeSliderThumbLayer()
    private let minimumValueLabel = UILabel()
    private let maximumValueLabel = UILabel()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: CGFloat(bounds.width), height: 30)
    }
    
    var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    var minimumValue: Double = 0.0 {
        didSet {
            minimumValueLabel.text = String(describing: minimumValue)
        }
    }
    
    var maximumValue: Double = 1.0 {
        didSet {
            maximumValueLabel.text = String(describing: maximumValue)
        }
    }
    
    weak var delegate: RangeSliderDelegate?

    var trackTintColor = UIColor(white: 0.9, alpha: 1.0)
    var trackHighlightTintColor = UIColor.blue
    var thumbTintColor = UIColor.white
    var curvaceousness: CGFloat = 1.0
    var previousLocation = CGPoint()
    var lowerValue = 0.2
    var upperValue = 0.8
    
    // MARK: Range slider initialization
    
    init() {
        super.init(frame: .zero)
        addSublayers()
        updateLayerFrames()
        clipsToBounds = false
        delegate?.valuesDidChanged(values: (lowerValue: lowerValue, upperValue: upperValue))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        updateLayerFrames()
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
        if lowerThumbLayer.isHighlighted && location.x < upperThumbLayer.position.x - thumbWidth {
            lowerValue += deltaValue
            lowerValue = boundValue(value: lowerValue, to: minimumValue, upperValue: upperValue)
        } else if upperThumbLayer.isHighlighted && location.x > lowerThumbLayer.position.x + thumbWidth {
            upperValue += deltaValue
            upperValue = boundValue(value: upperValue, to: lowerValue, upperValue: maximumValue)
        }
        previousLocation = location
        updateLayerFrames()
        sendActions(for: .valueChanged)
        delegate?.valuesDidChanged(values: (lowerValue: lowerValue, upperValue: upperValue))
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.isHighlighted = false
        upperThumbLayer.isHighlighted = false
    }
    
    // MARK: Layers treatment
    
    func addSublayers() {
        trackLayer.rangeSlider = self
        lowerThumbLayer.rangeSlider = self
        upperThumbLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        lowerThumbLayer.contentsScale = UIScreen.main.scale
        upperThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        layer.addSublayer(lowerThumbLayer)
        layer.addSublayer(upperThumbLayer)
    }
    
    func updateLayerFrames() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        let lowerThumbCenter = CGFloat(position(for: lowerValue))
        let upperThumbCenter = CGFloat(position(for: upperValue))
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height/2.1)
        trackLayer.setNeedsDisplay()
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
        CATransaction.commit()
    }
    
    fileprivate func position(for value: Double) -> Double {
        return Double(bounds.width - thumbWidth) * (value - minimumValue) / (maximumValue - minimumValue) + Double(thumbWidth / 2.0)
    }
    
    fileprivate func boundValue(value: Double, to lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }

}

