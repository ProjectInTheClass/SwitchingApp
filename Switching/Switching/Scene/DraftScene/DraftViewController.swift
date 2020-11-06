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
    
    @IBOutlet weak var draftTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = SharedData.instance.realm
        var objects = realm.objects(Bookmark.self).filter("character = '\(SharedData.instance.selectedCharacter)'").filter("isTemp == True")
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! DraftTableViewCell
        let realm = SharedData.instance.realm
        if let bookmark: Bookmark = realm.objects(Bookmark.self).filter("character = '\(SharedData.instance.selectedCharacter)'").filter("isTemp == True")[indexPath.row]{
            cell.feedURLLabel.text = bookmark.url
            cell.feedTitleLabel.text = bookmark.desc
            
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
                                            cell.feedImageView.image = UIImage(data: data)
                                        }
                                    }
                                }
                            }, onError: {error in cell.feedImageView.image = UIImage(named: "noimage")})
                
            } else if let data = bookmark.image{
                cell.feedImageView.image = UIImage(data: data)
            }
        }
        return cell
    }
    
  
    @IBOutlet weak var accountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        accountButton.layer.cornerRadius = accountButton.frame.height/2
        self.draftTableView.delegate = self
        self.draftTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        self.draftTableView.refreshControl = UIRefreshControl()
        self.draftTableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("refreshDraftView"), object: nil)
        
        accountButton.clipsToBounds = true
        accountButton.contentMode = .scaleAspectFill
        updateCharacterImage()
    }
    
    private func updateCharacterImage(){
        let realm = SharedData.instance.realm
        if realm.objects(Character.self).filter("character = '\(SharedData.instance.selectedCharacter)'").count > 0{
            if let imageData = realm.objects(Character.self).filter("character = '\(SharedData.instance.selectedCharacter)'").first!.image{
                accountButton.setBackgroundImage(UIImage(data: imageData), for: .normal)
            }else{
                accountButton.setBackgroundImage(UIImage(named: "account1"), for: .normal)
            }
        }else{
            accountButton.setBackgroundImage(UIImage(named: "account1"), for: .normal)
        }
    }
    
    @objc func notificationReceived(notification: Notification) {
        // Notification에 담겨진 object와 userInfo를 얻어 처리 가능
        updateCharacterImage()
        self.draftTableView.reloadData()
    }
    
    @objc private func didPullToRefresh() {
        print("start refresh")
        self.draftTableView.reloadData()
        DispatchQueue.main.async {
            self.draftTableView.refreshControl?.endRefreshing()
        }
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
            let bookmark: Bookmark = realm.objects(Bookmark.self)[indexPath.row]
            try! realm.write{
                realm.delete(bookmark)
            }
            self?.draftTableView.reloadData()
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
        guard let url = URL(string: bookmark.url) else { return }
        let safariViewController = SFSafariViewController(url: url)
        print("safariviewController 실행됨")
        present(safariViewController, animated: true, completion: nil)
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
