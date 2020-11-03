//
//  FeedViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/09/27.
//

import UIKit
import RealmSwift
import SwiftLinkPreview
import SafariServices

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var filteredTags: Array<String> = [] //임시데이터
    
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var filteredTagsCollectionView: UICollectionView!
    @IBAction func unwindVC (segue : UIStoryboardSegue) {}
    var bookmarks: [Bookmark] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = SharedData.instance.realm
        return bookmarks.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedfeedCell", for: indexPath) as! FeedTableViewCell
        let realm = SharedData.instance.realm
        if let bookmark: Bookmark = bookmarks[indexPath.row]{
            cell.feedfeedURLLabel.text = bookmark.url
            cell.feedfeedTitleLabel.text = bookmark.desc
            cell.feedfeedDateLabel.text = "2020.10.26"//UI레이아웃 테스트
            cell.tags = getTagListOfSelectedBookmark(bookmark: bookmark)
            cell.updateUI()
            if bookmark.image == nil{
                let slp = SwiftLinkPreview(session: URLSession.shared, workQueue: SwiftLinkPreview.defaultWorkQueue, responseQueue: DispatchQueue.main, cache: DisabledCache.instance)
                slp.preview(bookmark.url,
                            onSuccess: {
                                result in
                                if let imageUrl = result.image{
                                    if let url = URL(string: imageUrl){
                                        if let data: Data = getImageDataFromURL(url: url){
                                            try! realm.write{
                                                bookmark.image = data
                                            }
                                            cell.feedfeedImageView.image = UIImage(data: data)
                                        }
                                    }
                                }
                            }, onError: {error in print("slp error")})
                
            } else if let data = bookmark.image{
                cell.feedfeedImageView.image = UIImage(data: data)
            }
        }
        return cell
    }
    
    
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = addButton.frame.height/2
        accountButton.layer.cornerRadius = accountButton.frame.height/2
        self.feedTableView.delegate = self
        self.feedTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        self.feedTableView.refreshControl = UIRefreshControl()
        self.feedTableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        updateBookmarksData()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("refreshFeedView"), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.filteredTagsCollectionView.reloadData()
        print("\(filteredTags)을 FeedVC에서 표시")
    }
    
    @objc func notificationReceived(notification: Notification) {
        // Notification에 담겨진 object와 userInfo를 얻어 처리 가능
        print("noti")
        updateBookmarksData()
    }
    
    @objc private func didPullToRefresh() {
        print("start refresh")
        updateBookmarksData()
        self.feedTableView.reloadData()
        DispatchQueue.main.async {
            self.feedTableView.refreshControl?.endRefreshing()
        }
    }
    
    private func updateBookmarksData() {
        let realm = SharedData.instance.realm
        let bookmarks_: Results<Bookmark> = realm.objects(Bookmark.self).filter("character = '\(SharedData.instance.selectedCharacter)'").filter("isTemp == False")
        bookmarks = []
        if filteredTags.count == 0{
            for bookmark in bookmarks_{
                bookmarks.append(bookmark)
            }
        }else{
            for bookmark in bookmarks_{
                for tag in bookmark.tags{
                    if filteredTags.contains(tag.tag){
                    bookmarks.append(bookmark)
                    break
                    }
                }
            }
        }
        accountButton.clipsToBounds = true
        accountButton.contentMode = .scaleAspectFill
        accountButton.setBackgroundImage(UIImage(named: "account1"), for: .normal)
        self.feedTableView.reloadData()
    }
    
    private func edit(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "수정") { [weak self] (_, _, _) in
            let storyboard = UIStoryboard.init(name: "Add", bundle: nil)
            guard let addVC = storyboard.instantiateViewController(withIdentifier: "addVC") as? AddViewController else {
                return
            }
            let addNav = UINavigationController(rootViewController: addVC)
            let realm = SharedData.instance.realm
            var objects = realm.objects(Bookmark.self).filter("character = '\(SharedData.instance.selectedCharacter)'").filter("isTemp == False")
            addVC.selectedBookmark = objects[indexPath.row]
            self?.present(addNav, animated: true, completion: nil)
        }
        return action
    }
    
    private func delete(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
            let realm = SharedData.instance.realm
            let bookmark: Bookmark = realm.objects(Bookmark.self)[indexPath.row]
            try! realm.write{
                realm.delete(bookmark)
            }
            self?.updateBookmarksData()
            print("delete clicked \(indexPath.row)")
        }
        return action
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editBtn = self.edit(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [editBtn])
        return swipe
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteBtn = self.delete(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [deleteBtn])
        return swipe
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let realm = SharedData.instance.realm
        let bookmark: Bookmark = realm.objects(Bookmark.self)[indexPath.row]
        guard let url = URL(string: bookmark.url) else { return }
        let safariViewController = SFSafariViewController(url: url)
        print("safariviewController 실행됨")
        present(safariViewController, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: true) //select 표시 해제
    }
}

//extension UIImageView {
//    func load(url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}
//
//func getImageDataFromURL(url: URL) -> Data? {
//    var data: Data?
//    data = try? Data(contentsOf: url)
//    return data
//}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
class FilteredTagsCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var filteredTagButton: UIButton!
}
extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if filteredTags.count == 0 {
            return 1
        } else {
            return filteredTags.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filteredTagsCell", for: indexPath) as! FilteredTagsCollectionViewCell
        if filteredTags.count == 0 {
            cell.filteredTagButton?.setTitle("See All", for: .normal)
        } else {
            cell.filteredTagButton?.setTitle(filteredTags[indexPath.row], for: .normal)
        }
        cell.contentView.layer.cornerRadius = 15 //cell.contentView.frame.height/2 적용 오류
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true;
        return cell
    }
    
    
}
