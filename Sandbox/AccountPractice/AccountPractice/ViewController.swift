//
//  ViewController.swift
//  AccountPractice
//
//  Created by JNGSJN on 2020/10/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var accountLabel: UILabel!
    
    func accountSetUp() {
        accountButton.setImage(sharedData.image, for: .normal)
        accountButton.layer.cornerRadius = accountButton.frame.height/2
        accountButton.clipsToBounds = true
        accountLabel.text = sharedData.name
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        accountSetUp()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("characterChanged"), object: nil)
    }
    
    @objc func notificationReceived(notification: Notification) {
        accountSetUp()
        // Notification에 담겨진 object와 userInfo를 얻어 처리 가능
    }
}

