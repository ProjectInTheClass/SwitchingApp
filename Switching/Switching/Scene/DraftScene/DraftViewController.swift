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

class DraftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var emptyDraftView: UIView!
    @IBOutlet weak var emptyDraftLabel: UILabel!{
        didSet{
            emptyDraftLabel.text = "아직 임시보관함에 저장된 북마크가 존재하지 않아요!\n사파리나 크롬 등에서 공유하기로 추가한 북마크가 여기에 보관됩니다!😘"
        }
    }
    @IBOutlet weak var draftTableView: UITableView!{
        didSet{
            draftTableView.separatorInset.left = 0
        }
    }
    
    @IBOutlet weak var accountButton: UIButton!{
        didSet{
            accountButton.layer.cornerRadius = accountButton.frame.height/2
            accountButton.layer.borderColor = UIColor.clear.cgColor
            accountButton.layer.borderWidth = 0.5
            accountButton.imageView?.contentMode = .scaleAspectFit
            accountButton.clipsToBounds = true
        }
    }
    
    var bookmarks: [Bookmark] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = SharedData.instance.realm
        var objects = realm.objects(Bookmark.self).filter("character = '\(SharedData.instance.selectedCharacter)'").filter("isTemp == True")
        if objects.count == 0 {
            tableView.backgroundView = emptyDraftView
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! DraftTableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        let realm = SharedData.instance.realm
        let bookmark: Bookmark = realm.objects(Bookmark.self).filter("character = '\(SharedData.instance.selectedCharacter)'").filter("isTemp == True")[indexPath.row]
        cell.feedURLLabel.text = bookmark.url
        cell.feedTitleLabel.text = bookmark.desc
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        cell.feedDateLabel.text = dateFormatter.string(from: bookmark.createDate)
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
                                            if let desc = result.title{
                                                bookmark.desc = desc
                                            }
                                        }
                                        cell.feedImageView.image = UIImage(data: data)
                                        cell.feedTitleLabel.text = bookmark.desc
                                    }
                                }
                            }
                        }, onError: {error in cell.feedImageView.image = UIImage(named: "noimage")})
            if bookmark.image == nil{
                try! realm.write{
                    bookmark.image = UIImage(named: "noimage")?.pngData()
                    cell.feedImageView.image = UIImage(named: "noimage")
                }
            }
            
        } else if let data = bookmark.image{
            cell.feedImageView.image = UIImage(data: data)
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.draftTableView.delegate = self
        self.draftTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        self.draftTableView.refreshControl = UIRefreshControl()
        self.draftTableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        self.updateTempBookmarksData()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("refreshDraftView"), object: nil)
    
        updateCharacterImage()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.updateTempBookmarksData()
        self.draftTableView.reloadData()
    }
    
    private func updateCharacterImage(){
        let realm = SharedData.instance.realm
        if realm.objects(Character.self).filter("character = '\(SharedData.instance.selectedCharacter)'").count > 0{
            if let imageData = realm.objects(Character.self).filter("character = '\(SharedData.instance.selectedCharacter)'").first!.image{
                accountButton.setImage(UIImage(data: imageData), for: .normal)
            }else{
                accountButton.setImage(UIImage(named: "account1"), for: .normal)
            }
        }else{
            accountButton.setImage(UIImage(named: "account1"), for: .normal)
        }
    }
    
    @objc func notificationReceived(notification: Notification) {
        // Notification에 담겨진 object와 userInfo를 얻어 처리 가능
        updateCharacterImage()
        self.updateTempBookmarksData()
        self.draftTableView.reloadData()
    }
    
    @objc private func didPullToRefresh() {
        print("start refresh")
        self.draftTableView.reloadData()
        DispatchQueue.main.async {
            self.draftTableView.refreshControl?.endRefreshing()
        }
    }
    
    private func updateTempBookmarksData() {
        let realm = SharedData.instance.realm
        let bookmarks_: Results<Bookmark> = realm.objects(Bookmark.self).filter("character = '\(SharedData.instance.selectedCharacter)'").filter("isTemp == True")
        bookmarks = []
        for bookmark in bookmarks_{
            bookmarks.append(bookmark)
        }
        if realm.objects(Character.self).filter("character = '\(SharedData.instance.selectedCharacter)'").count > 0{
            if let imageData = realm.objects(Character.self).filter("character = '\(SharedData.instance.selectedCharacter)'").first!.image{
                accountButton.setImage(UIImage(data: imageData), for: .normal)
            }else{
                accountButton.setImage(UIImage(named: "account1"), for: .normal)
            }
        }else{
            accountButton.setImage(UIImage(named: "account1"), for: .normal)
        }
        self.draftTableView.reloadData()
    }
    
    
    private func edit(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "수정") { [weak self] (_, _, _) in
            let storyboard = UIStoryboard.init(name: "Add", bundle: nil)
            guard let addVC = storyboard.instantiateViewController(withIdentifier: "addVC") as? AddViewController else {
                return
            }
            let addNav = UINavigationController(rootViewController: addVC)
            let realm = SharedData.instance.realm
            var objects = realm.objects(Bookmark.self).filter("character = '\(SharedData.instance.selectedCharacter)'").filter("isTemp == True")
            addVC.selectedBookmark = objects[indexPath.row]
            self?.present(addNav, animated: true, completion: nil)
        }
        return action
    }
    
    private func delete(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, _) in
            let realm = SharedData.instance.realm
            let bookmark: Bookmark = realm.objects(Bookmark.self).filter("character = '\(SharedData.instance.selectedCharacter)'").filter("isTemp == True")[indexPath.row]
            try! realm.write{
                realm.delete(bookmark)
            }
            self?.updateTempBookmarksData()
//            self?.draftTableView.reloadData()
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
        let bookmark: Bookmark = realm.objects(Bookmark.self).filter("character = '\(SharedData.instance.selectedCharacter)'").filter("isTemp == True")[indexPath.row]
        guard let url = URL(string: bookmark.url) else {
            let alert = UIAlertController(title: "Please check URL", message: "URL을 확인해주세요!" , preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        if ["http", "https"].contains(url.scheme?.lowercased() ?? ""){
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Please check URL", message: "URL을 확인해주세요!" , preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        print("safariviewController 실행됨")
        tableView.deselectRow(at: indexPath, animated: true) //select 표시 해제
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

func getImageDataFromURL(url: URL) -> Data? {
    var data: Data?
    data = try? Data(contentsOf: url)
    return data
}
