//
//  AccountViewController.swift
//  AccountPractice
//
//  Created by JNGSJN on 2020/10/21.
//

import UIKit

class AccountViewController: UIViewController {
    
    @IBOutlet weak var accountCollectionView: UICollectionView!
    @IBAction func cancelClicked(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("newCharacterCreated"), object: nil)
    }
    @objc func notificationReceived(notification: Notification) {
        self.accountCollectionView.reloadData()
    }
}

extension AccountViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        accounts.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cells : UICollectionViewCell?
        if indexPath.row < accounts.count {
            let account = accounts[indexPath.row]
            let existingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "accountCell", for: indexPath) as! AccountCollectionViewCell
            existingCell.accountNameLabel.text = account.name
            existingCell.accountImage.image = account.image
            existingCell.accountImage.layer.cornerRadius = 50
            cells = existingCell
        } else {
            let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addAccountCell", for: indexPath) as! AddAccountCollectionViewCell
            cells = addCell
            addCell.addAccountImage.layer.cornerRadius = 50
        }
        return cells!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == accounts.count {
            print("추가하기")
        } else {
            print("버튼이 클릭됨 \(indexPath.row)")
            sharedData = accounts[indexPath.row]
            NotificationCenter.default.post(name: Notification.Name("characterChanged"), object: nil)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
