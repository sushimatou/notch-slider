//
//  NotchSlider.swift
//  NotchSlider
//
//  Created by Antoine Lassoujade on 23/01/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

class NotchSlider: UISlider {
    
    // MARK: Notch Definition
    
    private struct Notch {
        var view: NotchView
        var point: CGPoint
        init(view: NotchView, point: CGPoint) {
            self.view = view
            self.point = point
        }
    }
    
    // MARK: Notch View Definition
    
    private final class NotchView: UIView {
        private let value: Int
        private let radius: Float
        private let abscisse: Float
        init(value: Int, radius: Float, abscisse: Float) {
            self.value = value
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
    private var notches = [Notch]()
    private let notchesCount: Int
    private let notchRadius: Float
    var delegate: NotchSliderDelegate?

    
    // MARK: Init Methods
    
    init(frame: CGRect, minValue: Int, maxValue: Int, notchesCount: Int, notchRadius: Float = 4, primaryColor: UIColor = .gray, secondaryColor: UIColor = .blue) {
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
    
//    private func createNotches() {
//        for notchRange in 0..<(notchesCount) {
//            let notch = Notch(
//                view: ,
//                point: <#T##CGPoint#>)
//            notches.append(notch)
//        }
//    }
    
    // MARK: CreateNotchViews
    
    private func createNotchView(notches: [Notch]) -> [NotchView] {
        for notch in notches {
            let notchView = NotchView(
                value:,
                radius: <#T##Float#>,
                abcisse: <#T##Float#>)
        }
    }
    
    private colorNotch
    
    // MARK: UI Render
    
    private func render() {
        minimumTrackTintColor = primaryColor
        maximumTrackTintColor = secondaryColor
    }
    
}
