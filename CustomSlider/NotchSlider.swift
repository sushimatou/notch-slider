//
//  NotchSlider.swift
//  NotchSlider
//
//  Created by Antoine Lassoujade on 23/01/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

class NotchSlider: UISlider {
    
    // MARK: Notch View Definition
    
    private final class NotchView: UIView {
        private let displayedValue: Int
        private let radius: Float
        private let abscisse: Float
        init(displayedValue: Int, radius: Float, abscisse: Float) {
            self.displayedValue = displayedValue
            self.radius = radius
            self.abscisse = abscisse
            super.init(frame: .zero)
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
    private var notchesViews = [NotchView]
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
    
    // MARK: Set Value Selector

    @objc private func valueDidChanged() {
        delegate?.valueDidChange(value: self.value)
    }
    
    // MARK: Create Notches
    
    private func createNotchPoints() {
        for notchRange in 0...notchesCount-1 {
            let notchPoint = CGPoint(x: CGFloat(notchRange/notchesCount-1) * frame.width,
                                     y: center.y - CGFloat(notchRadius))
            notches.append(notchPoint)
        }
    }
    
    
    
    private func createNotchView(notches: [Notch]) -> [NotchView] {
        for notchRange in 0...notchesCount-1 {
            let notchView = NotchView(
                displayedValue: notchRange + Int(minimumValue),
                radius: notchRadius,
                abscisse: Float(notchRange/notchesCount-1) * Float(frame.width))
        }
    }
    
    private func createNotches() {
        for notchView in notchView {
            let notch = Notch(
                value: minimumValue + Float(notchRange),
                view: )
        }
    }
    
    
    
    // MARK: UI Render
    
    private func render() {
        minimumTrackTintColor = primaryColor
        maximumTrackTintColor = secondaryColor
    }
    
}
