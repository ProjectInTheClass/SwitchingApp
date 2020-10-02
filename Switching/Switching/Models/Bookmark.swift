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
    @objc dynamic var desc: String = ""
}
