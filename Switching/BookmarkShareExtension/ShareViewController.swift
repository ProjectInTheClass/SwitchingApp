//
//  ShareViewController.swift
//  BookmarkShareExtension
//
//  Created by 김기훈 on 2020/10/02.
//

import UIKit
import Social
import MobileCoreServices
import RealmSwift

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        var newBookmark: Bookmark?
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            newBookmark = accessWebpageProperties(extensionItem: item)
        }
        
        
        // init Realm
        
        guard var fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.imageTest3") else {
                print("Container URL is nil")
                return
        }

        fileURL.appendPathComponent("shared.realm")

        Realm.Configuration.defaultConfiguration = Realm.Configuration(fileURL: fileURL)
        
        let realm = try! Realm(fileURL: fileURL)
        
        // push new bookmark to Realm DB
        if let bookmark: Bookmark = newBookmark{
            do{
                try realm.write{
                    realm.add(bookmark)
                }
            } catch {
                print("Error Add \(error)")
            }
        }
        
        
        
        
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }
    
    private func accessWebpageProperties(extensionItem: NSExtensionItem) -> Bookmark? {

        var bookmark:Bookmark?
        
        // url 가져오기
        let propertyList = kUTTypePropertyList as String

        for attachment in extensionItem.attachments! where attachment.hasItemConformingToTypeIdentifier(propertyList) {
            attachment.loadItem(
                forTypeIdentifier: propertyList,
                options: nil,
                completionHandler: { (item, error) -> Void in

                    guard let dictionary = item as? NSDictionary,
                        let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                        let url = results["URL"] as? String,
                        let desc = results["title"] as? String
                        else {
                            return
                        }
                    bookmark = Bookmark()
                    bookmark?.url = url
                    bookmark?.desc = desc
                }
            )
        }
        return bookmark
    }
}
