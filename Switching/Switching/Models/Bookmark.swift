//
//  Bookmark.swift
//  Switching
//
//  Created by 김기훈 on 2020/10/02.
//

import UIKit
import Foundation

class Bookmark{
    @objc dynamic var url: String
    @objc dynamic var desc: String
    init(url: String, desc: String) {
        self.url = url
        self.desc = desc
    }
}
