//
//  NotchSlider.swift
//  NotchSlider
//
//  Created by Antoine Lassoujade on 23/01/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

protocol NotchSliderDelegate : NSObjectProtocol {
    func valueDidChange(sliderValue: SliderValue)
}

enum SliderValue {
    case start
    case inProgress(value: String)
    case end
}

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
    private let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    private var notchViews = [NotchView]()
    private var valueLabels = [UILabel]()
    private var notchesStackView = UIStackView()
    private var labelsStackView = UIStackView()
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
        createLabels()
        createNotchesStackView()
        createLabelsStackView()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        feedbackGenerator.prepare()
    }

    @objc private func valueDidChanged() {
        delegate?.valueDidChange(sliderValue: sliderValue)
        colorNotches(by: slider.value)
    }
    
    // MARK: UI Rendering
    
    private func layout() {
        sliderConstraints(slider)
        notchesStackViewConstraints(notchesStackView)
        valueLabelsStackViewConstraints(labelsStackView)
        bringSubview(toFront: slider)
    }
    
    private func render() {
        sliderStyle(slider)
        notchesStackViewStyle(notchesStackView)
        valueLabelsStackViewStyle(labelsStackView)
    }
    
    // MARK: Slider Creation
    
    private func createNotches() {
        for range in 0..<style.notchesCount {
            let view = NotchView(value: range + Int(style.minimumValue), radius: CGFloat(style.notchRadius))
            notchViews.append(view)
        }
    }
    
    private func createLabels() {
        for range in 0..<style.notchesCount {
            let label = UILabel()
            label.text = "\(range + Int(style.minimumValue))"
            label.textAlignment = .center
            valueLabels.append(label)
        }
    }
    
    private func colorNotches(by value: Float) {
        for notchView in notchViews {
            notchView.backgroundColor = Float(notchView.value) < value ? style.primaryColor : style.secondaryColor
        }
    }
    
    private func createNotchesStackView() {
        notchesStackView = UIStackView(arrangedSubviews: notchViews)
    }
    
    private func createLabelsStackView() {
        labelsStackView = UIStackView(arrangedSubviews: valueLabels)
    }
    
    // MARK: Styles
    
    private func sliderStyle(_ slider: UISlider) {
        slider.minimumValue = style.minimumValue
        slider.maximumValue = style.maximumValue
        slider.minimumTrackTintColor = style.primaryColor
        slider.maximumTrackTintColor = style.secondaryColor
    }
    
    private func notchesStackViewStyle(_ notchesStackView: UIStackView) {
        notchesStackView.axis = .horizontal
        notchesStackView.distribution = .equalSpacing
        notchesStackView.alignment = .bottom
    }
    
    private func valueLabelsStackViewStyle(_ valueLabelsStackView: UIStackView) {
        valueLabelsStackView.axis = .horizontal
        valueLabelsStackView.distribution = .equalSpacing
        valueLabelsStackView.alignment = .bottom
    }
    
    // MARK: Layout
    
    private func sliderConstraints(_ slider: UISlider) {
        addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
    }
    
    private func notchesStackViewConstraints(_ notchesStackView: UIStackView) {
        addSubview(notchesStackView)
        notchesStackView.translatesAutoresizingMaskIntoConstraints = false
        notchesStackView.heightAnchor.constraint(equalToConstant: CGFloat(style.notchRadius*2)).isActive = true
        notchesStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        notchesStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        notchesStackView.centerYAnchor.constraint(equalTo: slider.centerYAnchor, constant: 1).isActive = true
    }
    
    private func valueLabelsStackViewConstraints(_ valueLabelsStackView: UIStackView) {
        addSubview(valueLabelsStackView)
        valueLabelsStackView.translatesAutoresizingMaskIntoConstraints = false
        valueLabelsStackView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        valueLabelsStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        valueLabelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: CGFloat(style.notchRadius)).isActive = true
        valueLabelsStackView.centerYAnchor.constraint(equalTo: slider.centerYAnchor, constant: 25).isActive = true
    }
    
}
