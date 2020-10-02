
import UIKit
import Social
import MobileCoreServices
import RealmSwift


class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        
        // contentText : 유저가 공유하기 창을 눌러 넘어온 문자열 값(상수)
        if let currentMessage = contentText{
            let currentMessageLength = currentMessage.count
            // charactersRemaining : 문자열 길이 제한 값(상수)
            charactersRemaining = (100 - currentMessageLength) as NSNumber
            
            print("currentMessage : \(currentMessage) // 길이 : \(currentMessageLength) // 제한 : \(charactersRemaining)")
            if Int(charactersRemaining) < 0 {
                print("100자가 넘었을때는 공유할 수 없다!")
                return false
            }
        }
        return true
    }

    override func didSelectPost() {
        print("didselectPost")
        var bookmark: Bookmark?
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            bookmark = accessWebpageProperties(extensionItem: item)
        }
        usleep(1000 * 20)
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    override func configurationItems() -> [Any]! {
        let item = SLComposeSheetConfigurationItem()
        
        item?.title = "여기는 제목입니다"
        // item?.tapHandler : 유저가 터치했을 때 호출되는 핸들러
        return [item]
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
