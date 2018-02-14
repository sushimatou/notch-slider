//
//  PriceRangeSlider.swift
//  CustomSlider
//
//  Created by Antoine Lassoujade on 09/02/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

// MARK: Delegate

protocol RangeSliderDelegate : NSObjectProtocol {
    func valuesDidChanged(values: RangeSlider.RangeSliderValues)
}

class RangeSlider: UIControl {
    
    // MARK: Range slider values
    
    // struct used for range slider delegate
    
    public struct RangeSliderValues {
        var lowerValue: Double
        var upperValue: Double
    }
    
    // MARK: Track Layer
    
    private final class TrackLayer: CALayer {
        
        // MARK: Properties
        
        weak var rangeSlider: RangeSlider?
        
        // MARK: Layer drawing
        
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
    
    // MARK: Thumb Layer
    
    private final class ThumbLayer: CAShapeLayer {
        
        // MARK: Properties
        
        var isHighlighted = false
        weak var rangeSlider: RangeSlider?

        // MARK: Layer drawing
        
        override func draw(in ctx: CGContext) {
            if let slider = rangeSlider {
                let cornerRadius = slider.thumbWidth / 2
                let thumbFrame = CGRect(x: bounds.midX - slider.thumbWidth / 2, y: bounds.midY - slider.thumbWidth / 2, width: slider.thumbWidth, height: slider.thumbWidth)
                let thumbPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)
                let borderPath = UIBezierPath(roundedRect: thumbFrame, cornerRadius: cornerRadius)
                borderPath.lineWidth = 1
                borderPath.stroke()
                ctx.setShadow(offset: CGSize(width: 0, height: 2), blur: 5, color: UIColor(red:0, green:0, blue:0, alpha:0.25).cgColor)
                ctx.addPath(thumbPath.cgPath)
                ctx.setFillColor(slider.thumbTintColor.cgColor)
                ctx.fillPath()
                borderPath.lineWidth = 10
            }
        }
        
        override init() {
            super.init()
            
            let shadowLayer = CAShapeLayer()
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowOffset = CGSize(width: 0, height: 4)
            shadowLayer.shadowRadius = 2
            shadowLayer.bounds = bounds
            addSublayer(shadowLayer)
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }

    // MARK: Properties
    
    private let trackLayer = TrackLayer()
    private let lowerThumbLayer = ThumbLayer()
    private let upperThumbLayer = ThumbLayer()
    private let minimumValueLabel = UILabel()
    private let maximumValueLabel = UILabel()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: CGFloat(bounds.width), height: 40)
    }
    
    var thumbWidth: CGFloat {
        return CGFloat(29)
    }
    
    weak var delegate: RangeSliderDelegate?

    var trackTintColor = UIColor(white: 0.9, alpha: 1.0)
    var trackHighlightTintColor = UIColor.blue
    var thumbTintColor = UIColor.white
    var previousLocation = CGPoint()
    var lowerValue: Double = 0.2
    var upperValue: Double = 0.8
    var minimumValue: Double = 0.0
    var maximumValue: Double = 1.0
    var minimumGapValue: Double = 0.2
    var curvaceousness: CGFloat = 1.0
    
    // MARK: Range slider initialization
    
    init() {
        super.init(frame: .zero)
        addSublayers()
        render()
        updateLayerFrames()
        delegate?.valuesDidChanged(values: RangeSlider.RangeSliderValues(
            lowerValue: lowerValue,
            upperValue: upperValue
        ))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        updateLayerFrames()
    }
    
    // MARK: UIControl touch tracking
    
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
            lowerValue = boundValue(value: lowerValue, to: minimumValue, upperValue: upperValue - minimumGapValue)
        } else if upperThumbLayer.isHighlighted {
            upperValue += deltaValue
            upperValue = boundValue(value: upperValue, to: lowerValue + minimumGapValue, upperValue: maximumValue)
        }
        previousLocation = location
        updateLayerFrames()
        sendActions(for: .valueChanged)
        delegate?.valuesDidChanged(values: RangeSlider.RangeSliderValues(lowerValue: lowerValue, upperValue: upperValue))
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.isHighlighted = false
        upperThumbLayer.isHighlighted = false
    }
    
    // MARK: Render
    
    private func render() {
        valueLabelStyle(minimumValueLabel)
        valueLabelStyle(maximumValueLabel)
    }
    
    // MARK: Layer methods
    
    private func addSublayers() {
        trackLayer.rangeSlider = self
        lowerThumbLayer.rangeSlider = self
        upperThumbLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        lowerThumbLayer.contentsScale = UIScreen.main.scale
        upperThumbLayer.contentsScale = UIScreen.main.scale
        lowerThumbLayer.cornerRadius = 29 / 2
        layer.addSublayer(trackLayer)
        layer.addSublayer(lowerThumbLayer)
        layer.addSublayer(upperThumbLayer)
    }
    
    private func updateLayerFrames() {
        let lowerThumbCenter = CGFloat(position(for: lowerValue))
        let upperThumbCenter = CGFloat(position(for: upperValue))
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height/2.1)
        trackLayer.setNeedsDisplay()
        lowerThumbLayer.frame = CGRect(
            x: lowerThumbCenter - thumbWidth / 2,
            y: 0.0,
            width: frame.height,
            height: frame.height)
        upperThumbLayer.frame = CGRect(
            x: upperThumbCenter - thumbWidth / 2,
            y: 0.0,
            width: frame.height,
            height: frame.height)
        lowerThumbLayer.setNeedsDisplay()
        upperThumbLayer.setNeedsDisplay()
        CATransaction.commit()
    }
    
    // MARK: Styles
    
    private func valueLabelStyle(_ valueLabel: UILabel) {
        valueLabel.tintColor = .gray
    }
    
    // MARK: Value conversion methods
    
    fileprivate func position(for value: Double) -> Double {
        return Double(bounds.width - thumbWidth) * (value - minimumValue) / (maximumValue - minimumValue) + Double(thumbWidth / 2.0)
    }
    
    fileprivate func boundValue(value: Double, to lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }

}
