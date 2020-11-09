//
//  OnboardingViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/11/09.
//

import UIKit

class OnboardingViewController: UIViewController, onboardingPageViewControllerDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton! {
        didSet {
            nextButton.layer.cornerRadius = nextButton.frame.height/2
            nextButton.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var skipButton: UIButton!
    
    // MARK: - Properties
    
    var onboardingPageViewController: OnboardingPageViewController?
    
    // MARK: - Actions
    
    @IBAction func skipButtonClicked(_ sender: Any) {
        UserDefaults.standard.set(true, forKey: "secondTime")
        dismiss(animated: true, completion: nil)
    }
    @IBAction func nextButtonClicked(_ sender: Any) {
        if let index = onboardingPageViewController?.currentIndex {
            switch index {
            case 0...1:
                onboardingPageViewController?.forwardPage()
            case 2:
                UserDefaults.standard.set(true, forKey: "secondTime")
                dismiss(animated: true, completion: nil)
            default: break
            }
        }
        updateUI()
    }
    
    func updateUI(){
        if let index = onboardingPageViewController?.currentIndex {
            switch index {
            case 0...1:
                nextButton.setTitle("Next", for: .normal)
                skipButton.isHidden = false
            case 2:
                nextButton.setTitle("Get Started", for: .normal)
                skipButton.isHidden = true
            default: break
            }
            pageControl.currentPage = index
        }
    }
    
    func didUpdatePageIndex(currentIndex: Int) {
        updateUI()
    }
    // MARK: - View controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination
        if let pageViewController = destination as? OnboardingPageViewController {
            onboardingPageViewController = pageViewController
            onboardingPageViewController?.onboardingDelegate = self
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
