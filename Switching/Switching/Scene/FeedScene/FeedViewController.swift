//
//  FeedViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/09/27.
//

import UIKit

class FeedViewController: UIViewController {
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addButton.layer.cornerRadius = addButton.frame.height/2
        accountButton.layer.cornerRadius = accountButton.frame.height/2
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
