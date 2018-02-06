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
    
    func setDetailsBackgroundColor(color: UIColor){
        detailsTextView.backgroundColor = color
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
    
    private func sectionTitleLabelStyle(_ s: UILabel) {
        s.font = UIFont(name: "RalewayX", size: 12)
        s.textColor = .darkGray
    }
    
    private func detailsTextViewStyle(_ d: UITextView) {
        d.textContainerInset = UIEdgeInsetsMake(3, 5, 3, 5)
        d.sizeToFit()
        d.isScrollEnabled = false
        d.textAlignment = .center
        d.textColor = .white
        d.font = UIFont(name: "RalewayX", size: 12)
        d.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
        d.layer.cornerRadius = 10
        d.clipsToBounds = true
    }
    
    // Constraints
    
    private func sectionTitleLabelConstraints(_ s: UILabel) {
        s.translatesAutoresizingMaskIntoConstraints = false
        s.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        s.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func detailsTextViewConstraints(_ d: UITextView) {
        d.translatesAutoresizingMaskIntoConstraints = false
        d.leadingAnchor.constraint(equalTo: sectionTitleLabel.trailingAnchor, constant: 10).isActive = true
        d.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}
