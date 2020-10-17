//
//  CharacterViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/09/27.
//

import UIKit

class AccountViewController: UIViewController {
    @IBAction func cancelClicked(_ sender: UIButton) {
          self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AccountViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let realm  = SharedData.instance.realm
        return realm.objects(Character.self).count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cells : UICollectionViewCell?
        let realm  = SharedData.instance.realm
        if indexPath.row < realm.objects(Character.self).count {
            let character = realm.objects(Character.self)[indexPath.row]
            let existingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "accountCell", for: indexPath) as! AccountCollectionViewCell
            existingCell.accountNameLabel.text = character.character
            existingCell.accountImage.image = UIImage(named: "account1.png")
            existingCell.accountImage.layer.cornerRadius = 50
            cells = existingCell
        } else {
            let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addAccountCell", for: indexPath) as! AddAccountCollectionViewCell
            cells = addCell
        }
        return cells!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let realm  = SharedData.instance.realm
        if indexPath.row == realm.objects(Character.self).count {
            print("추가하기")
        } else {
            print("버튼이 클릭됨 \(indexPath.row)")
            SharedData.instance.selectedCharacter = realm.objects(Character.self)[indexPath.row].character
            NotificationCenter.default.post(name: Notification.Name("characterChanged"), object: nil)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
