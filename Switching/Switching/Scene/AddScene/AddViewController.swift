//
//  AddViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/10/02.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController {

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var selectedTagsCollectionView: UICollectionView!
    @IBAction func unwindVC (segue : UIStoryboardSegue) {}
    
    var selectedCharact: Character?
    var bookmarkList: TempBookmarkList?
    var selectedBookmark: Bookmark?
    
    var selectedTags: Array<String> = [] //임시데이터
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedBookmark: Bookmark = selectedBookmark{
            urlTextField.text = savedBookmark.url
            titleTextField.text = savedBookmark.desc
            for tag in savedBookmark.tags{
                if !selectedTags.contains(tag.tag) {
                selectedTags.append(tag.tag)
                    print("test")
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.selectedTagsCollectionView.reloadData()
        print("\(selectedTags)을 AddVC에서 표시")
    }
    
    @IBAction func cancelBookmarkButtonPressed(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBoomarkButtonPressed(_ sender: Any) {
        if let savedBookmark: Bookmark = selectedBookmark{
            urlTextField.text = savedBookmark.url
            titleTextField.text = savedBookmark.desc
            let realm = SharedData.instance.realm
            do {
                try realm.write{
                    savedBookmark.url = urlTextField.text!
                    savedBookmark.desc = titleTextField.text!
                    savedBookmark.isTemp = false
                    for tag in selectedTags{
                        let tag_ = Tag()
                        tag_.tag = tag
                        savedBookmark.tags.append(tag_)
                    }
                }
            } catch {
                print("Error Add \(error)")
            }
        }else{
            let url = self.urlTextField.text
            let title = self.titleTextField.text
            
            let bookmark = Bookmark()
            
            bookmark.url = url!
            bookmark.desc = title!
            bookmark.character = SharedData.instance.selectedCharacter
            bookmark.isTemp = false
            
            for tag in selectedTags{
                let tag_ = Tag()
                tag_.tag = tag
                bookmark.tags.append(tag_)
            }
            
            guard var fileURL = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: "group.switching.SwitchingApp"
            ) else {
                print("Container URL is nil")
                return
            }

            fileURL.appendPathComponent("shared.realm")
            
            let realm = try! Realm(fileURL: fileURL)
            do {
                try realm.write{
                    realm.add(bookmark)
                }
            } catch {
                print("Error Add \(error)")
            }
            print("add data done")
        }
        NotificationCenter.default.post(name: Notification.Name("refreshFeedView"), object: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBAction func selectTagsClicked(_ sender: Any) {
        guard let tagVC = self.storyboard?.instantiateViewController(identifier: "selectTags") as? AddSelectViewController else{
            return
        }
        tagVC.selectedTags = self.selectedTags
        tagVC.tags = self.selectedTags
        self.selectedTags = []
        self.navigationController?.pushViewController(tagVC, animated: true)
    }
    
}
class SelectedTagsCollectionViewCell: UICollectionViewCell{
    @IBOutlet weak var selectedTagButton: UIButton!
}
extension AddViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedTags.count == 0 {
            return 1
        } else {
            return selectedTags.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedTagsCell", for: indexPath) as! SelectedTagsCollectionViewCell
        if selectedTags.count == 0 {
            cell.selectedTagButton?.setTitle("등록된 태그가 없습니다", for: .normal)
        } else {
            cell.selectedTagButton?.setTitle(selectedTags[indexPath.row], for: .normal)
        }
        cell.contentView.layer.cornerRadius = 15
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true;
        return cell
    }
    
    
}
