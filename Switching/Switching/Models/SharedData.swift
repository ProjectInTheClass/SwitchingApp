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
}

func getRealm() -> Realm? {
    var realm: Realm?
    guard var fileURL = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.switching.SwitchingApp") else {
        print("Container URL is nil")
        return realm
    }
    fileURL.appendPathComponent("shared.realm")
    Realm.Configuration.defaultConfiguration = Realm.Configuration(fileURL: fileURL)
    realm = try! Realm(fileURL: fileURL)
    return realm
}
