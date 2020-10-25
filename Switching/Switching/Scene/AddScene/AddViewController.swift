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
    
    var selectedCharact: Character?
    var bookmarkList: TempBookmarkList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelBookmarkButtonPressed(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addBoomarkButtonPressed(_ sender: UIButton) {
        
        let url = self.urlTextField.text
        let title = self.titleTextField.text
        
        let bookmark = Bookmark()
        
        bookmark.url = url!
        bookmark.desc = title!
        bookmark.character = "main"
        bookmark.isTemp = false
        
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
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
