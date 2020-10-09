//
//  CharacterViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/09/27.
//

import UIKit

class CharacterViewController: UIViewController {
    
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
        if selectedButton == 0{
            SharedData.instance.selectedCharacter = "main"
        }
        else if selectedButton == 1{
            SharedData.instance.selectedCharacter = "sub"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in self.characterButtons {
            button.layer.cornerRadius = button.frame.width/2
            button.alpha = 0.6
        }

       
    }
}
