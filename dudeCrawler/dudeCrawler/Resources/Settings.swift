//
//  Settings.swift
//  Contained
//
//  Created by Jake Connerly on 7/22/19.
//  Copyright © 2019 jake connerly. All rights reserved.
//

import Foundation
import UIKit

class Settings {
    static let shared = Settings()
    private init() {}
    var baseURL = URL(string: "https://lambda-mud-test.herokuapp.com/")!
    var dude = "dudeIdle"
    var position = CGPoint(x: 200, y: 200)
    var movementDirection: String = ""
}
