//
//  SVIntroViewController.swift
//  Survyy
//
//  Created by Guillermo Delgado on 08/08/2017.
//  Copyright © 2017 Survyy Sp z.o.o. All rights reserved.
//

import UIKit
import ZLSwipeableViewSwift

class SVIntroViewController: SVBaseViewController {

    @IBOutlet var swipeableView: ZLSwipeableView! = ZLSwipeableView()
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!

    var cardList = [SVCardView]()
    var cardIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.continueButton.alpha = 0
        view.addSubview(self.swipeableView)

        self.swipeableView.didSwipe = { view, direction, vector in
            self.pageControl.currentPage += 1
            self.checkForContinueButton()
        }

        self.swipeableView.didDisappear = { view in
            self.checkForContinueButton()
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.swipeableView.nextView = {

            if self.cardList.isEmpty {
                self.loadCardViews()
            }

            let card = self.cardList[self.cardIndex]

            if self.cardIndex < self.cardList.count - 1 {
                self.cardIndex += 1
            }

            return card
        }
    }

    @IBAction func doContinue(_ sender: UIButton) {
        self.animateButton(btn: sender)
        self.dismiss(animated: false, completion: nil)
    }

// MARK: - internal methods

    func loadCardViews() {

        let card1 = SVCardView.init(frame: self.swipeableView.bounds,
                                    title: "1. Placeholder for a title",
                                    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus hendrerit quam libero, vitae volutpat dolor ornare vel. Duis consequat lorem in imperdiet finibus. ",
                                    cardView: UIImageView.init(image: UIImage.init(named: "placeholder")))
        self.cardList.append(card1)

        let card2 = SVCardView.init(frame: self.swipeableView.bounds,
                                    title: "2. Here another title",
                                    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus hendrerit quam libero, vitae volutpat dolor ornare vel.",
                                    cardView: UIImageView.init(image: UIImage.init(named: "placeholder")))
        self.cardList.append(card2)

        let card3 = SVCardView.init(frame: self.swipeableView.bounds,
                                    title: "3. Still here? almost there",
                                    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus hendrerit quam Duis consequat lorem in imperdiet finibus. ",
                                    cardView: UIImageView.init(image: UIImage.init(named: "placeholder")))
        self.cardList.append(card3)

        let card4 = SVCardView.init(frame: self.swipeableView.bounds,
                                    title: "4. The last one I promise",
                                    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus hendrerit quam libero, vitae volutpat dolor Duis consequat lorem in imperdiet finibus. ",
                                    cardView: UIImageView.init(image: UIImage.init(named: "placeholder")))
        self.cardList.append(card4)

        let card5 = SVCardView.init(frame: self.swipeableView.bounds,
                                    title: "4. for real, the last one",
                                    description: "Lorem ipsum dolor sit amet, consectetur libero, vitae volutpat dolor Duis consequat lorem in imperd",
                                    cardView: UIImageView.init(image: UIImage.init(named: "placeholder")))
        self.cardList.append(card5)

        self.pageControl.numberOfPages = self.cardList.count
    }

    func checkForContinueButton() {
        if self.swipeableView.history.count == self.cardList.count - 1 {
            UIView.animate(withDuration: 0.2, animations: {
                self.continueButton.alpha = 1
            })
        }
    }
}
