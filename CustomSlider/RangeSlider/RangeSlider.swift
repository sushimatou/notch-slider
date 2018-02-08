//
//  RangeSlider.swift
//  CustomSlider
//
//  Created by Antoine Lassoujade on 07/02/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

protocol RangeSliderDelegate : NSObjectProtocol {
    func valueDidChange()
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
                let minimumPositionValue = slider.position(for: Double(slider.minimumValue))
                let maximumPositionValue = slider.position(for: Double(slider.maximumValue))
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
        addTarget(self, action: #selector(valueDidChanged), for: .valueChanged)
        trackLayer.rangeSlider = self
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
    
    @objc private func valueDidChanged() {
        
    }
    
    // MARK: UIControl override methods
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        minimumThumbLayer.isHighlighted = minimumThumbLayer.frame.contains(previousLocation)
        maximumThumbLayer.isHighlighted = maximumThumbLayer.frame.contains(previousLocation)
        return minimumThumbLayer.isHighlighted || maximumThumbLayer.isHighlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = Double(maximumValue - minimumValue) * deltaLocation / Double(bounds.width - frame.width)
        previousLocation = location
        sendActions(for: .valueChanged)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        minimumThumbLayer.isHighlighted = false
        maximumThumbLayer.isHighlighted = false
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
