//
//  SVAvatarPickerViewController.swift
//  ChatFirebase
//
//  Created by Guillermo Delgado on 30/05/2017.
//  Copyright © 2017 ChatFirebase. All rights reserved.
//

import UIKit
import RDGliderViewController_Swift

protocol SVAvatarPickerViewControllerDelegate: class {
    func avatarWasPicked(avatar: String)
}

class SVAvatarPickerViewController: RDGliderContentViewController,
                                    UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    let reuseIdentifier = "cell"

    weak var delegate: SVAvatarPickerViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier,
                                                      for: indexPath as IndexPath) as UICollectionViewCell
        let avatarName = "avatar" + String(indexPath.row)
        let imageView = UIImageView.init(image: UIImage(named: avatarName))
        imageView.frame = CGRect(x: 0, y: 0,
                                 width: cell.frame.width, height: cell.frame.height)
        cell.contentView.addSubview(imageView)

        let cellTap = UITapGestureRecognizer.init(target: self,
                                                  action:#selector(self.collectionViewCellDidTap(_:)))
        cell.addGestureRecognizer(cellTap)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let size = UIScreen.main.bounds.size.width / 3 - 10
        return CGSize(width: size, height: size)
    }

    func collectionViewCellDidTap(_ recognizer: UIGestureRecognizer) {

        let indxPath = self.collectionView.indexPathForItem(at: recognizer.location(in: self.collectionView))
        if indxPath?.row != nil {
            let avatarName = "avatar" + String((indxPath?.row)!)
            delegate?.avatarWasPicked(avatar: avatarName)
        }
    }
}
