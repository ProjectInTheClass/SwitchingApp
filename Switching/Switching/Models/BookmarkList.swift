//
//  BookmarkList.swift
//  Switching
//
//  Created by Sanghun Park on 2020/10/03.
//

import RealmSwift

struct TempBookmarkList {
    
    fileprivate let realm: Realm
    
    init?() {
        self.realm = try! Realm.init()
        print("Realm:", Realm.Configuration.defaultConfiguration.fileURL ?? "")
    }
    
    func add(bookmark: Bookmark) throws {
        try self.realm.write {
            self.realm.add(bookmark)
        }
    }
    
    func getAll(bookmark: Bookmark? = nil) -> [Bookmark] {
        let results: Results<Bookmark>
        
        if let selected = bookmark {
            results = self.realm.objects(Bookmark.self).filter("isTemp == \(selected)")
        } else {
            results = self.realm.objects(Bookmark.self)
        }
        
        guard !results.isEmpty else {
            return []
        }
        
        return Array.init(results)
    }
}
