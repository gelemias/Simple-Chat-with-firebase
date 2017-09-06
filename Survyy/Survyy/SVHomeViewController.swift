//
//  SVHomeViewController.swift
//  Survyy
//
//  Created by Guillermo Delgado on 09/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit
import CoreLocation

class SVHomeViewController: SVBaseViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navBarView: SVNavigationBarView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchViewTopConstraint: NSLayoutConstraint!
    private let defaultSearchViewTopConstraintValue: CGFloat! = -20
    private var isSearchViewVisible: Bool = true
    let discoverCellIdentifier = "DiscoverCellIdentifier"
    let showHistorySegue = "ShowHistorySegue"

    var dataSource = [SVBusinessItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "SVTableViewCell", bundle: nil), forCellReuseIdentifier: self.discoverCellIdentifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: navBarView.frame.height * 2/3, right: 0)
        self.navBarView.shouldShowShadow(showShadow: false)

        self.mockView()

    }

// MARK: - Internal Methods

    func bgGradient(frame: CGRect) -> CAGradientLayer {

        let gradient = CAGradientLayer()
        gradient.frame = frame

        gradient.colors = [UIColor(hex:SVConstants.leftGradientColor).cgColor,
        UIColor(hex:SVConstants.rightGradientColor).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint.init(x: 0, y: 0.5)
        gradient.endPoint = CGPoint.init(x: 1, y: 0.5)

        return gradient
    }

    func bottomToTopTransition() -> CATransition {
        let transition = CATransition.init()

        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        transition.type = kCATransitionReveal
        transition.subtype = kCATransitionFromTop

        return transition
    }

    func mockView() {
        for i in 0...10 {
            let item = SVBusinessItem(name: "Business " + String(i),
                                      information: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus hendrerit quam libero, amet, consectetur",
                                      avatar: UIImageView(image:UIImage(named:"placeholder")), location: CLLocation(latitude: 0.0, longitude: 0.0))
            self.dataSource.append(item)
        }
    }

// MARK: - Actions

    @IBAction func goToHistory(_ sender: UIButton) {
        self.animateButton(btn: sender)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.performSegue(withIdentifier: self.showHistorySegue, sender: self)
        }
    }

    @IBAction func goToSettings(_ sender: UIButton) {
        self.animateButton(btn: sender)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

            let vc = SVSettingsViewController.init(nibName: "SVSettingsViewController", bundle: nil)
            let transition = CATransition.init()

            transition.duration = 0.5
            transition.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft

            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }

    @IBAction func goProfile(_ sender: Any) {
        print("profile")

        let vc = UIViewController.init()
        vc.view.layer.addSublayer(self.bgGradient(frame: self.view.frame))

        self.navigationController?.view.layer.add(self.bottomToTopTransition(), forKey: kCATransition)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(vc, animated: false)
    }

    @IBAction func goScan(_ sender: Any) {
        print("scan")

        let vc = UIViewController.init()
        vc.view.layer.addSublayer(self.bgGradient(frame: self.view.frame))

        self.navigationController?.view.layer.add(self.bottomToTopTransition(), forKey: kCATransition)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(vc, animated: false)
    }

    @IBAction func goWallet(_ sender: Any) {
        print("wallet")
        
        let vc = UIViewController.init()
        vc.view.layer.addSublayer(self.bgGradient(frame: self.view.frame))

        self.navigationController?.view.layer.add(self.bottomToTopTransition(), forKey: kCATransition)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(vc, animated: false)
    }

// MARK: - UITableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: self.discoverCellIdentifier, for: indexPath) as? SVTableViewCell else {
            fatalError()
        }

        let item = self.dataSource[indexPath.row]

        cell.selectionStyle = .none

        cell.title = item.name
        cell.subtitle = item.information
        cell.avatar = item.avatar

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

// MARK: - UITableView Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)

        let vc = SVDetailBusinessViewController.init(nibName: "SVDetailBusinessViewController", bundle: nil)
        vc.businessItem = self.dataSource[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

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
