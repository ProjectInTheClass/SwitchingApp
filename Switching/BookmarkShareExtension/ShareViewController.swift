import UIKit
import Social
import MobileCoreServices
import RealmSwift

class ShareViewController: UIViewController {
    @IBOutlet weak var characterCollectionView: UICollectionView!
    @IBAction func cancelClicked(_ sender: UIButton) {
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceived(notification:)), name: Notification.Name("newCharacterCreated"), object: nil)
    }
    @objc func notificationReceived(notification: Notification) {
        self.characterCollectionView.reloadData()
    }
}

extension ShareViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("count")
        let realm  = SharedData.instance.realm
        return realm.objects(Character.self).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cells : UICollectionViewCell?
        let realm  = SharedData.instance.realm

        let character = realm.objects(Character.self)[indexPath.row]
        let existingCell = collectionView.dequeueReusableCell(withReuseIdentifier: "accountCell", for: indexPath) as! ShareViewAccountCollectionCell
        existingCell.accountNameLabel.text = character.character
        if let image = character.image{
            existingCell.accountImage.image = UIImage(data: image)
        }
        else{
            existingCell.accountImage.image = UIImage(named: "account1")
        }
        existingCell.accountImage.layer.cornerRadius = 50
        cells = existingCell

        return cells!
    }
    
//     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//         let realm  = SharedData.instance.realm
//         let characters = realm.objects(Character.self)

//         print("버튼이 클릭됨 \(indexPath.row)")
//         var bookmark: Bookmark?
//         if let item = extensionContext?.inputItems.first as? NSExtensionItem {
//             bookmark = accessWebpageProperties(extensionItem: item, characterName: characters[indexPath.row].character)
//         }
//         bookmark?.character = characters[indexPath.row].character
//         usleep(1000 * 20)
//         self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
//         self.presentingViewController?.dismiss(animated: true, completion: nil)

//     }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for item in extensionContext!.inputItems.first as? NSExtensionItem {
        if let attachments = item.attachments {
            for itemProvider in attachments! {
                itemProvider.loadItemForTypeIdentifier("public.url", options: nil, completionHandler: { (object, error) -> Void in
                    if object != nil {
                        println(object) //This is your URL
                    }
                })
            }
        }
    }

    }
}

private func accessWebpageProperties(extensionItem: NSExtensionItem, characterName: String) -> Bookmark{
        // url 가져오기
        let propertyList = kUTTypePropertyList as String
        var bookmark = Bookmark()

        for attachment in extensionItem.attachments! where attachment.hasItemConformingToTypeIdentifier(propertyList) {
            attachment.loadItem(
                forTypeIdentifier: propertyList,
                options: nil,
                completionHandler: { (item, error) -> Void in

                    guard let dictionary = item as? NSDictionary,
                        let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                        let url = results["URL"] as? String,
                        let desc = results["title"] as? String else {
                            return
                        }

                    print("url: \(url)")
                    bookmark.url = url
                    print("desc: \(desc)")
                    bookmark.desc = desc
                    bookmark.character = characterName
                    print("character: \(bookmark.character)")

                    usleep(1000 * 10)
                    let realm = SharedData.instance.newRealm()
                    do{
                        try realm.write{ // realm.write{}는 git에서 commit을 해주는 것과 비슷하다.
                            realm.add(bookmark) // 데이터베이스에 park 모델을 더한다.
                        }
                    } catch {
                        print("Error Add \(error)")
                    }
                    print("add data done")
                }
            )
        }
        return bookmark
    }
