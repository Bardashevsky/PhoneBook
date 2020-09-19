//
//  UILabel + Extension.swift
//  PhoneBookSQLite
//
//  Created by Oleksandr Bardashevskyi on 16.09.2020.
//  Copyright © 2020 Oleksandr Bardashevskyi. All rights reserved.
//

import UIKit

extension UILabel {
    convenience init(text: String) {
        self.init()
        
        self.text = text
        self.textColor = .darkGray
    }
}
