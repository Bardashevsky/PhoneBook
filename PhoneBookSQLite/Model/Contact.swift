//
//  Contacts.swift
//  PhoneBookSQLite
//
//  Created by Oleksandr Bardashevskyi on 16.09.2020.
//  Copyright © 2020 Oleksandr Bardashevskyi. All rights reserved.
//

import Foundation

struct Contact: Equatable {
    var first: String
    var last: String
    var email: String
    var picture: String
    var userID: Int
    
}

private enum CodingKeys: String {
    case first
    case last
    case email
    case picture
}

