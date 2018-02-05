//
//  HeaderView.swift
//  CustomSlider
//
//  Created by Antoine Lassoujade on 01/02/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

class SectionHeaderView: UITableViewHeaderFooterView {
    
    // MARK: Properties
    
    private let valueContainerView = UIView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UI Rendering
    
    func setValue(value: String) {
        textLabel?.text = "\(value)"
    }
    
    private func render() {
        textLabel?.text? = (textLabel?.text?.uppercased())!
    }
    
    private func valueContainerViewStyle() {
        let margins = valueContainerView.layoutMarginsGuide
        contentView.addSubview(valueContainerView)
        valueContainerView.leftAnchor.constraint(equalTo: margins.leftAnchor, constant: 20).isActive = true
    }
}
