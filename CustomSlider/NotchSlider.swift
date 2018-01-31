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
        self.addTarget(self, action: #selector(valueDidChanged), for: .valueChanged)
        self.render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Render
    
    private func render() {
        minimumTrackTintColor = primaryColor
        maximumTrackTintColor = secondaryColor
        createNotchPoints()
        createNotchViews()
    }
    
    // MARK: Set Value Selector

    @objc private func valueDidChanged() {
        colorNotchesByValue(value: value)
        delegate?.valueDidChange(sliderValue: getSliderValue(value: value))
        
    }
    
    
    // MARK: Create Notches Points
    
    private func createNotchPoints() {
        for notchRange in 0...notchesCount-1 {
            let notchPoint = CGPoint(
                x: CGFloat(notchRange/notchesCount-1) * frame.width,
                y: center.y - CGFloat(notchRadius)
            )
            notches.append(notchPoint)
        }
    }

    // MARK: Create Notches Views
    
    private func createNotchViews() {
        for notchRange in 0...notchesCount-1 {
            let notchView = NotchView(value: Int(minimumValue) + notchRange ,
                                      point: notches[notchRange],
                                      radius: notchRadius)
            addSubview(notchView)
            notchViews.append(notchView)
            
        }
    }
    
    // MARK: Color Notches
    
    private func colorNotchesByValue(value: Float) {
        notchViews = notchViews.filter{ (notchView) -> Bool in
                return Float(notchView.value) < value
            }.map{ (notchView) -> NotchView in
                notchView.backgroundColor = primaryColor
                return notchView
        }
    }
    
    private func getSliderValue(value: Float) -> SliderValue {
        switch value {
        case minimumValue:
            return SliderValue.start
        case maximumValue:
            return SliderValue.end
        default:
            return SliderValue.inProgress(value: value)
        }
    }
}
