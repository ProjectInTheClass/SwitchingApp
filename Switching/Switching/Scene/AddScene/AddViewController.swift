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
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet var characterButtons: [UIButton]!
    
    var selectedCharact: Character?
    var bookmarkList: TempBookmarkList?
    
    @IBAction func characterButtonClicked(_ sender: UIButton) {
        let selectedButton = sender.tag
        for button in self.characterButtons {
            if (button==sender) {
                button.alpha = 1
            } else {
                button.alpha = 0.6
            }
        }
        print("\(#function) \(selectedButton)")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in self.characterButtons {
            button.layer.cornerRadius = button.frame.width/2
            button.alpha = 0.6
        }
    }
    
    @IBAction func addBoomarkButtonPressed(_ sender: UIButton) {
        
        let url = self.urlTextField.text
        let title = self.titleTextField.text
        let tag = self.tagTextField.text
        let character = self.characterButtons
        
        let bookmark = Bookmark()
        
        bookmark.url = url!
        bookmark.desc = title!
        bookmark.character = "main"
        bookmark.isTemp = false
        
        guard var fileURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.switching.Switching"
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
    
}
