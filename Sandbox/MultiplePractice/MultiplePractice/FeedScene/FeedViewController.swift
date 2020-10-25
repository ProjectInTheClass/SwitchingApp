//
//  FeedViewController.swift
//  MultiplePractice
//
//  Created by JNGSJN on 2020/10/02.
//

import UIKit

struct Tag{
    let name: String
    var isSelected: Bool
}
var tags: Array<Tag> = []

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func appendData() {
        tags = [Tag(name: "UX디자인", isSelected: false),
                Tag(name: "UIKit", isSelected: false),
                Tag(name: "swift", isSelected: false),
                Tag(name: "CSS", isSelected: false),
                Tag(name: "HTML", isSelected: false),
                Tag(name: "JS", isSelected: false),
                Tag(name: "디자인소스", isSelected: false),
                Tag(name: "GUI", isSelected: false)]
    }
    
    func tagsSelected() -> Array<Tag> {
            return tags.filter{$0.isSelected == true}
    }
    
    @IBAction func unwindFeed (segue : UIStoryboardSegue) {}
    @IBOutlet weak var tagCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appendData()
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        tagCollectionView.reloadData()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tagCount = tagsSelected().count
        if tagCount == 0 {
           return 1
        } else {
            return tagCount
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell",
                                                            for: indexPath) as? TagCollectionViewCell
        else {
            return TagCollectionViewCell()
        }
        let tagCount = tagsSelected().count
        if tagCount == 0 {
            cell.tagButton?.setTitle("See All", for: .normal)
        } else {
            cell.tagButton?.setTitle(tagsSelected()[indexPath.row].name, for: .normal)
        }
        cell.contentView.layer.cornerRadius = 16
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true;
        
        return cell
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
