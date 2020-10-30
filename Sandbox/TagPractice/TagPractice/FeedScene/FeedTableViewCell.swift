//
//  FeedTableViewCell.swift
//  TagPractice
//
//  Created by JNGSJN on 2020/10/28.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    var indexPathRow: Int! = nil
    
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var feedTitleLabel: UILabel!
    @IBOutlet weak var feedURLLabel: UILabel!
    @IBOutlet weak var feedTagsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension FeedTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let bookmarkTags = bookmarks[indexPathRow].tags
        return bookmarkTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let bookmarkTags = bookmarks[indexPathRow].tags
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookmarkTagsCell", for: indexPath) as! BookmarkTagsCollectionViewCell
        cell.bookmarkTagLabel.text = bookmarkTags[indexPath.row]
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.masksToBounds = true;
        return cell
    }
    
    
}
