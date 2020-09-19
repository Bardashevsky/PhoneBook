//
//  UITextField + Extension.swift
//  PhoneBookSQLite
//
//  Created by Oleksandr Bardashevskyi on 16.09.2020.
//  Copyright © 2020 Oleksandr Bardashevskyi. All rights reserved.
//

import UIKit

class OneLineTextField: UITextField {

    convenience init(color: UIColor) {
        self.init()
        
        setup(color: color)
        
    }
    
    func setup(color: UIColor) {
        borderStyle = .none
        translatesAutoresizingMaskIntoConstraints = false
        
        self.autocorrectionType = .no
        self.textColor = color
        
        let bottomView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 0))
        bottomView.backgroundColor = .black
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

}

