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
        guard var fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.switching.Switching") else {
                print("Container URL is nil")
                return 0
        }

        fileURL.appendPathComponent("shared.realm")

        Realm.Configuration.defaultConfiguration = Realm.Configuration(fileURL: fileURL)

        let realm = try! Realm(fileURL: fileURL)
        return realm.objects(Bookmark.self).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! DraftTableViewCell
        guard var fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.switching.Switching") else {
                print("Container URL is nil")
                return cell
        }

        fileURL.appendPathComponent("shared.realm")

        Realm.Configuration.defaultConfiguration = Realm.Configuration(fileURL: fileURL)

        let realm = try! Realm(fileURL: fileURL)
        if let bookmark: Bookmark = realm.objects(Bookmark.self)[indexPath.row]{
            cell.feedDateLabel.text = bookmark.url
            cell.feedTitleLabel.text = bookmark.desc
            
            let slp = SwiftLinkPreview(session: URLSession.shared, workQueue: SwiftLinkPreview.defaultWorkQueue, responseQueue: DispatchQueue.main, cache: DisabledCache.instance)
            slp.preview(bookmark.url,
                        onSuccess: {
                            result in
                            if let imageUrl = result.image{
                                if let imageUrl: URL = URL(string: imageUrl){
                                    cell.feedImageView.load(url: imageUrl)
                                }
                            }
                        }, onError: {error in print("slp error")})
        }
        return cell
    }
    
  
    @IBOutlet weak var characterButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = addButton.frame.height/2
        characterButton.layer.cornerRadius = characterButton.frame.height/2
        self.draftTableView.delegate = self
        self.draftTableView.dataSource = self
        // Do any additional setup after loading the view.
        
        self.draftTableView.refreshControl = UIRefreshControl()
        self.draftTableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    @objc private func didPullToRefresh() {
        print("start refresh")
        self.draftTableView.reloadData()
        self.viewDidLoad()
        DispatchQueue.main.async {
            self.draftTableView.refreshControl?.endRefreshing()
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
            guard let self = self else {return}
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

