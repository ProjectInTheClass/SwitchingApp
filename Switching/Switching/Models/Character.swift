//
//  Character.swift
//  Switching
//
//  Created by Sanghun Park on 2020/10/03.
//

import RealmSwift

class Character: Object {
    @objc dynamic var character: String = ""
    @objc dynamic var tags: [String] = []
}
