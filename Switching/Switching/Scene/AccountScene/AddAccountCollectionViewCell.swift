//
//  AddAcountCollectionViewCell.swift
//  Switching
//
//  Created by JNGSJN on 2020/10/16.
//

import UIKit

class AddAccountCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var addAccountImage: UIImageView!
    @IBOutlet weak var addAccountLabel: UILabel!
    
    func updateUI() {
        self.addAccountImage.layer.cornerRadius = self.addAccountImage.frame.height/2
        self.addAccountImage.clipsToBounds = true
    }
}
