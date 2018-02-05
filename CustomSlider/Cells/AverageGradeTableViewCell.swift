//
//  AverageGradeTableViewCell.swift
//  CustomSlider
//
//  Created by Antoine Lassoujade on 01/02/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

class AverageGradeTableViewCell: UITableViewCell {
    
    var notchSlider: NotchSlider? {
        didSet{
            addSubview(notchSlider!)
            notchSliderContraints(notchSlider!)
        }
    }

    private func notchSliderContraints(_ notchSlider: NotchSlider) {
        notchSlider.translatesAutoresizingMaskIntoConstraints = false
        notchSlider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        notchSlider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        notchSlider.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}

