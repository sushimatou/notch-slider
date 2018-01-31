//
//  NotchSlider.swift
//  NotchSlider
//
//  Created by Antoine Lassoujade on 23/01/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

class NotchSlider: UISlider {
    
    // MARK: Properties

    private let primaryColor: UIColor
    private let secondaryColor: UIColor
    private let notchesCount: Int
    private let notchRadius: Float
    private var notches = [CGPoint]()
    private var notchViews = [NotchView]()
    var delegate: NotchSliderDelegate?

    // MARK: Init Methods
    
    init(frame: CGRect, minValue: Float, maxValue: Float, notchesCount: Int, notchRadius: Float = 4, primaryColor: UIColor = .gray, secondaryColor: UIColor = .blue) {
        self.notchRadius = notchRadius
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
        self.notchesCount = notchesCount
        super.init(frame: frame)
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
            return .inProgress(value: value)
        }
    }
    
    // MARK: UI Rendering
    
    private func render() {
        createNotchPoints()
        createNotchViews()
        colorNotchViews(value: value)
    }
    
    private func createNotchPoints() {
        for notchRange in 0...notchesCount-1 {
            let notchPoint = CGPoint(
                x: CGFloat(notchRange/notchesCount-1) * frame.width,
                y: center.y - CGFloat(notchRadius)
            )
            notches.append(notchPoint)
        }
    }
    
    private func createNotchViews() {
        for notchRange in 0...notchesCount-1 {
            let notchView = NotchView(value: Int(minimumValue) + notchRange ,
                                      point: notches[notchRange],
                                      radius: notchRadius)
            notchViews.append(notchView)
            addSubview(notchView)
            
        }
    }
    
    private func colorNotchViews(value: Float) {
        notchViews = notchViews.flatMap({ (notchView) -> NotchView in
            notchView.backgroundColor = Float(notchView.value) < value ? primaryColor : secondaryColor
            return notchView
        })
    }
    
}
