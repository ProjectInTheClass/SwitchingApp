//
//  AccountCollectionViewCell.swift
//  Switching
//
//  Created by JNGSJN on 2020/10/16.
//

import UIKit

class AccountCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var accountView: UIView!
    @IBOutlet weak var accountImage: UIImageView!
    @IBOutlet weak var accountNameLabel: UILabel!
    @IBOutlet weak var editImage: UIImageView!
    
    func updateUI() {
        self.accountView.layer.cornerRadius = self.accountView.frame.height/2
        self.accountView.clipsToBounds = true
    }
}
