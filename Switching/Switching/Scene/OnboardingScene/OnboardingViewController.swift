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
            ["커리어하이", "account1"],
            ["스타2자유의날개", "account1"],
            ["거위의꿈", "account1"],
        ]
        
        // 여기에 북마크 데이터 입력 !!
        
        let feedBookmarks = [
            [
                "https://www.ei.go.kr/ei/eih/eg/pb/pbPersonBnef/retrievePb0201Info.do",
                "고용보험-실업급여",
                "스타2자유의날개",
                ["고용보험", "실업급여"]
            ],
            [
                "https://m.blog.naver.com/welcomebank1/221816485735",
                "2020실업급여조건",
                "스타2자유의날개",
                ["실업급여"]
            ],
            [
                "https://brunch.co.kr/@bookfit/2738",
                "퇴직하면 실업급여",
                "스타2자유의날개",
                ["실업금여", "블로그"]
            ],
            [
                "https://brunch.co.kr/@dprnrn234/564",
                "퇴식사유는 어떻게?",
                "스타2자유의날개",
                ["사직서", "퇴직사유", "블로그"]
            ],
            [
                "https://brunch.co.kr/@dprnrn234/431",
                "사직서 쓰는 법",
                "스타2자유의날개",
                ["사직서", "블로그"]
            ],
            [
                "https://brunch.co.kr/@driver888/2",
                "사직서 쓰면 생기는 일",
                "스타2자유의날개",
                ["사직서", "후기", "블로그",]
            ],
            [
                "https://brunch.co.kr/@imagineer/222",
                "[번역]아이폰 앱 개발자가 알아야 할 14가지",
                "거위의꿈",
                ["iOS개발", "블로그"]
            ],
            [
                "https://brunch.co.kr/@rainpour/4",
                "iOS 개발자는 외롭다?",
                "거위의꿈",
                ["iOS개발", "블로그"]
            ],
            [
                "https://brunch.co.kr/@yoonms/3",
                "iOS개발을 시작하려 하는 당신에게",
                "거위의꿈",
                ["iOS개발", "블로그"]
            ],
            [
                "https://brunch.co.kr/@yoonms/9",
                "아이폰 앱 개발을 시작하기 전에",
                "거위의꿈",
                ["iOS개발", "블로그"]
            ],
            [
                "https://brunch.co.kr/@yoonms/4",
                "iOS 개발을 시작하려 하는 당신에게 2",
                "거위의꿈",
                ["iOS개발", "블로그"]
            ],
            [
                "https://brunch.co.kr/@banksalad/322",
                "iOS Engineer가 일하는 방식을 들어보았습니다.",
                "거위의꿈",
                ["iOS개발", "블로그"]
            ],
            [
                "https://codershigh.github.io/WebSite/#/",
                "코더스하이",
                "거위의꿈",
                ["iOS개발", "코더스하이"]
            ],
            [
                "http://codershigh.dscloud.biz:30004/t/topic/8",
                "코더스하이 라운지에 오신 걸 환영합니다 - 코더스하이 라운지",
                "거위의꿈",
                ["iOS개발", "코더스하이", "포럼"]
            ],
            [
                "https://www.youtube.com/channel/UCebXwimGkd5YrhPV7vmqKgA",
                "SwiftHigh",
                "거위의꿈",
                ["iOS개발", "유튜브"]
            ],
            [
                "https://corykim0829.github.io/ios/UICollectionViewCell-dynamic-height/#",
                "[iOS] UICollectionViewCell Dynamic Height, 동적 높이 구현하기 with Dummy Cell",
                "거위의꿈",
                ["iOS개발", "블로그"]
            ],
            [
                "https://www.perfomatix.com/ios-best-practices-and-swift-coding-standards-iphone-app-development-companies/",
                "iOS Best practices and SWIFT coding standards | iOS App Development Company",
                "거위의꿈",
                ["iOS개발", "블로그", "BestPractice"]
            ],
            [
                "https://yunjjang.tistory.com/6",
                "Swift 사진찍기 / 사진앨범에서 사진 가져오기 (Camera and Phone Library)",
                "거위의꿈",
                ["iOS개발", "블로그", "사진앨범가져오기"]
            ],
        ]
        
        let darftBookmarks = [
            [
                "https://brunch.co.kr/@cardgorilla/627",
                "개인사업자카드는 필수? 초기사업자가 놓치기 쉬운 금융팁",
                "스타2자유의날개"
            ],
            [
                "https://brunch.co.kr/@choi200231/19",
                "퇴사하면 누구나 실업급여를 받을 수 있나요?",
                "스타2자유의날개",
            ],
            [
                "https://brunch.co.kr/@vigorous21/432",
                "사직서, 그 무거움에 대하여",
                "스타2자유의날개",
            ],
            [
                "https://brunch.co.kr/@ummi/15",
                "회사를 언제 그만두면 좋을까",
                "스타2자유의날개",
            ],
            [
                "https://brunch.co.kr/@kkw119/30",
                "사직서를 준비하는 네가 알면 좋을 세 가지",
                "스타2자유의날개",
            ],
            [
                "https://forums.swift.org/t/dispatchqueue-async-within-infinite-loop/6768",
                "DispatchQueue.async within infinite loop - Using Swift - Swift Forums",
                "거위의꿈",
//                ["iOS개발", "DispatchQueue", "스위프트포럼"]
            ],
            [
                "https://tonyw.tistory.com/3",
                "IOS - 간단한 Swift Realm 라이브러리 사용법",
                "거위의꿈",
//                ["iOS개발", "블로그", "Realm"]
            ],
            [
                "https://learnappmaking.com/cocoapods-playground-how-to/",
                "Using CocoaPods With Xcode Playground – LearnAppMaking",
                "거위의꿈",
//                ["iOS개발", "Realm", "Tutorial"]
            ],
            [
                "https://cs193p.sites.stanford.edu/",
                "CS193p - Developing Apps for iOS",
                "거위의꿈",
//                ["iOS개발", "강의"]
            ],
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
