//
//  CharacterViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/09/27.
//

import UIKit

class CharacterViewController: UIViewController {
    
    @IBOutlet var characterButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for button in self.characterButtons {
            button.layer.cornerRadius = button.frame.width/2
            button.alpha = 0.5
        }

       
    }
}
