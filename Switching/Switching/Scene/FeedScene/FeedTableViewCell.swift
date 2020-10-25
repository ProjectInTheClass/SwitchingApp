//
//  FeedTableViewCell.swift
//  Switching
//
//  Created by Sanghun Park on 2020/10/24.
//

import UIKit
import RealmSwift

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var feedfeedImageView: UIImageView!
    @IBOutlet weak var feedfeedTitleLabel: UILabel!
    @IBOutlet weak var feedfeedURLLabel: UILabel!
    @IBOutlet weak var feedfeedDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
