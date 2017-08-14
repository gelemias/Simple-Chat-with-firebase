//
//  SVChatRoomViewController.swift
//  Survyy
//
//  Created by Guillermo Delgado on 10/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit
import CoreLocation

class SVHistoryViewController: SVBaseViewController, UITableViewDelegate, UITableViewDataSource {

    let historyCellIdentifier = "HistoryCellIdentifier"
    @IBOutlet weak var tableView: UITableView!

    var dataSource = [Date: [SVReviewedItem]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "History"
        self.tableView.register(UINib.init(nibName: "SVTableViewCell", bundle: nil), forCellReuseIdentifier: self.historyCellIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.mockView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func mockView() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"

        var itemList = [SVReviewedItem]()

        for i in 0...2 {
            let state = SVReviewState(rawValue: Int(arc4random_uniform(3)))
            let item = SVReviewedItem(name: "Business " + String(i),
                                      information: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus hendrerit quam libero, amet, consectetur",
                                      avatar: UIImageView(image:UIImage(named:"placeholder")), location: CLLocation(latitude: 0.0, longitude: 0.0), state: state!)
            itemList.append(item)
        }

        self.dataSource[formatter.date(from: "2016/10/08")!] = itemList
        itemList.removeAll()

        let state = SVReviewState(rawValue: Int(arc4random_uniform(3)))
        let item = SVReviewedItem(name: "Business 2",
                                  information: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus hendrerit quam libero, amet, consectetur",
                                  avatar: UIImageView(image:UIImage(named:"placeholder")), location: CLLocation(latitude: 0.0, longitude: 0.0), state: state!)

        self.dataSource[formatter.date(from: "2016/10/28")!] = [item]

        for i in 3...5 {
            let state = SVReviewState(rawValue: Int(arc4random_uniform(3)))
            let item = SVReviewedItem(name: "Business " + String(i),
                                      information: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus hendrerit quam libero, amet, consectetur",
                                      avatar: UIImageView(image:UIImage(named:"placeholder")), location: CLLocation(latitude: 0.0, longitude: 0.0), state: state!)
            itemList.append(item)
        }

        self.dataSource[formatter.date(from: "2016/11/02")!] = itemList
    }

// MARK: - TableView DataSouce

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        let sectionDate = Array(self.dataSource.keys)[section]
        return self.dataSource[sectionDate]!.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataSource.keys.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.historyCellIdentifier, for: indexPath) as? SVTableViewCell else {
            fatalError()
        }

        let sectionDate = Array(self.dataSource.keys)[indexPath.section]
        let item: SVReviewedItem = self.dataSource[sectionDate]![indexPath.row]

        cell.selectionStyle = .none

        cell.title = item.name
        cell.subtitle = item.information
        cell.avatar = item.avatar!
        cell.reviewState = item.reviewState

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).textAlignment = .center
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewHeaderFooterView.self]).font = UIFont.init(name: "SourceSansPro-Regular", size: 12)

        let sectionDate = Array(self.dataSource.keys)[section]

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: sectionDate)
    }

// MARK: - TableView Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)

        let vc = SVDetailBusinessViewController.init(nibName: "SVDetailBusinessViewController", bundle: nil)
        let sectionDate = Array(self.dataSource.keys)[indexPath.section]
        vc.businessItem = self.dataSource[sectionDate]![indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
