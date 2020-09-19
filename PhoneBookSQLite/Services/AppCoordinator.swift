//
//  AppCoordinator.swift
//  PhoneBookSQLite
//
//  Created by Oleksandr Bardashevskyi on 16.09.2020.
//  Copyright © 2020 Oleksandr Bardashevskyi. All rights reserved.
//

import UIKit

class AppCoordinator {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let viewController = ListViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
}
