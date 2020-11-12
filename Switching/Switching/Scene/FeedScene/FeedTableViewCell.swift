//
//  FeedTableViewCell.swift
//  Switching
//
//  Created by Sanghun Park on 2020/10/24.
//

import UIKit
import RealmSwift

class FeedTableViewCell: UITableViewCell {
    
    var tags: Array<String> = []
    
    @IBOutlet weak var feedfeedImageView: UIImageView!

    @IBOutlet weak var feedfeedTitleLabel: UILabel!
    @IBOutlet weak var feedfeedURLLabel: UILabel!
    @IBOutlet weak var feedfeedDateLabel: UILabel!
    @IBOutlet weak var feedTagsCollectionView: UICollectionView!
    
    func updateUI() {
        self.feedfeedImageView.layer.cornerRadius = 15
        self.feedTagsCollectionView.reloadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class FeedTagsCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var feedTagsLabel: UILabel!
}

extension FeedTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "feedTagsCell", for: indexPath) as! FeedTagsCollectionViewCell
        cell.feedTagsLabel.text = tags[indexPath.row]
        cell.contentView.layer.cornerRadius = 12
        cell.contentView.layer.masksToBounds = true;
        return cell
    }
    
    
}
