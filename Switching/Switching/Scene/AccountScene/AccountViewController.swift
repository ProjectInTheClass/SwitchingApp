import UIKit

class AccountViewController: UIViewController {
    var isEditMode: Bool = false
    @IBOutlet weak var accountStatusLabel: UILabel!
    @IBOutlet weak var characterCollectionView: UICollectionView!
    @IBAction func cancelClicked(_ sender: UIButton) {
          self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var editBtn: UIButton!
    
    @IBAction func editClicked(_ sender: Any) {
        isEditing = !isEditing
        if isEditing{
            editBtn.setTitle("완료", for: .normal)
            accountStatusLabel.text = "수정할 캐릭터를 선택해 주세요"
        }else{
            editBtn.setTitle("수정", for: .normal)
            accountStatusLabel.text = "북마크를 확인할 캐릭터를 선택해 주세요"
        }
        self.characterCollectionView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("newCharacterCreated"), object: nil)
    }
    @objc func notificationReceived(notification: Notification) {
        self.characterCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "secondTime"){
            return
        }
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let onboardingVC = storyboard.instantiateViewController(withIdentifier: "onboardingVC") as? OnboardingViewController {
            onboardingVC.modalPresentationStyle = .fullScreen
            self.present(onboardingVC, animated: true, completion: nil)
        }
    }
}

extension AccountViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let realm  = SharedData.instance.realm
        let accounts = realm.objects(Character.self)
                if accounts.count > 3 {
                    return accounts.count
                } else {
                    return accounts.count + 1
                }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cells : UICollectionViewCell?
        let realm  = SharedData.instance.realm
        if indexPath.row < realm.objects(Character.self).count {
            let character = realm.objects(Character.self)[indexPath.row]
            let existingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "accountCell", for: indexPath) as! AccountCollectionViewCell
            existingCell.accountNameLabel.text = character.character
            existingCell.updateUI()
            if let imageData = character.image{
                existingCell.accountImage.image = UIImage(data: imageData)
            }else{
                existingCell.accountImage.image = UIImage(named: "account1.png")
            }
            if isEditing{
                existingCell.editImage.isHidden = false
            }else{
                existingCell.editImage.isHidden = true
            }
            cells = existingCell
        } else {
            let addCell = collectionView.dequeueReusableCell(withReuseIdentifier: "addAccountCell", for: indexPath) as! AddAccountCollectionViewCell
            cells = addCell
        }
        return cells!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let realm  = SharedData.instance.realm
        if indexPath.row == realm.objects(Character.self).count {
            let storyboard = UIStoryboard.init(name: "Account", bundle: nil)
            guard let editVC = storyboard.instantiateViewController(identifier: "editVC") as? EditAccountViewController else{
                return
            }
            self.present(editVC, animated: true, completion: nil)
        } else {
            if isEditing{
                let storyboard = UIStoryboard.init(name: "Account", bundle: nil)
                guard let editVC = storyboard.instantiateViewController(identifier: "editVC") as? EditAccountViewController else{
                    return
                }
                let realm  = SharedData.instance.realm
                editVC.editAccount = realm.objects(Character.self)[indexPath.row]
                self.present(editVC, animated: true, completion:nil)
            }else{
                print("버튼이 클릭됨 \(indexPath.row)")
                SharedData.instance.selectedCharacter = realm.objects(Character.self)[indexPath.row].character
                NotificationCenter.default.post(name: Notification.Name("refreshFeedView"), object: nil)
                NotificationCenter.default.post(name: Notification.Name("refreshDraftView"), object: nil)
                if (self.presentingViewController != nil) {
                    presentingViewController?.dismiss(animated: true, completion: nil)
                } else {
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    guard let tabBarVC = storyboard.instantiateViewController(identifier: "tabBarVC") as? UITabBarController else {
                        return
                    }
                    tabBarVC.modalPresentationStyle = .fullScreen
                    tabBarVC.modalTransitionStyle = .crossDissolve
                    self.present(tabBarVC, animated: true, completion:nil)
                }
                
            }
        }
    }
}
