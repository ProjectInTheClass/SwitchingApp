//
//  FeedViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/09/27.
//

import UIKit
import RealmSwift
import SwiftLinkPreview

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var feedTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let realm = SharedData.instance.realm
        var objects = realm.objects(Bookmark.self).filter("character = '\(SharedData.instance.selectedCharacter)'").filter("isTemp == False")
        var bookmarks = realm.objects(Bookmark.self).filter("character = 'main'").filter("isTemp == False")
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedfeedCell", for: indexPath) as! FeedTableViewCell
        let realm = SharedData.instance.realm
        if let bookmark: Bookmark = realm.objects(Bookmark.self).filter("character = '\(SharedData.instance.selectedCharacter)'").filter("isTemp == False")[indexPath.row]{
            cell.feedfeedURLLabel.text = bookmark.url
            cell.feedfeedTitleLabel.text = bookmark.desc
            
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("characterChanged"), object: nil)
    }
    
    @objc func notificationReceived(notification: Notification) {
        // Notification에 담겨진 object와 userInfo를 얻어 처리 가능
        self.feedTableView.reloadData()
    }
    
    @objc private func didPullToRefresh() {
        print("start refresh")
        self.feedTableView.reloadData()
        DispatchQueue.main.async {
            self.feedTableView.refreshControl?.endRefreshing()
        }
    }
    
    
    private func mainCharacter(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Main") { [weak self] (_, _, _) in
            print("mainCharacter clicked \(indexPath.row)")
        }
        return action
    }
    
    private func subCharacter(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Sub") { [weak self] (_, _, _) in
            print("subCharacter clicked \(indexPath.row)")
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
            self?.feedTableView.reloadData()
            print("delete clicked \(indexPath.row)")
        }
        return action
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let mainCharacterBtn = self.mainCharacter(rowIndexPathAt: indexPath)
        let subCharacterBtn = self.subCharacter(rowIndexPathAt: indexPath)
        let deleteBtn = self.delete(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [mainCharacterBtn, subCharacterBtn, deleteBtn])
        return swipe
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
