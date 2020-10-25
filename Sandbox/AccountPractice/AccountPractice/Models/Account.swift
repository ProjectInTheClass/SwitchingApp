//
//  Account.swift
//  AccountPractice
//
//  Created by JNGSJN on 2020/10/21.
//

import Foundation
import UIKit

struct Account {
    var name: String = ""
    var image: UIImage? = UIImage(named: "account1.png")!
}
var accounts: [Account] = [Account(name: "본캐입니당", image: UIImage(named: "account1.png"))]

var sharedData: Account = accounts[0]
