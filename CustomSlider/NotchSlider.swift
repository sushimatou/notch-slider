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
        
        let value: Int
        private let radius: Float
        private let abscisse: CGFloat
        private let valueLabel: UILabel
        private var point: UIView
        
        init(displayedValue: Int, radius: Float, abscisse: CGFloat) {
            self.value = displayedValue
            self.radius = radius
            self.abscisse = abscisse
            super.init(frame: .zero)
            
            let point = UIView(frame: CGRect(
                x: center,
                y: 0,
                width: radius * 2,
                height: frame.height))
            
            let label = UILabel()
            label.text = "\(displayedValue)"
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
        delegate?.valueDidChange(value: self.value)
    }
    
    
    // MARK: Create Notches Points
    
    private func createNotchPoints() {
        for notchRange in 0...notchesCount-1 {
            let notchPoint = CGPoint(x: CGFloat(notchRange/notchesCount-1) * frame.width,
                                     y: center.y - CGFloat(notchRadius))
            notches.append(notchPoint)
        }
    }

    // MARK: Create Notches Views
    
    private func createNotchViews(){
        for notchRange in 0...notchesCount-1 {
            let notchView = NotchView(
                displayedValue: notchRange + Int(minimumValue),
                radius: notchRadius,
                abscisse: notches[notchRange].x)
            addSubview(notchView)
        }
    }
    
    // MARK: Color Notches
    
    private func colorNotchesByValue(value: Float) {
        notchViews.filter{ (notchView) -> Bool in
                return Float(notchView.value) < value
            }.map { (notchView) -> NotchView in
                notchView.backgroundColor = primaryColor
                return notchView
            }
    }
}
