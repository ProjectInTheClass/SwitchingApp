//
//  Account.swift
//  TagPractice
//
//  Created by JNGSJN on 2020/10/28.
//

import Foundation

struct Account {
    var accountName: String = ""
    var accountTags: Array<String> = []
}

var accounts: Array<Account> = [Account(accountName: "메인임", accountTags: ["자주가는사이트", "네이버", "애플"])]
