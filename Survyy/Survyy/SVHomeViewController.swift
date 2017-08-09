//
//  SVHomeViewController.swift
//  Survyy
//
//  Created by Guillermo Delgado on 09/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit

class SVHomeViewController: SVBaseViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBarView: SVNavigationBarView!

    let discoverCellIdentifier = "DiscoverCellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "SVTableViewCell", bundle: nil), forCellReuseIdentifier: self.discoverCellIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsets.init(top: 50, left: 0, bottom: 60, right: 0)
        self.navBarView.shouldShowShadow(showShadow: false)
    }

// MARK: - UITableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.discoverCellIdentifier, for: indexPath) as? SVTableViewCell else {
            fatalError()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

// MARK: - UITableView Delegate

// MARK: - UIScrollView

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y <= -self.tableView.contentInset.top {
            self.navBarView.shouldShowShadow(showShadow: false)
        } else {
            self.navBarView.shouldShowShadow(showShadow: true)
        }
    }
}
