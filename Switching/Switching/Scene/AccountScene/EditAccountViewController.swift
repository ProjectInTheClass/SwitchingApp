//
//  EditAccountViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/10/16.
//

import UIKit

class EditAccountViewController: UIViewController {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBAction func cancelClicked(_ sender: UIButton) {
          self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
