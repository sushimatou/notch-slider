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
    private let averagePriceCellReuseId = "averagePriceCellReuseId"
    private let headerViewReuseId = "headerViewReuseId"
    private let grayTheFork = UIColor(red:0.94, green:0.94, blue:0.94, alpha:1)
    private let greenTheFork = UIColor(red:0.4, green:0.68, blue:0.31, alpha:1)
    
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
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80
        case 1:
            return 80
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: averageGradeCellReuseId) as! AverageGradeTableViewCell
            let notchSliderStyle = NotchSlider.NotchSliderStyle(
                minimumTrackTintColor: greenTheFork,
                maximumTrackTintColor: grayTheFork,
                minimumValue: 7,
                maximumValue: 10,
                textFont: UIFont(name: "Helvetica", size: 12)!,
                textColor: .darkGray ,
                notchRadius: 4,
                notchesCount: 4,
                width: cell.contentView.frame.width)
            let notchSlider = NotchSlider(style: notchSliderStyle)
            notchSlider.delegate = self
            cell.notchSlider = notchSlider
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: averagePriceCellReuseId) as! AveragePriceTableViewCell
            let rangeSlider = RangeSlider()
            rangeSlider.trackHighlightTintColor = greenTheFork
            rangeSlider.delegate = self
            rangeSlider.minimumValue = 15
            rangeSlider.maximumValue = 250
            rangeSlider.lowerValue = 60
            rangeSlider.upperValue = 190
            rangeSlider.minimumGapValue = 22
            cell.rangeSlider = rangeSlider
            return cell
        default:
            return UITableViewCell() // noop
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerViewReuseId) as! SectionHeaderView
        switch section {
        case 0:
            headerView.setTitle(text: "Note Moyenne".uppercased())
            return headerView
        case 1:
            headerView.setTitle(text: "Prix Moyen".uppercased())
            return headerView
        default:
            return headerView // noop
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    private func registerClasses() {
        tableView.register(AverageGradeTableViewCell.self, forCellReuseIdentifier: averageGradeCellReuseId)
        tableView.register(AveragePriceTableViewCell.self, forCellReuseIdentifier: averagePriceCellReuseId)
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: headerViewReuseId)
    }
    
}

// MARK: - Notch slider delegate

extension FilterTableViewController: NotchSliderDelegate {

    func valueDidChange(sliderValue: SliderValue) {
        let header = tableView.headerView(forSection: 0) as! SectionHeaderView
        switch sliderValue {
        case .start:
            header.setDetailsBackgroundColor(color: UIColor(red:0.94, green:0.94, blue:0.94, alpha:1))
            header.setDetailsText(text: "toutes")
        case .inProgress(let value):
            header.setDetailsText(text: "\(value)"+"+")
            header.setDetailsBackgroundColor(color: UIColor(red:0.24, green:0.25, blue:0.29, alpha:1))
        case .end:
            header.setDetailsText(text: "10")
        }
    }
    
}

// MARK: - Range slider delegate

extension FilterTableViewController: RangeSliderDelegate {
    
    func valuesDidChanged(values: RangeSlider.RangeSliderValues) {
        let header = tableView.headerView(forSection: 1) as! SectionHeaderView
        header.setDetailsBackgroundColor(color: UIColor.darkGray)
        header.setDetailsText(text: "de " + String(format: "%.0f", values.lowerValue) + " €"  + " à " + String(format: "%.0f", values.upperValue) + " €" )
    }
    
}
