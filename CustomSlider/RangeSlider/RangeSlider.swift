//
//  RangeSlider.swift
//  CustomSlider
//
//  Created by Antoine Lassoujade on 07/02/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

protocol RangeSliderDelegate : NSObjectProtocol {
    func valuesDidChanged(values: (lowerValue: Double, upperValue: Double))
}

class RangeSlider: UIControl {
    
    // MARK: Range slider thumb layer
    
    private final class RangeSliderThumbLayer: CALayer {
        weak var rangeSlider: RangeSlider?
        var isHighlighted: Bool = false {
            didSet{
                setNeedsDisplay()
            }
        }
        
        override func draw(in ctx: CGContext) {
            let thumbRect = bounds.insetBy(dx: 2.0, dy: 2.0)
            let cornerRadius = thumbRect.height / 2.0
            let thumbPath = UIBezierPath(roundedRect: thumbRect, cornerRadius: cornerRadius)
            let shadowColor = UIColor.gray
            ctx.setShadow(offset: CGSize(width: 0, height: 1) , blur: 1.0, color: shadowColor.cgColor)
            ctx.setFillColor(UIColor.white.cgColor)
            ctx.addPath(thumbPath.cgPath)
            ctx.fillPath()
        }
    }
    
    // MARK: Range slider track layer
    
    private final class RangeSliderTrackLayer: CALayer {
        weak var rangeSlider: RangeSlider?
        override func draw(in ctx: CGContext) {
            if let slider = rangeSlider {
                let path = UIBezierPath(roundedRect: bounds, cornerRadius: 0)
                ctx.addPath(path.cgPath)
                
                // track
                ctx.setFillColor(UIColor.gray.cgColor)
                ctx.addPath(path.cgPath)
                ctx.fillPath()
                
                // highlighted track
                ctx.setFillColor(UIColor.blue.cgColor)
                let minimumPositionValue = slider.position(for: Double(slider.lowerValue))
                let maximumPositionValue = slider.position(for: Double(slider.upperValue))
                let rect = CGRect(
                    x: minimumPositionValue,
                    y: maximumPositionValue,
                    width: maximumPositionValue - minimumPositionValue,
                    height: Double(bounds.height))
                ctx.fill(rect)
            }
        }
    }
    
    // MARK: Properties
    
    private let minimumValue: Int
    private let maximumValue: Int
    private let primaryColor: UIColor
    private let secondaryColor: UIColor
    private let trackLayer = RangeSliderTrackLayer()
    private let lowerThumbLayer = RangeSliderThumbLayer()
    private let upperThumbLayer = RangeSliderThumbLayer()
    private var previousLocation = CGPoint()
    private var lowerValue: Double = 0.2 {
        didSet {
            updateLayerFrames()
        }
    }
    
    private var upperValue: Double = 0.8 {
        didSet {
            updateLayerFrames()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width, height: 50)
    }
    
    var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    init(minimumValue: Int, maximumValue: Int, primaryColor: UIColor, secondaryColor: UIColor) {
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        addTarget(self, action: #selector(valueDidChanged), for: .valueChanged)
        trackLayer.backgroundColor = UIColor.blue.cgColor
        trackLayer.rangeSlider = self
        layer.addSublayer(trackLayer)
        lowerThumbLayer.backgroundColor = UIColor.green.cgColor
        lowerThumbLayer.rangeSlider = self
        layer.addSublayer(lowerThumbLayer)
        upperThumbLayer.backgroundColor = UIColor.green.cgColor
        upperThumbLayer.rangeSlider = self
        layer.addSublayer(upperThumbLayer)
        addSublayers()
        updateLayerFrames()
        layer.backgroundColor = UIColor.black.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSublayers() {
        layer.addSublayer(trackLayer)
        layer.addSublayer(lowerThumbLayer)
        layer.addSublayer(upperThumbLayer)
    }
    
    @objc private func valueDidChanged() {
        
    }
    
    // MARK: UIControl override methods
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        lowerThumbLayer.isHighlighted = lowerThumbLayer.frame.contains(previousLocation)
        upperThumbLayer.isHighlighted = upperThumbLayer.frame.contains(previousLocation)
        return lowerThumbLayer.isHighlighted || upperThumbLayer.isHighlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = Double(maximumValue - minimumValue) * deltaLocation / Double(bounds.width - frame.width)
        previousLocation = location
        
        updateLayerFrames()
        sendActions(for: .valueChanged)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.isHighlighted = false
        upperThumbLayer.isHighlighted = false
    }
    
    private func updateLayerFrames() {
        let lowerThumbCenter = CGFloat(position(for: lowerValue))
        let upperThumbCenter = CGFloat(position(for: upperValue))
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        lowerThumbLayer.frame = CGRect(
            x: lowerThumbCenter - thumbWidth / 2,
            y: 0.0,
            width: thumbWidth,
            height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        upperThumbLayer.frame = CGRect(
            x: upperThumbCenter - thumbWidth / 2,
            y: 0.0,
            width: thumbWidth,
            height: thumbWidth)
        CATransaction.commit()
    }
    
    private func position(for value: Double) -> Double {
        return Double(bounds.width) * value - Double(minimumValue) / Double(maximumValue - minimumValue)
    }
    
    // UI rendering
    
    private func layout() {
        
    }
    
    private func render() {
        
    }
    
}
