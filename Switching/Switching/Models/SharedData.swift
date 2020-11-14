//
//  SharedData.swift
//  Switching
//
//  Created by 김기훈 on 2020/10/09.
//

import Foundation
import RealmSwift

class SharedData{
    static let instance = SharedData()
    private init(){
    
    }
    var selectedCharacter: String = "main"
    var realm: Realm = getRealm()!
    func newRealm() -> Realm{
        return getRealm()!
    }
    
    func getTagListOfSelectedCharacter() -> Array<String>{
        var tags: Array<String> = []
        let myRealm = newRealm()
        let bookmarks = myRealm.objects(Bookmark.self).filter("character = '\(SharedData.instance.selectedCharacter)'")
        for bookmark in bookmarks{
            for tag in bookmark.tags{
                if !tags.contains(tag.tag){
                    tags.append(tag.tag)
                }
            }
        }
        return tags
    }
}

func getRealm() -> Realm? {
    var realm: Realm?
    guard var fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.com.dreamin.SwitchingApp") else {
        print("Container URL is nil")
        return realm
    }
    fileURL.appendPathComponent("shared.realm")
    Realm.Configuration.defaultConfiguration = Realm.Configuration(fileURL: fileURL)
    realm = try! Realm(fileURL: fileURL)
    return realm
}


func getTagListOfSelectedBookmark(bookmark: Bookmark) -> Array<String> {
    var tags: Array<String> = []
    for tag in bookmark.tags{
        tags.append(tag.tag)
    }
    return tags
}
