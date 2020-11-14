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
    
    @IBOutlet var emptyFeedView: UIView!
    @IBOutlet var tagView: UIView!
    @IBOutlet weak var feedTableView: UITableView!{
        didSet{
            feedTableView.tableHeaderView = tagView
        }
    }
    @IBOutlet weak var filteredTagsCollectionView: UICollectionView!
    @IBAction func unwindVC (segue : UIStoryboardSegue) {}
    
    @IBOutlet weak var accountButton: UIButton!{
        didSet{
            accountButton.layer.cornerRadius = accountButton.frame.height/2
            accountButton.layer.borderColor = UIColor.clear.cgColor
            accountButton.layer.borderWidth = 0.5
        }
    }
    @IBOutlet weak var addButton: UIButton!{
        didSet{
            addButton.layer.cornerRadius = addButton.frame.height/2
            addButton.layer.shadowColor = UIColor(named: "SwitchingBlue")?.cgColor
            addButton.layer.shadowOffset = CGSize(width: 2, height: 2)
            addButton.layer.shadowRadius = 5
            addButton.layer.shadowOpacity = 0.3
        }
    }
    
    
    var bookmarks: [Bookmark] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bookmarks.count == 0 {
            tableView.backgroundView = emptyFeedView
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        return bookmarks.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedfeedCell", for: indexPath) as! FeedTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let realm = SharedData.instance.realm
        let bookmark: Bookmark = bookmarks[indexPath.row]
        cell.feedfeedURLLabel.text = bookmark.url
        cell.feedfeedTitleLabel.text = bookmark.desc
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        cell.feedfeedDateLabel.text = dateFormatter.string(from: bookmark.createDate)
        
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
                        }, onError: {error in cell.feedfeedImageView.image = UIImage(named: "noimage")})
            
        } else if let data = bookmark.image{
            cell.feedfeedImageView.image = UIImage(data: data)
        }
        
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.feedTableView.delegate = self
        self.feedTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        self.feedTableView.refreshControl = UIRefreshControl()
        self.feedTableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "북마크 검색"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        updateBookmarksData()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("refreshFeedView"), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.filteredTagsCollectionView.reloadData()
        print("\(FeedFilterViewController.filteredTags)을 FeedVC에서 표시")
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
        if FeedFilterViewController.filteredTags.count == 0{
            for bookmark in bookmarks_{
                bookmarks.append(bookmark)
            }
        }else{
            for bookmark in bookmarks_{
                var count = 0
                for tag in bookmark.tags{
                    if FeedFilterViewController.filteredTags.contains(tag.tag){
                        count = count + 1
                    }
                }
                if count == FeedFilterViewController.filteredTags.count{
                    bookmarks.append(bookmark)
                }
            }
        }
        bookmarks.reverse()
        accountButton.clipsToBounds = true
        accountButton.contentMode = .scaleAspectFill
        if realm.objects(Character.self).filter("character = '\(SharedData.instance.selectedCharacter)'").count > 0{
            if let imageData = realm.objects(Character.self).filter("character = '\(SharedData.instance.selectedCharacter)'").first!.image{
                accountButton.setBackgroundImage(UIImage(data: imageData), for: .normal)
            }else{
                accountButton.setBackgroundImage(UIImage(named: "account1"), for: .normal)
            }
        }else{
            accountButton.setBackgroundImage(UIImage(named: "account1"), for: .normal)
        }
        
        self.feedTableView.reloadData()
    }
    
    private func edit(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let realm = SharedData.instance.realm
        let bookmark: Bookmark = bookmarks[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "수정") { [weak self] (_, _, _) in
            let storyboard = UIStoryboard.init(name: "Add", bundle: nil)
            guard let addVC = storyboard.instantiateViewController(withIdentifier: "addVC") as? AddViewController else {
                return
            }
            let addNav = UINavigationController(rootViewController: addVC)
            addVC.selectedBookmark = bookmark
            self?.present(addNav, animated: true, completion: nil)
        }
        return action
    }
    
    private func delete(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let realm = SharedData.instance.realm
        let bookmark: Bookmark = bookmarks[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
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
        let bookmark: Bookmark = bookmarks[indexPath.row]
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
extension FeedViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
  }
}

extension FeedViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    updateBookmarksData()
    let searchBar = searchController.searchBar
    if let text = searchBar.text{
        if text == ""{
            self.feedTableView.reloadData()
            return
        }
        let temp = bookmarks
        bookmarks.removeAll()
        for bookmark in temp{
            if bookmark.desc.contains(text){
                print("contain")
                bookmarks.append(bookmark)
            }
        }
    }
    self.feedTableView.reloadData()
  }
}


class FilteredTagsCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var filteredTagButton: UIButton!
}
extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if FeedFilterViewController.filteredTags.count == 0 {
            return 1
        } else {
            return FeedFilterViewController.filteredTags.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "filteredTagsCell", for: indexPath) as! FilteredTagsCollectionViewCell
        if FeedFilterViewController.filteredTags.count == 0 {
            cell.filteredTagButton?.setTitle("See All", for: .normal)
        } else {
            cell.filteredTagButton?.setTitle(FeedFilterViewController.filteredTags[indexPath.row], for: .normal)
        }
        cell.contentView.layer.cornerRadius = cell.contentView.frame.height/2
        cell.contentView.layer.borderWidth = 1.5
        cell.contentView.layer.borderColor = UIColor(named: "SwitchingBlue")?.cgColor
        cell.contentView.layer.masksToBounds = true;
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if FeedFilterViewController.filteredTags.count != 0 {
            print(indexPath.row)
            FeedFilterViewController.filteredTags.remove(at: indexPath.row)
            filteredTagsCollectionView.reloadData()
        }
    }
}
