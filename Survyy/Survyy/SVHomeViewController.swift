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
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewTopConstraint: NSLayoutConstraint!
    private let defaultSearchViewTopConstraintValue: CGFloat! = -20
    private var isSearchViewVisible: Bool = true
    let discoverCellIdentifier = "DiscoverCellIdentifier"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "SVTableViewCell", bundle: nil), forCellReuseIdentifier: self.discoverCellIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: navBarView.frame.height * 2/3, right: 0)
        self.navBarView.shouldShowShadow(showShadow: false)
    }

// MARK: - Actions

    @IBAction func goToChat(_ sender: UIButton) {
        self.animateButton(btn: sender)
    }

    @IBAction func goToSettings(_ sender: UIButton) {
        self.animateButton(btn: sender)
    }

// MARK: - UITableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.discoverCellIdentifier, for: indexPath) as? SVTableViewCell else {
            fatalError()
        }

        cell.title = "Fake business name inc."
        cell.subtitle = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus hendrerit quam libero, vitae volutpat dolor ornare vel."
        cell.avatar = UIImageView(image:UIImage(named:"placeholder"))
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

// MARK: - UITableView Delegate

// MARK: - UIScrollView

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let scrollOffset: CGFloat = scrollView.contentOffset.y

        if scrollOffset <= self.tableView.contentInset.top ||
            scrollView.contentSize.height < scrollView.frame.height {

            // Show it
            self.navBarView.shouldShowShadow(showShadow: false)
            self.searchViewTopConstraint.constant = self.defaultSearchViewTopConstraintValue
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                self.isSearchViewVisible = true
            })

        } else if self.isSearchViewVisible {

            // Hide it
            self.navBarView.shouldShowShadow(showShadow: true)
            self.searchViewTopConstraint.constant = -self.searchView.frame.height + (self.defaultSearchViewTopConstraintValue * 1.5)
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                self.isSearchViewVisible = false
            })
        }
    }
}
