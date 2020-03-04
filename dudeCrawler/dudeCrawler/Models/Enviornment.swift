//
//  Enviornment.swift
//  dudeCrawler
//
//  Created by Jake Connerly on 3/4/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import Foundation

struct Enviornment: Codable {
    let name: String
    let title: String
    let description: String
}

struct MoveDirection: Codable {
    let direction: String
}
