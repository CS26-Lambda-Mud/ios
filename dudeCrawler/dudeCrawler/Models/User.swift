//
//  User.swift
//  dudeCrawler
//
//  Created by Jake Connerly on 3/3/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import Foundation

struct User: Codable {
    var username: String
    var password: String
}

struct RegistrationInfo: Codable {
    var username: String
    var password1: String
    var password2: String
}
