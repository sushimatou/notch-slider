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
    
    private let dynamicLabelContainerView = UIView()
    private let sectionTitleLabel = UILabel()
    private let dynamicLabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        render()
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Public fcs
    
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
        addSubview(dynamicLabelContainerView)
        sectionTitleLabelConstraints(sectionTitleLabel)
        dynamicLabelConstraints(dynamicLabel)
        dynamicLabelContainerViewConstraints(dynamicLabelContainerView)
    }
    
    private func render() {
        sectionTitleLabelStyle(sectionTitleLabel)
        dynamicLabelStyle(dynamicLabel)
        dynamicLabelContainerViewStyle(dynamicLabelContainerView)
    }

    // Styles
    
    private func sectionTitleLabelStyle(_ sectionTitleLabel: UILabel) {
        
    }
    
    private func dynamicLabelStyle(_ dynamicLabel: UILabel) {
        
    }
    
    private func dynamicLabelContainerViewStyle(_ dynamicLabelContainerView: UIView) {
        dynamicLabelContainerView.backgroundColor = .darkGray
        dynamicLabelContainerView.layer.cornerRadius = 20
        dynamicLabelContainerView.clipsToBounds = true
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
    
    private func dynamicLabelContainerViewConstraints(_ dynamicLabelContainerView: UIView) {
        
    }
    
}
