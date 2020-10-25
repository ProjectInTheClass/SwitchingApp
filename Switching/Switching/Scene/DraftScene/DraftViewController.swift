//
//  FeedViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/09/27.
//

import UIKit
import RealmSwift
import SwiftLinkPreview

class DraftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var draftTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = SharedData.instance.realm
        var objects = realm.objects(Bookmark.self).filter("character = '\(SharedData.instance.selectedCharacter)'")
        objects = objects.filter("isTemp == True")
        print(objects.count)
        return objects.count
//        return realm.objects(Bookmark.self).filter("character = '\(SharedData.instance.selectedCharacter)'").count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! DraftTableViewCell
        let realm = SharedData.instance.realm
        if let bookmark: Bookmark = realm.objects(Bookmark.self).filter("isTemp == True")[indexPath.row]{
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
                            }, onError: {error in print("slp error")})
                
            } else if let data = bookmark.image{
                cell.feedImageView.image = UIImage(data: data)
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
        self.draftTableView.delegate = self
        self.draftTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        self.draftTableView.refreshControl = UIRefreshControl()
        self.draftTableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("characterChanged"), object: nil)
    }
    
    @objc func notificationReceived(notification: Notification) {
        // Notification에 담겨진 object와 userInfo를 얻어 처리 가능
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
            let addVc = storyboard.instantiateInitialViewController()!
            self?.present(addVc, animated: true, completion: nil)
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
