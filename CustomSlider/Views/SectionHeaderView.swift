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
    
    private let sectionTitleLabel = UILabel()
    private let dynamicLabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        dynamicLabel.text = "toutes"
        render()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Public funcs
    
    func setTitle(text: String) {
        sectionTitleLabel.text = text
        sectionTitleLabel.sizeToFit()
    }
    
    func setDynamicText(text: String) {
        dynamicLabel.text = text
        dynamicLabel.sizeToFit()
    }
    
    // MARK: UI Rendering
    
    private func layout() {
        addSubview(sectionTitleLabel)
        addSubview(dynamicLabel)
        sectionTitleLabelConstraints(sectionTitleLabel)
        dynamicLabelConstraints(dynamicLabel)
    }
    
    private func render() {
        sectionTitleLabelStyle(sectionTitleLabel)
        dynamicLabelStyle(dynamicLabel)
    }

    // Styles
    
    private func sectionTitleLabelStyle(_ sectionTitleLabel: UILabel) {
        
    }
    
    private func dynamicLabelStyle(_ dynamicLabel: UILabel) {
        let insets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        let rect = UIEdgeInsetsInsetRect(dynamicLabel.frame, insets)
        dynamicLabel.textColor = .white
        dynamicLabel.drawText(in: rect)
        dynamicLabel.backgroundColor = .darkGray
        dynamicLabel.layer.cornerRadius = 10
        dynamicLabel.clipsToBounds = true
    }
    
    
    // Constraints
    
    private func sectionTitleLabelConstraints(_ sectionTitle: UILabel) {
        sectionTitle.translatesAutoresizingMaskIntoConstraints = false
        sectionTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        sectionTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    
    private func dynamicLabelConstraints(_ dynamicLabel: UILabel) {
        dynamicLabel.translatesAutoresizingMaskIntoConstraints = false
        dynamicLabel.leadingAnchor.constraint(equalTo: sectionTitleLabel.trailingAnchor, constant: 20).isActive = true
        dynamicLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}
