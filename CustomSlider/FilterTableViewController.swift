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
        let notchSliderStyle = NotchSliderStyle()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerViewReuseId) as! SectionHeaderView
            headerView.textLabel?.text = "Note Moyenne"
            return headerView
        default:
            return nil // noop
        }
    }
    
    private func registerClasses() {
        tableView.register(AverageGradeTableViewCell.self, forCellReuseIdentifier: averageGradeCellReuseId)
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: headerViewReuseId)
    }
    
}

// MARK: - Notch Slider Delegate

extension FilterTableViewController: NotchSliderDelegate {
    
    func valueDidChange(sliderValue: SliderValue) {
        print(sliderValue)
        let sliderValue = sliderValue
        let sectionHeaderView = tableView.headerView(forSection: 1) as! SectionHeaderView
        sectionHeaderView.setValue(value: String(describing:sliderValue))
    }
    
}

extension FilterTableViewController: NotchSliderDataSource {
    
    func setNotchCountforSlider(_: UIViewController) -> Int {
        return 4
    }
    
    
}
