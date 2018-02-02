//
//  AverageGradeTableViewCell.swift
//  CustomSlider
//
//  Created by Antoine Lassoujade on 01/02/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

class AverageGradeTableViewCell: UITableViewCell {
    
    // todo: use the fork colors
    
    private let primColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
    private let secColor = UIColor(red:0.4, green:0.68, blue:0.31, alpha:1)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Rendering
    
    private func layout() {
        addSubview(notchSlider)
        notchSliderContraints(notchSlider)
    }
    
    private func render() {
        notchSliderStyle(notchSlider)
    }
    
    private func notchSliderStyle(_ notchSlider: NotchSlider) {
        notchSlider.minimumTrackTintColor = primColor
        notchSlider.maximumTrackTintColor = secColor
    }
    
    private func notchSliderContraints(_ notchSlider: NotchSlider) {
        notchSlider.translatesAutoresizingMaskIntoConstraints = false
        notchSlider.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        notchSlider.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
}
