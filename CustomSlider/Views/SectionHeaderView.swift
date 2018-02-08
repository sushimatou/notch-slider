//
//  HeaderView.swift
//  CustomSlider
//
//  Created by Antoine Lassoujade on 01/02/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

public class LabelWithInsets: UILabel {
    
    let insets: UIEdgeInsets
    
    public override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.height += insets.top + insets.bottom
        intrinsicContentSize.width += insets.left + insets.right
        return intrinsicContentSize
    }
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    public required init(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(insets: UIEdgeInsets) {
        self.insets = insets
        super.init(frame: .zero)
    }
}

class SectionHeaderView: UITableViewHeaderFooterView {
    
    // MARK: Properties
    
    private let sectionTitleLabel = UILabel()
    private let detailsTextView = LabelWithInsets(insets: UIEdgeInsets(top: 3, left: 10, bottom: 3, right: 10))
    
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
    
    func setDetailsTextColor(color: UIColor) {
        
    }
    
    func setDetailsBackgroundColor(color: UIColor){
        detailsTextView.backgroundColor = color
    }
    
    func setDetailsText(text: String) {
        detailsTextView.text = text
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
    
    private func detailsTextViewStyle(_ d: LabelWithInsets) {
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
    
    private func detailsTextViewConstraints(_ d: LabelWithInsets) {
        d.translatesAutoresizingMaskIntoConstraints = false
        d.leadingAnchor.constraint(equalTo: sectionTitleLabel.trailingAnchor, constant: 10).isActive = true
        d.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}
