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
    func valuesDidSet(values: RangeSlider.RangeSliderValues)
}

class RangeSlider: UIControl {
    
    // MARK: Range slider values
    
    struct RangeSliderValues {
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
    
    private final class ThumbView: UIView {
        
        // MARK: Properties

        var isHighlighted = false
        weak var rangeSlider: RangeSlider?
        
    }

    // MARK: Properties

    private let impactGenerator = UIImpactFeedbackGenerator(style: .light)
    private let trackLayer = TrackLayer()
    private let lowerThumbView = ThumbView()
    private let upperThumbView = ThumbView()
    private let minimumValueLabel = UILabel()
    private let maximumValueLabel = UILabel()
    private var previousLocation = CGPoint()
    private var isAbledToImpact = false
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: CGFloat(bounds.width), height: 40)
    }
    
    var thumbWidth: CGFloat {
        return CGFloat(29)
    }
    
    weak var delegate: RangeSliderDelegate?

    var trackTintColor: UIColor = UIColor(white: 0.9, alpha: 1.0)
    var trackHighlightTintColor: UIColor = UIColor.blue
    var thumbTintColor: UIColor = UIColor.white
    var lowerValue: Double = 0.2
    var upperValue: Double = 0.8
    var minimumValue: Double = 0.0
    var maximumValue: Double = 1.0
    var curvaceousness: CGFloat = 1.0
    
    // MARK: Range slider initialization
    
    init() {
        super.init(frame: .zero)
        createTrack()
        createThumbs()
        render()
        updateLayerFrames()
        delegate?.valuesDidChanged(
            values: RangeSlider.RangeSliderValues(
                lowerValue: lowerValue,
                upperValue: upperValue
            )
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        updateLayerFrames()
    }
    
    // MARK: UIControl touch tracking
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        impactGenerator.prepare()
        isAbledToImpact = true
        previousLocation = touch.location(in: self)
        lowerThumbView.isHighlighted = lowerThumbView.frame.contains(previousLocation)
        upperThumbView.isHighlighted = upperThumbView.frame.contains(previousLocation)
        return lowerThumbView.isHighlighted || upperThumbView.isHighlighted
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.preciseLocation(in: self)
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - thumbWidth)
        let thumbValue = Double(thumbWidth * bounds.width - thumbWidth) / maximumValue - minimumValue
        
        if lowerThumbView.isHighlighted {
            lowerValue += deltaValue
            lowerValue = boundValue(
                value: lowerValue,
                toLowerValue: minimumValue,
                toUpperValue: upperValue - thumbValue
            )

        } else if upperThumbView.isHighlighted {
            upperValue += deltaValue
            upperValue = boundValue(
                value: upperValue,
                toLowerValue: lowerValue + thumbValue,
                toUpperValue: maximumValue
            )
        }
        
        if isAbledToImpact && (upperValue == maximumValue || lowerValue == minimumValue) {
            impactGenerator.impactOccurred()
            isAbledToImpact = false
        }
        
        delegate?.valuesDidChanged(values: RangeSlider.RangeSliderValues(
            lowerValue: lowerValue,
            upperValue: upperValue
            )
        )
        
        previousLocation = location
        updateLayerFrames()
        sendActions(for: .valueChanged)
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbView.isHighlighted = false
        upperThumbView.isHighlighted = false
    }
    
    internal func setValues(lowerValue: Double, upperValue: Double) {
        self.lowerValue = lowerValue
        self.upperValue = upperValue
    }
    
    // MARK: Layer methods
    
    private func createTrack() {
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
    }
    
    private func createThumbs() {
        lowerThumbView.rangeSlider = self
        upperThumbView.rangeSlider = self
        addSubview(lowerThumbView)
        addSubview(upperThumbView)
    }
    
    private func updateLayerFrames() {
        let lowerThumbCenter = CGFloat(position(for: lowerValue))
        let upperThumbCenter = CGFloat(position(for: upperValue))
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height/2.1)
        trackLayer.setNeedsDisplay()
        
        lowerThumbView.frame = CGRect(
            x: lowerThumbCenter - thumbWidth / 2,
            y: trackLayer.frame.midY - thumbWidth / 2,
            width: thumbWidth,
            height: thumbWidth
        )
        
        upperThumbView.frame = CGRect(
            x: upperThumbCenter - thumbWidth / 2,
            y: trackLayer.frame.midY - thumbWidth / 2,
            width: thumbWidth,
            height: thumbWidth
        )
    }
    
    // MARK: Position - value conversion methods
    
    fileprivate func position(for value: Double) -> Double {
        return Double(bounds.width - thumbWidth) * (value - minimumValue) / (maximumValue - minimumValue) + Double(thumbWidth / 2.0)
    }
    
    fileprivate func boundValue(value: Double, toLowerValue: Double, toUpperValue: Double) -> Double {
        return min(max(value, toLowerValue), toUpperValue)
    }
    
    // MARK: UI rendering
    
    private func render() {
        thumbLayerStyle(lowerThumbView)
        thumbLayerStyle(upperThumbView)
    }
    
    // MARK: Styles
    
    private func thumbLayerStyle(_ thumbView: ThumbView) {
        
        let frame = CGRect(origin: thumbView.frame.origin, size: CGSize(width: thumbWidth, height: thumbWidth))
        
        // Shadows
        
        let strongShadow: UIView = {
            let view = UIView(frame: frame)
            view.backgroundColor = .white
            view.layer.cornerRadius = thumbWidth / 2
            view.layer.shadowOffset = CGSize(width: 0, height: 3)
            view.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.125).cgColor
            view.layer.shadowOpacity = 1
            view.layer.shadowRadius = 8
            return view
        }()
        
        let shadow: UIView = {
            let view = UIView(frame: frame)
            view.backgroundColor = .white
            view.layer.cornerRadius = thumbWidth / 2
            view.layer.shadowOffset = CGSize(width: 0, height: 1)
            view.layer.shadowColor = UIColor(red:0, green:0, blue:0, alpha:0.16).cgColor
            view.layer.shadowOpacity = 1
            view.layer.shadowRadius = 1
            return view
        }()
        
        let lightShadow: UIView = {
            let view = UIView(frame: frame)
            view.backgroundColor = .white
            view.layer.cornerRadius = thumbWidth / 2
            view.layer.shadowOffset = CGSize(width: 0, height: 3.5)
            view.layer.shadowColor = UIColor(red:0, green:0, blue:0.1, alpha:0.06).cgColor
            view.layer.shadowOpacity = 1
            view.layer.shadowRadius = 0.5
            return view
        }()
        
        thumbView.backgroundColor = .red
        thumbView.isUserInteractionEnabled = false
        thumbView.layer.cornerRadius = thumbWidth / 2
        thumbView.layer.borderWidth = 0.05
        thumbView.layer.borderColor = UIColor(red:0, green:0, blue:0, alpha:0.2).cgColor
        
        thumbView.addSubview(strongShadow)
        thumbView.addSubview(shadow)
        thumbView.addSubview(lightShadow)
    
    }

}
