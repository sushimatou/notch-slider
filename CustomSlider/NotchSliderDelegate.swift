//
//  NotchSliderDelegate.swift
//  NotchSliderDelegate
//
//  Created by Antoine Lassoujade on 23/01/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import Foundation

enum SliderValue {
    case start
    case inProgress(value: Float)
    case end
}

protocol NotchSliderDelegate : NSObjectProtocol {
    func valueDidChange(sliderValue: SliderValue)
}


