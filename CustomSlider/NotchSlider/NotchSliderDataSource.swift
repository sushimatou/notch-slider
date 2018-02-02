//
//  NotchSliderDataSource.swift
//  CustomSlider
//
//  Created by Antoine Lassoujade on 02/02/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import Foundation
import UIKit

protocol NotchSliderDataSource : NSObjectProtocol {

    func setNotchCountforSlider(_ : UIViewController) -> Int

}
