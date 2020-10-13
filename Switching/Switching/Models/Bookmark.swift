//
//  Bookmark.swift
//  Switching
//
//  Created by 김기훈 on 2020/10/02.
//

import UIKit
import Foundation
import RealmSwift

class Bookmark: Object{
    @objc dynamic var url: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var createDate: Date = Date.init()
    @objc dynamic var image: Data? = nil
    @objc dynamic var character: String = ""
    @objc dynamic var isTemp: Bool = true
    
    let tags: List<Tag> = List<Tag>()
}
