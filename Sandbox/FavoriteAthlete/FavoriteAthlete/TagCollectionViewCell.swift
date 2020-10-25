//
//  TagCollectionViewCell.swift
//  FavoriteAthlete
//
//  Created by JNGSJN on 2020/10/18.
//

import UIKit

class TagCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tagButton: UIButton!
    
    func update() {
        contentView.layer.cornerRadius = 16
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true;
    }
}
