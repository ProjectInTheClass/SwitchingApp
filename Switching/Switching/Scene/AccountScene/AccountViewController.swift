//
//  CharacterViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/09/27.
//

import UIKit

class AccountViewController: UIViewController {
    
    struct Account {
        var name: String
        var image = UIImage(named: "account1.png")
    }
    var accounts = [Account(name: "프로일잘러"),
                    Account(name: "프로집순이")]
    
    @IBAction func cancelClicked(_ sender: UIButton) {
          self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
//    @IBAction func characterButtonClicked(_ sender: UIButton) {
//        let selectedButton = sender.tag
//        for button in self.characterButtons {
//            if (button==sender) {
//                button.alpha = 1
//            } else {
//                button.alpha = 0.6
//            }
//        }
//        print("\(#function) \(selectedButton)")
//        if selectedButton == 0{
//            SharedData.instance.selectedCharacter = "main"
//        }
//        else if selectedButton == 1{
//            SharedData.instance.selectedCharacter = "sub"
//        }
//        NotificationCenter.default.post(name: Notification.Name("characterChanged"), object: characterButtons)
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AccountViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accounts.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cells : UICollectionViewCell?
        if indexPath.row < accounts.count {
            let existingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "accountCell", for: indexPath) as! AccountCollectionViewCell
            existingCell.accountNameLabel.text = accounts[indexPath.row].name
            existingCell.accountImage.image = accounts[indexPath.row].image
            existingCell.accountImage.layer.cornerRadius = 50
            cells = existingCell
        } else {
            let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addAccountCell", for: indexPath) as! AddAccountCollectionViewCell
            cells = addCell
        }
        return cells!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == accounts.count {
            print("추가하기")
        } else {
            print("버튼이 클릭됨 \(indexPath.row)")
        }
    }
}
