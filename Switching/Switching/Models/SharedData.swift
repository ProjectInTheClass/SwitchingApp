//
//  SharedData.swift
//  Switching
//
//  Created by 김기훈 on 2020/10/09.
//

import Foundation

class SharedData{
    static let instance = SharedData()
    private init(){
    }
    var selectedCharacter: String = "main"
}

