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
        let radius: CGFloat
        
        override var intrinsicContentSize: CGSize {
            return CGSize(width: radius * 2, height: radius * 2)
        }
        
        init(value: Int, radius: CGFloat) {
            self.value = value
            self.radius = radius
            super.init(frame: .zero)
            layer.cornerRadius = 4
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
            textFont: UIFont(),
            textColor: .black,
            notchRadius: 2,
            notchesCount: 4,
            width: 50)
        let primaryColor: UIColor
        let secondaryColor: UIColor
        let minimumValue: Float
        let maximumValue: Float
        let textFont: UIFont
        let textColor: UIColor
        let notchRadius: Float
        let notchesCount: Int
        let width: CGFloat
    }
    
    // MARK: Properties

    private let style: NotchSliderStyle
    private let slider = UISlider()
    private var customViews = [NotchView]()
    private var notchesStackView = UIStackView()
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
            return SliderValue.inProgress(value: String(format: "%.1f", slider.value))
        }
    }
    
    // MARK: Init Methods
    
    init(style: NotchSliderStyle = .defaultStyle) {
        self.style = style
        let frame = CGRect(x: 0, y: 0, width: style.width, height: 50)
        super.init(frame: frame)
        addTargetForSlider()
        createNotches()
        createNotchesStackView()
        colorNotches(by: slider.value)
        render()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set Value Target & Selector
    
    private func addTargetForSlider() {
        slider.addTarget(self, action: #selector(valueDidChanged), for: UIControlEvents.valueChanged)
    }

    @objc private func valueDidChanged() {
        delegate?.valueDidChange(sliderValue: sliderValue)
        colorNotches(by: slider.value)
    }
    
    // MARK: UI Rendering
    
    private func layout() {
        sliderConstraints(s: slider)
        notchesStackViewConstraints(n: notchesStackView)
        bringSubview(toFront: slider)
    }
    
    private func render() {
        sliderStyle(s: slider)
        notchesStackViewStyle(n: notchesStackView)
    }
    
    // MARK: Slider Creation
    
    private func createNotches() {
        for range in 0..<style.notchesCount {
            let view = NotchView(value: range + Int(style.minimumValue), radius: CGFloat(style.notchRadius))
            customViews.append(view)
        }
    }
    
    private func colorNotches(by value: Float) {
        for customView in customViews {
            customView.backgroundColor = Float(customView.value) < value ? style.primaryColor : style.secondaryColor
        }
    }
    
    private func createNotchesStackView() {
        notchesStackView = UIStackView(arrangedSubviews: customViews)
    }
    
    // MARK: Style
    
    private func sliderStyle(s: UISlider) {
        s.minimumValue = style.minimumValue
        s.maximumValue = style.maximumValue
        s.minimumTrackTintColor = style.primaryColor
        s.maximumTrackTintColor = style.secondaryColor
    }
    
    private func notchesStackViewStyle(n: UIStackView) {
        n.backgroundColor = .blue
        n.axis = .horizontal
        n.distribution = .equalSpacing
        n.alignment = .bottom
    }
    
    // MARK: Layout
    
    private func sliderConstraints(s: UISlider) {
        addSubview(s)
        s.translatesAutoresizingMaskIntoConstraints = false
        s.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        s.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        s.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
    }
    
    private func notchesStackViewConstraints(n: UIStackView) {
        addSubview(n)
        n.translatesAutoresizingMaskIntoConstraints = false
        n.heightAnchor.constraint(equalToConstant: CGFloat(style.notchRadius*2)).isActive = true
        n.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        n.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        n.centerYAnchor.constraint(equalTo: slider.centerYAnchor).isActive = true
    }
    
}
