//
//  FilterTableViewController.swift
//  CustomSlider
//
//  Created by Antoine Lassoujade on 31/01/2018.
//  Copyright © 2018 Antoine Lassoujade. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {
    
    // MARK: - Properties

    private var average: String?
    private let averageGradeCellReuseId = "averageGradeCellReuseId"
    private let headerViewReuseId = "headerViewReuseId"
    
    // MARK: - LifeCycle 
    
    override func loadView() {
        tableView = UITableView(frame: .zero, style: UITableViewStyle.grouped)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        registerClasses()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: averageGradeCellReuseId) as! AverageGradeTableViewCell
        let notchSliderStyle = NotchSlider.NotchSliderStyle(
            primaryColor: UIColor(red:0.4, green:0.68, blue:0.31, alpha:1),
            secondaryColor: UIColor(red:0.94, green:0.94, blue:0.94, alpha:1),
            minimumValue: 7,
            maximumValue: 10,
            notchRadius: 4,
            notchesCount: 4,
            width: cell.contentView.frame.width)
        let notchSlider = NotchSlider(style: notchSliderStyle)
        notchSlider.delegate = self
        cell.notchSlider = notchSlider
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerViewReuseId) as! SectionHeaderView
            headerView.setTitle(text: "Note Moyenne".uppercased())
            
            return headerView
        default:
            return nil // noop
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    private func registerClasses() {
        tableView.register(AverageGradeTableViewCell.self, forCellReuseIdentifier: averageGradeCellReuseId)
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: headerViewReuseId)
    }
    
}

// MARK: - Notch slider delegate

extension FilterTableViewController: NotchSliderDelegate {

    func valueDidChange(sliderValue: SliderValue) {
        let header = tableView.headerView(forSection: 0) as! SectionHeaderView
        switch sliderValue {
        case .start:
            header.setDetailsText(text: "toutes")
        case .inProgress(let value):
            header.setDetailsText(text: "\(value)"+"+")
        case .end:
            break
        }
    }
    
}
