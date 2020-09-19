//
//  SQLiteManager.swift
//  PhoneBookSQLite
//
//  Created by Oleksandr Bardashevskyi on 16.09.2020.
//  Copyright © 2020 Oleksandr Bardashevskyi. All rights reserved.
//

import Foundation
import SQLite

class SQLiteManager {
    
    var database: Connection!
    
    static let shared = SQLiteManager()
    private init() {}
    
    let usersTable = Table("users")
    
    let id = Expression<Int>("id")
    let first = Expression<String>("first")
    let last = Expression<String>("last")
    let email = Expression<String>("email")
    let picture = Expression<String>("picture")
    
    init(id: Int, first: String, last: String, email: String, picture: String) {
        insertUser(first: first, last: last, email: email, picture: picture)
    }
    
    
    //MARK: - Create Database -
    func createTable() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileURL = documentDirectory.appendingPathComponent("user").appendingPathExtension("sqlite3")
            let database = try Connection(fileURL.path)
            self.database = database
        } catch {
            print(error)
        }
        
        let createTable = self.usersTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.first)
            table.column(self.last)
            table.column(self.email, unique: true)
            table.column(self.picture)
        }
        
        do {
            try self.database.run(createTable)
            print("Created Table")
        } catch {
            print(error)
        }
    }
    //MARK: - Insert user to database -
    public func insertUser(first: String, last: String, email: String, picture: String) {
        let insertUser = self.usersTable.insert(self.first <- first,
                                                self.last <- last,
                                                self.email <- email,
                                                self.picture <- picture)
        
        do {
            try self.database.run(insertUser)
            print("INSERTED USER")
        } catch {
            print(error)
        }
        
    }
    
    //MARK: - Get users list from database -
    public func listUsers() -> [Contact] {
        var contacts = [Contact]()
        do {
            let users = try self.database.prepare(self.usersTable)
            for user in users {
                contacts.append(Contact(first: user[self.first],
                                         last: user[self.last],
                                         email: user[self.email],
                                         picture: user[self.picture],
                                         userID: user[self.id]))
            }
        } catch {
            print(error)
        }
        return contacts
    }
    
    //MARK: - Update user from database -
    public func updateUser(contact: Contact) {
        let user = self.usersTable.filter(self.id == contact.userID)
    
        let updatefirst = user.update(self.first <- contact.first)
        let updateLast = user.update(self.last <- contact.last)
        let updateEmail = user.update(self.email <- contact.email)
        
        do {
            try self.database.run(updatefirst)
            try self.database.run(updateLast)
            try self.database.run(updateEmail)
        } catch {
            print(error)
        }
    }
    
    //MARK: - Delete user from database -
    public func deleteUser(contact: Contact) {
        let user = self.usersTable.filter(self.id == contact.userID)
        let deleteUser = user.delete()
        do {
            try self.database.run(deleteUser)
        } catch {
            print(error)
        }
    }
}
