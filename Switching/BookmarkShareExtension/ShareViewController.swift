
import UIKit
import Social
import MobileCoreServices
import RealmSwift

class ShareViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var selectCharacter: UISegmentedControl!

    @IBAction func postBtn(_ sender: Any) {
        var bookmark: Bookmark?
                if let item = extensionContext?.inputItems.first as? NSExtensionItem {
                    bookmark = accessWebpageProperties(extensionItem: item)
                }
                usleep(1000 * 20)
                self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
    }
    
    private func accessWebpageProperties(extensionItem: NSExtensionItem) -> Bookmark{
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
                        bookmark.character = "main"
    
                        usleep(1000 * 10)
    
                        guard var fileURL = FileManager.default
                            .containerURL(forSecurityApplicationGroupIdentifier: "group.switching.Switching") else {
                                print("Container URL is nil")
                                return
                        }
    
                        fileURL.appendPathComponent("shared.realm")
    
                        Realm.Configuration.defaultConfiguration = Realm.Configuration(fileURL: fileURL)
    
                        let realm = try! Realm(fileURL: fileURL)
                        print("\(realm.configuration.fileURL?.absoluteString)")
    
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
}
