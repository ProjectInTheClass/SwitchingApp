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
    
    @IBOutlet weak var addBtn: UIBarButtonItem!
    var selectedTags: Array<String> = [] //임시데이터
    var loadedTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTextField.delegate = self
        titleTextField.delegate = self
        urlTextField.addTarget(self, action: #selector(textFieldsIsNotEmpty), for: .editingChanged)
        addBtn.isEnabled = false
        if let savedBookmark: Bookmark = selectedBookmark{
            urlTextField.text = savedBookmark.url
            titleTextField.text = savedBookmark.desc
            for tag in savedBookmark.tags{
                if !selectedTags.contains(tag.tag) {
                selectedTags.append(tag.tag)
                    print("test3")
                }
            }
        }
    }
    
    @objc func textFieldsIsNotEmpty(sender: UITextField) {
        guard let url = urlTextField.text, !url.isEmpty else {
            self.addBtn.isEnabled = false
            return
        }
        addBtn.isEnabled = true
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
            let realm = SharedData.instance.realm
            do {
                try realm.write{
                    savedBookmark.url = urlTextField.text!
                    savedBookmark.desc = titleTextField.text!
                    savedBookmark.isTemp = false
                    savedBookmark.tags.removeAll()
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

            let realm = SharedData.instance.realm
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
        NotificationCenter.default.post(name: Notification.Name("refreshDraftView"), object: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getTitle(_ sender: Any) {
        let urlPath: String = urlTextField.text!
//        guard let url = URL(string: urlPath) else {return}
//        var request = URLRequest(url: url)
//        request.httpMethod = "get"
//        print(request)
        let url = NSURL(string: urlPath)
        let session = URLSession.shared
        let task = session.dataTask(with: url! as URL) { (data, response, error) in
            guard let loadedData = data else { return }
            guard let contents = String(data: loadedData, encoding: .utf8) else {return}
            
            var startRange: Range<String.Index>? = nil
            var endRange: Range<String.Index>? = nil
            
            if let stRange: Range<String.Index> = contents.range(of: "<title>") {
                let stIndex: Int = (contents.distance(from: contents.startIndex, to: stRange.lowerBound))
                startRange = stRange
//                let substring = contents[...stRange.lowerBound]
            }
            if let edRange: Range<String.Index> = contents.range(of: "</title>") {
                let edIndex: Int = (contents.distance(from: contents.startIndex, to: edRange.lowerBound))
                endRange = edRange
            }
            if let sr = startRange, let er = endRange{
                let substring = contents[sr.upperBound..<er.lowerBound]
                print(substring)
                self.loadedTitle = String(substring)
                DispatchQueue.main.async {
                    self.titleTextField.text = String(substring)
                }
            }
            
        }
        task.resume()
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
            cell.selectedTagButton?.setTitle("지정된 태그가 없습니다", for: .normal)
            cell.selectedTagButton.setTitleColor(UIColor.darkGray, for: .normal)
            cell.contentView.backgroundColor = UIColor.clear
        } else {
            cell.selectedTagButton?.setTitle(selectedTags[indexPath.row], for: .normal)
            cell.selectedTagButton.setTitleColor(UIColor.white, for: .normal)
            cell.contentView.backgroundColor = UIColor(named: "SwitchingBlue")
        }
        cell.contentView.layer.cornerRadius = 15
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true;
        return cell
    }
    
    
}

extension AddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension AddViewController {
// Ends editing view when touches to view
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      super.touchesBegan(touches, with: event)
      self.view.endEditing(true)
    }
}
