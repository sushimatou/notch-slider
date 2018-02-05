//
//  NotchSlider.swift
//  NotchSlider
//
//  Created by Antoine Lassoujade on 23/01/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

class NotchSlider: UIView {
    
    // MARK: NotchView
    
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
    
    // MARK: NotchSlider Style
    
    struct NotchSliderStyle {
        static let defaultStyle = NotchSliderStyle(
            primaryColor: UIColor.gray,
            secondaryColor: UIColor.blue,
            minimumValue: 7,
            maximumValue: 10,
            notchRadius: 2,
            notchesCount: 4,
            width: 50)
        let primaryColor: UIColor
        let secondaryColor: UIColor
        let minimumValue: Float
        let maximumValue: Float
        let notchRadius: Float
        let notchesCount: Int
        let width: CGFloat
    }
    
    // MARK: Properties

    private let style: NotchSliderStyle
    private let slider = UISlider()
    private var notches = [CGPoint]()
    private var notchViews = [NotchView]()
    weak var delegate: NotchSliderDelegate?
    
    // MARL: Computed Properties
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width, height: 50)
    }
    
    
    var sliderValue: SliderValue {
        switch slider.value {
        case style.minimumValue:
            return .start
        case style.maximumValue:
            return .end
        default:
            return SliderValue.inProgress(value: Double(slider.value))
        }
    }
    
    // MARK: Init Methods
    
    init(style: NotchSliderStyle = .defaultStyle) {
        self.style = style
        let frame = CGRect(x: 0, y: 0, width: style.width, height: 50)
        super.init(frame: frame)
        render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set Value Selector

    @objc private func valueDidChanged() {
        colorNotchView(by: slider.value)
        delegate?.valueDidChange(sliderValue: sliderValue)
    }
    
    // MARK: UI Rendering
    
    private func render() {
        createSlider()
        for notchRange in 0..<style.notchesCount {
            createNotchPoint(notchRange: notchRange)
            createNotchView(notchRange: notchRange)
            createValueLabel(notchRange: notchRange)
        }
        colorNotchView(by: slider.value)
        bringSubview(toFront: slider)
    }
    
    private func createSlider() {
        slider.addTarget(self, action: #selector(valueDidChanged), for: UIControlEvents.valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumValue = style.minimumValue
        slider.maximumValue = style.maximumValue
        slider.minimumTrackTintColor = style.primaryColor
        slider.maximumTrackTintColor = style.secondaryColor
        addSubview(slider)
        slider.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
    }
    
    private func createNotchPoint(notchRange: Int) {
        let notchPoint = CGPoint(
            x: CGFloat(notchRange)/CGFloat(style.notchesCount-1) * frame.width,
            y: slider.center.y - CGFloat(style.notchRadius)
        )
        notches.insert(notchPoint, at: notchRange)
    }
    
    private func createNotchView(notchRange: Int) {
        let notchView = NotchView(
            value: Int(style.minimumValue) + notchRange,
            point: notches[notchRange],
            radius: style.notchRadius)
        notchViews.insert(notchView, at: notchRange)
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
    
    private func colorNotchView(by value: Float) {
        notchViews = notchViews.flatMap { (notchView) -> NotchView in
            notchView.backgroundColor = Float(notchView.value) <= value ? slider.minimumTrackTintColor : slider.maximumTrackTintColor
            return notchView
        }
    }
}
