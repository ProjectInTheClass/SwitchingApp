//
//  AddViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/10/02.
//

import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var tagTextField: UITextField!
    @IBOutlet var characterButtons: [UIButton]!
    
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
}
