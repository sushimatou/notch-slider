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
    private let detailsTextView = UITextView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        detailsTextView.text = "toutes"
        layout()
        render()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Public funcs
    
    func setTitle(text: String) {
        sectionTitleLabel.text = text
        sectionTitleLabel.sizeToFit()
    }
    
    func setDetailsText(text: String) {
        detailsTextView.text = text
        detailsTextView.sizeToFit()
    }
    
    // MARK: UI Rendering
    
    private func layout() {
        addSubview(sectionTitleLabel)
        addSubview(detailsTextView)
        sectionTitleLabelConstraints(sectionTitleLabel)
        detailsTextViewConstraints(detailsTextView)
    }
    
    private func render() {
        sectionTitleLabelStyle(sectionTitleLabel)
        detailsTextViewStyle(detailsTextView)
    }

    // Styles
    
    // Todo -> Use the-fork styles
    
    private func sectionTitleLabelStyle(_ sectionTitleLabel: UILabel) {
        sectionTitleLabel.font = UIFont(name: "RalewayX", size: 12)
        sectionTitleLabel.textColor = .darkGray
    }
    
    private func detailsTextViewStyle(_ detailsTextView: UITextView) {
        detailsTextView.textContainerInset = UIEdgeInsetsMake(3, 5, 5, 3)
        detailsTextView.sizeToFit()
        detailsTextView.isScrollEnabled = false
        detailsTextView.textAlignment = .center
        detailsTextView.textColor = .white
        detailsTextView.font = UIFont(name: "RalewayX", size: 12)
        detailsTextView.backgroundColor = UIColor(red:0.24, green:0.25, blue:0.29, alpha:1)
        detailsTextView.layer.cornerRadius = 10
        detailsTextView.clipsToBounds = true
    }
    
    // Constraints
    
    private func sectionTitleLabelConstraints(_ sectionTitle: UILabel) {
        sectionTitle.translatesAutoresizingMaskIntoConstraints = false
        sectionTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        sectionTitle.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func detailsTextViewConstraints(_ detailsTextView: UITextView) {
        detailsTextView.translatesAutoresizingMaskIntoConstraints = false
        detailsTextView.leadingAnchor.constraint(equalTo: sectionTitleLabel.trailingAnchor, constant: 10).isActive = true
        detailsTextView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}
