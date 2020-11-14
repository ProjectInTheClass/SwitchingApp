//
//  OnboardingContentViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/11/09.
//

import UIKit

class OnboardingContentViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    
    // MARK: - Properties
    
    var index = 0
    var heading = ""
    var subHeading = ""
    var contentImage = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        headingLabel.text = heading
        subHeadingLabel.text = subHeading
        contentImageView.image = UIImage(named: contentImage)
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
