//
//  OnboardingPageViewController.swift
//  Switching
//
//  Created by JNGSJN on 2020/11/09.
//

import UIKit

protocol onboardingPageViewControllerDelegate: class {
    func didUpdatePageIndex(currentIndex: Int)
}
class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - Properties
    
    weak var onboardingDelegate: onboardingPageViewControllerDelegate?
    
    var pageHeadings = ["캐릭터별로 북마크 지정이 가능해요!", "공유하기로 추가한 북마크는 임시보관함에 저장 돼요!", "태그를 여러개 지정할 수 있어요!👏"]
    var pageSubHeadings = ["마치 북마크 계의 넷플릭스😎\n최대 4개의 캐릭터를 생성할 수 있어요!", "태그를 지정하면서 저장해놓았던 링크를 확인하세요!\n분명 왜 저장했지…. 싶은 링크가 있을거에요.", "특정 태그의 북마크만 모아서 볼 수도 있어요!\n태그 기능, 알차게 활용해보세요!!😘"]
    var pageImages = ["account1", "noimage", "plusButton"]
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let startingViewController = contentViewController(at: 0) {
            setViewControllers([startingViewController], direction: .forward, animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Page View Controller Data Source
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! OnboardingContentViewController).index
        index -= 1
        return contentViewController(at: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = (viewController as! OnboardingContentViewController).index
        index += 1
        return contentViewController(at: index)
    }
    
    func contentViewController(at index: Int) -> OnboardingContentViewController? {
        if index < 0 || index >= pageHeadings.count {
            return nil
        }
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let pageContentVC = storyboard.instantiateViewController(withIdentifier: "onboardingContentVC") as? OnboardingContentViewController {
            pageContentVC.contentImage = pageImages[index]
            pageContentVC.heading = pageHeadings[index]
            pageContentVC.subHeading = pageSubHeadings[index]
            pageContentVC.index = index
            
            return pageContentVC
        }
        return nil
    }
    
    func forwardPage() {
        currentIndex += 1
        if let nextViewController = contentViewController(at: currentIndex) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    // MARK: - Page view controller delegate
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let contentViewController = pageViewController.viewControllers?.first as? OnboardingContentViewController {
                currentIndex = contentViewController.index
                onboardingDelegate?.didUpdatePageIndex(currentIndex: currentIndex)
            }
        }
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
