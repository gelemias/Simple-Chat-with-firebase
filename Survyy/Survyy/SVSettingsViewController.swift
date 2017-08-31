//
//  SVSettingsViewController.swift
//  Survyy
//
//  Created by Guillermo Delgado on 30/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit

class SVSettingsViewController: SVBaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Settings"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        self.tableView.contentInset = UIEdgeInsets.init(top: -20, left: 0, bottom: -20, right: 0)

        let editbutton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        editbutton.setTitleTextAttributes([NSFontAttributeName: UIFont.init(name: "SourceSansPro-Regular", size: 16)!,
                                           NSForegroundColorAttributeName: UIColor.black], for: .normal)

        self.navigationItem.rightBarButtonItem = editbutton
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

// MARK: - Internal Methods

    internal func editTapped() {

    }

    private var _sourcedata: NSDictionary?
    internal func sourcedata() -> NSDictionary {
        if _sourcedata == nil {
            _sourcedata = NSDictionary.init(contentsOfFile: Bundle.main.path(forResource: "settingsData_en-US", ofType: "plist")!)
        }

        return _sourcedata!
    }

    internal func profileSection(atRow: Int) -> String {
        return "Masa"
    }

    internal func notificationsSection(atRow: Int) -> String {
        return ""
    }

    internal func privacySection(atRow: Int) -> String {
        return ""
    }

    internal func sourceKey() -> NSArray {
        var sourcekey: [String] = []
        let arr: [String] = sourcedata().allKeys.flatMap({ $0 as? String })
        sourcekey = arr.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }

        return sourcekey as NSArray
    }

// MARK: - UITableView Datasource

    func numberOfSections(in tableView: UITableView) -> Int {
        return sourceKey().count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let arr = sourcedata().value(forKey: sourceKey().object(at: section) as! String) as? NSArray else {
            fatalError()
        }

        return arr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SettingsCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)

        if cell == nil {
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellIdentifier)
        }

        let foregroundColor = UIColor.init(hex: SVConstants.darkGrey)

        cell?.backgroundColor = UIColor.white

        guard let sectArray: NSArray = self.sourcedata().value(forKey: self.sourceKey().object(at: indexPath.section) as! String) as? NSArray else {
            fatalError()
        }

        cell?.textLabel?.text = sectArray.object(at: indexPath.row) as? String
        cell?.textLabel?.font = UIFont.init(name: "SourceSansPro-Regular", size: 18)
        cell?.textLabel?.textColor = foregroundColor

        cell?.detailTextLabel?.font = UIFont.init(name: "SourceSansPro-Light", size: 16)
        cell?.detailTextLabel?.textColor = UIColor.init(hex: SVConstants.darkBlue)

        switch indexPath.section {
        case 0:
            cell?.detailTextLabel?.text = self.profileSection(atRow: indexPath.row)
            break
        case 1:
            cell?.detailTextLabel?.text = self.notificationsSection(atRow: indexPath.row)
            break
        case 2:
            cell?.detailTextLabel?.text = self.privacySection(atRow: indexPath.row)
            break
        default:
            break
        }

        cell?.accessoryView = nil
        
        return cell!
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let str = self.sourceKey().object(at: section) as? String else {
            fatalError()
        }

        return str
    }

// MARK - UITableView Delegate 

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.tableView.frame.width, height: 20))
        let bevel = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.width, height: 2))
        view.backgroundColor = UIColor.clear
        bevel.backgroundColor = UIColor.init(hex: SVConstants.veryLightGrey)

        view.addSubview(bevel)

        return view
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textAlignment = .center
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).font = UIFont.init(name: "SourceSansPro-Regular", size: 12)

//        if let header: UITableViewHeaderFooterView = view as? UITableViewHeaderFooterView {
//            header.textLabel?.textColor = UIColor.init(hex: SVConstants.veryDarkGrey)
//            header.textLabel?.font = UIFont.init(name: "SourceSansPro-Semibold", size: 12)
//            header.contentView.backgroundColor = UIColor.clear
//        }
    }
}
