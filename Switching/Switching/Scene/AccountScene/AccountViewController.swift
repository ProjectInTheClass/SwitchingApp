//
//  CharacterViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/09/27.
//

import UIKit

class AccountViewController: UIViewController {
    var isEditMode: Bool = false
    @IBOutlet weak var characterCollectionView: UICollectionView!
    @IBAction func cancelClicked(_ sender: UIButton) {
          self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var editBtn: UIButton!
    
    @IBAction func editClicked(_ sender: Any) {
        isEditing = !isEditing
        if isEditing{
            editBtn.setTitle("완료", for: .normal)
        }else{
            editBtn.setTitle("수정", for: .normal)
        }
        self.characterCollectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("newCharacterCreated"), object: nil)
    }
    @objc func notificationReceived(notification: Notification) {
        self.characterCollectionView.reloadData()
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
            
            if let imageData = character.image{
                existingCell.accountImage.image = UIImage(data: imageData)
            }else{
                existingCell.accountImage.image = UIImage(named: "account1.png")
            }
            if isEditing{
                existingCell.editImage.image = UIImage(named: "edit")
            }else{
                existingCell.editImage.image = nil
            }
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
            if isEditing{
                let storyboard = UIStoryboard.init(name: "Account", bundle: nil)
                guard let editVC = storyboard.instantiateViewController(identifier: "editVC") as? EditAccountViewController else{
                    return
                }
                let realm  = SharedData.instance.realm
                editVC.editAccount = realm.objects(Character.self)[indexPath.row]
                let editNav = UINavigationController(rootViewController: editVC)
                self.present(editNav, animated: true, completion:nil)
            }else{
                print("버튼이 클릭됨 \(indexPath.row)")
                SharedData.instance.selectedCharacter = realm.objects(Character.self)[indexPath.row].character
                NotificationCenter.default.post(name: Notification.Name("refreshFeedView"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("refreshDraftView"), object: nil)
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
