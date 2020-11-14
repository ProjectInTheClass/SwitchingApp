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
        
        // 더미데이터를 사용하지 않는 경우 아래 라인 모두 주석처리
        
        let realm = SharedData.instance.realm

        //  여기에 캐릭터 데이터 입력 !!
        let characters = [
            ["main", "account1"],
            ["sub1", "account1"],
            ["sub2", "account1"],
            ["sub3", "account1"],
        ]
        
        // 여기에 북마크 데이터 입력 !!
        
        let feedBookmarks = [
            ["naver.com", "naver", "main", ["tag1", "tag2", "tag3"]],
            ["google.com", "google", "sub1", ["tag1"]],
            ["apple.com", "apple", "sub2", []],
        ]
        
        let darftBookmarks = [
            ["https://www.daum.net/", "daum", "main"],
            ["https://www.youtube.com/", "youtube", "sub1"],
        ]

        
        do{
            try realm.write{
                for i in 0...characters.count - 1{
                    let newCharacter = Character()
                    newCharacter.character = characters[i][0]
                    newCharacter.image = UIImage(named: characters[i][1])?.pngData()
                    realm.add(newCharacter)
                    print("추가")
                }
                
                for i in 0...feedBookmarks.count - 1{
                    let newBookmark = Bookmark()
                    newBookmark.url = feedBookmarks[i][0] as! String
                    newBookmark.desc = feedBookmarks[i][1] as! String
                    newBookmark.character = feedBookmarks[i][2] as! String
                    newBookmark.isTemp = false
                    for tag in feedBookmarks[i][3] as! [String]{
                        let newTag = Tag()
                        newTag.tag = tag as! String
                        newBookmark.tags.append(newTag)
                    }
                    realm.add(newBookmark)
                }
                
                for i in 0...darftBookmarks.count - 1{
                    let newBookmark = Bookmark()
                    newBookmark.url = darftBookmarks[i][0]
                    newBookmark.desc = darftBookmarks[i][1]
                    newBookmark.character = darftBookmarks[i][2]
                    newBookmark.isTemp = true
                    realm.add(newBookmark)
                }
            }
        } catch {
            print("Error Add \(error)")
        }
        
        
        
        NotificationCenter.default.post(name: Notification.Name("newCharacterCreated"), object: nil)
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
