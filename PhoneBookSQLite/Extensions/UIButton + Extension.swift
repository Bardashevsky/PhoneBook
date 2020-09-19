//
//  UIButton + Extension.swift
//  PhoneBookSQLite
//
//  Created by Oleksandr Bardashevskyi on 16.09.2020.
//  Copyright © 2020 Oleksandr Bardashevskyi. All rights reserved.
//

import UIKit


extension UIButton {
    convenience init(color: UIColor, title: String, titleColor: UIColor) {
        self.init()
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        self.backgroundColor = color
    }
}
