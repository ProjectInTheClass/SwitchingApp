//
//  FeedViewController.swift
//  TagPractice
//
//  Created by JNGSJN on 2020/10/28.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet weak var feedsTableView: UITableView!
    @IBOutlet weak var filterTagsCollectionView: UICollectionView!
    
    func appendFeedsData(){
        bookmarks = [Bookmark(url: "https://www.naver.com", title: "네이버", tags: ["자주가는사이트","네이버"]),
                 Bookmark(url: "https://www.apple.com", title: "🍎", tags: ["자주가는사이트","애플"])]
    } //임시 북마크 데이터
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appendFeedsData()
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.filterTagsCollectionView.reloadData()
        print(selectedTags)
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedTableViewCell
        cell.feedURLLabel.text = bookmarks[indexPath.row].url
        cell.feedTitleLabel.text = bookmarks[indexPath.row].title
        cell.indexPathRow = indexPath.row
        return cell
    }
}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedTags.count == 0 {
            return 1
        } else {
            return selectedTags.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterTagsCell", for: indexPath) as! FilterTagsCollectionViewCell
        if selectedTags.count == 0 {
            cell.filterTagsButton?.setTitle("See All", for: .normal)
        } else {
            cell.filterTagsButton?.setTitle(selectedTags[indexPath.row], for: .normal)
        }
        cell.contentView.layer.cornerRadius = 15 //cell.contentView.frame.height/2 적용 오류
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true;
        return cell
    }
    
    
}
/*
 TagPractice
 
 [x]isSelected라는 bool값 없이 선택된 tag 뽑기
 [x]북마크에 해당되는 태그 콜렉션뷰로 표현하기
 [-]FilterDetailViewController에서 선택한 태그가 FeedViewController에서 보이기
    ->segue로 넘기지 않고 일단 vc 밖에서 처리
 [ ]filter 기능 테스트
 */
