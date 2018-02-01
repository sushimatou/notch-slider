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
    
    // -
    
    lazy var notchSlider: NotchSlider = NotchSlider(frame: bounds, minValue: 7, maxValue: 10, notchesCount: 4, notchRadius: 4, primaryColor: primColor, secondaryColor: secColor)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        addSubview(notchSlider)
        notchSliderContraints(notchSlider)
    }
    
    private func render() {

    }
    
    // MARK: Styles
    
    // todo
    
    // MARK: Layout Constraints
    
    private func notchSliderContraints(_ notchSlider: NotchSlider) {
        notchSlider.translatesAutoresizingMaskIntoConstraints = false
        notchSlider.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        notchSlider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        notchSlider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        notchSlider.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
}

extension AverageGradeTableViewCell: NotchSliderDelegate {
    func valueDidChange(sliderValue: SliderValue) {
        
    }
    
    
}
