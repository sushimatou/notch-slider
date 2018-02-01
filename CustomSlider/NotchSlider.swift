//
//  NotchSlider.swift
//  NotchSlider
//
//  Created by Antoine Lassoujade on 23/01/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

class NotchSlider: UISlider {
    
    private final class NotchView: UIView {
        
        let value: Int
        let radius: Float
        
        init(value: Int, point: CGPoint, radius: Float) {
            self.value = value
            self.radius = radius
            super.init(frame: CGRect(
                x: point.x - CGFloat(radius),
                y: point.y,
                width: CGFloat(radius * 2),
                height: CGFloat(radius * 2)))
            layer.cornerRadius = CGFloat(radius)
            clipsToBounds = true
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    // MARK: Properties
    
    private let primaryColor: UIColor
    private let secondaryColor: UIColor
    private let notchesCount: Int
    private let notchRadius: Float
    private var notches = [CGPoint]()
    private var notchViews = [NotchView]()
    var delegate: NotchSliderDelegate?
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width, height: 50)
    }
    
    // MARK: Init Methods
    
    init(frame: CGRect, minValue: Float, maxValue: Float, notchesCount: Int, notchRadius: Float = 4, primaryColor: UIColor = .gray, secondaryColor: UIColor = .blue) {
        self.notchRadius = notchRadius
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.notchesCount = notchesCount
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: 50))
        self.minimumValue = Float(minValue)
        self.maximumValue = Float(maxValue)
        minimumTrackTintColor = primaryColor
        maximumTrackTintColor = secondaryColor
        self.addTarget(self, action: #selector(valueDidChanged), for: .valueChanged)
        self.render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(x: bounds.origin.x, y: bounds.midY-1, width: bounds.width, height: 1)
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
    
    // MARK: Set Value Selector

    @objc private func valueDidChanged() {
        colorNotchViews(value: value)
        delegate?.valueDidChange(sliderValue: getSliderValue(value: value))
    }
    
    private func getSliderValue(value: Float) -> SliderValue {
        switch value{
        case minimumValue:
            return .start
        case maximumValue:
            return .end
        default:
            return .inProgress(value: Double(value))
        }
    }
    
    // MARK: UI Rendering
    
    private func render() {
        for notchRange in 0...notchesCount-1 {
            createNotchPoint(notchRange: notchRange)
            createNotchView(notchRange: notchRange)
            createValueLabel(notchRange: notchRange)
        }
        colorNotchViews(value: value)
    }
    
    private func createNotchPoint(notchRange: Int) {
        let notchPoint = CGPoint(
            x: CGFloat(notchRange)/CGFloat(notchesCount-1) * frame.width,
            y: center.y - CGFloat(notchRadius)
        )
        notches.append(notchPoint)
    }
    
    private func createNotchView(notchRange: Int) {
        let notchView = NotchView(
            value: Int(minimumValue) + notchRange ,
            point: notches[notchRange],
            radius: notchRadius)
        notchViews.append(notchView)
        addSubview(notchView)
    }
    
    private func createValueLabel(notchRange: Int) {
        let valueLabel = UILabel()
        valueLabel.text = "\(notchViews[notchRange].value)"
        valueLabel.textAlignment = .center
        valueLabel.textColor = .darkGray
        valueLabel.sizeToFit()
        valueLabel.center.y = notchViews[notchRange].frame.midY + 30
        valueLabel.center.x = notchViews[notchRange].frame.midX
        addSubview(valueLabel)
    }
    
    private func colorNotchViews(value: Float) {
        notchViews = notchViews.flatMap({ (notchView) -> NotchView in
            notchView.backgroundColor = Float(notchView.value) <= value ? primaryColor : secondaryColor
            return notchView
        })
    }
    
}
