//
//  ViewController.swift
//  CustomSlider
//
//  Created by Antoine Lassoujade on 23/01/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var customSlider = NotchSlider(frame: self.view.frame, minValue: 6, maxValue: 10, notchesCount: 5, primaryColor: .green, secondaryColor: .red)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(customSlider)
        self.customSlider.delegate = self
        self.customSlider.center = self.view.center
    }
}

extension ViewController : NotchSliderDelegate {
    
    func valueDidChange(value: SliderValue) {
        
        switch value{
            
        case .start:
            break
        case .inProgress(_):
            break
        case .end:
            break
        }
    }

    
}

