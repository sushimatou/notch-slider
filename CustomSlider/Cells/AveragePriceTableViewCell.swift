//
//  AveragePriceTableViewCell.swift
//  CustomSlider
//
//  Created by Antoine Lassoujade on 07/02/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

class AveragePriceTableViewCell: UITableViewCell {

    var rangeSlider: RangeSlider? {
        didSet{
            addSubview(rangeSlider!)
            rangeSliderContraints(rangeSlider!)
        }
    }
    
    // Layout
    
    private func rangeSliderContraints(_ r: RangeSlider) {
        r.translatesAutoresizingMaskIntoConstraints = false
        r.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        r.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        r.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

}
