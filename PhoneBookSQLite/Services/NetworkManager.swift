//
//  NetworkManager.swift
//  PhoneBookSQLite
//
//  Created by Oleksandr Bardashevskyi on 16.09.2020.
//  Copyright © 2020 Oleksandr Bardashevskyi. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let db = SQLiteManager.shared
    
    func getContacts(complition: @escaping () -> ()) {
        guard let url = URL(string: "https://randomuser.me/api/?results=20") else { return }
        
        AF.request(url, method: .get).validate().responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for (_, value) in json["results"] {
                    guard let name = value.dictionaryObject!["name"] as? [String: Any],
                        let first = name["first"] as? String,
                        let last = name["last"] as? String else { continue }
                    guard let email = value.dictionaryObject!["email"] as? String else { continue }
                    guard let picture = value.dictionaryObject!["picture"] as? [String: Any],
                        let pictureMedium = picture["medium"] as? String else { continue }
                    
                    self.db.insertUser(first: first, last: last, email: email, picture: pictureMedium)
                    
                    complition()
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
    
    
    
    
}
