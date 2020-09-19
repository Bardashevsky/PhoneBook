//
//  ListViewController.swift
//  PhoneBookSQLite
//
//  Created by Oleksandr Bardashevskyi on 16.09.2020.
//  Copyright © 2020 Oleksandr Bardashevskyi. All rights reserved.
//

import UIKit

protocol EditContactDelegate: class {
    func save(contact: Contact)
    func delete(contact: Contact)
}

class ListViewController: UIViewController {
    
    private let db = SQLiteManager.shared
    private var tableView = UITableView()
    private var indexPathToReload = IndexPath()
    var contacts = [Contact]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Contacts"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        db.createTable()
        
        self.contacts = self.db.listUsers()
        self.tableView.reloadData()
        
        setupTableView()
    }
    //MARK: - UI Elements -
    private func setupTableView() {
        self.tableView = UITableView(frame: self.view.bounds)
        self.view.addSubview(self.tableView)
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.reuseID)
    }

}

//MARK: - UITableViewDataSource -
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseID) as! ListTableViewCell
        cell.setupCell(contact: contacts[indexPath.row])
        
        return cell
    }
    
    
}

//MARK: - UITableViewDelegate -
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = DetailViewController()
        detailsVC.delegate = self
        detailsVC.contact = contacts[indexPath.row]
        self.indexPathToReload = indexPath
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle:   UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            db.deleteUser(contact: contacts[indexPath.row])
            contacts.remove(at: indexPath.row)
            self.tableView.beginUpdates()
            self.tableView.deleteRows(at: [indexPath], with: .middle)
            self.tableView.endUpdates()
        }
    }
}

//MARK: - EditContactDelegate -
extension ListViewController: EditContactDelegate {
    func save(contact: Contact) {
        db.updateUser(contact: contact)
        contacts[indexPathToReload.row] = contact
        tableView.reloadRows(at: [indexPathToReload], with: .fade)
    }
    
    func delete(contact: Contact) {
        db.deleteUser(contact: contact)
        
        self.tableView.beginUpdates()
        contacts.remove(at: indexPathToReload.row)
        self.tableView.deleteRows(at: [indexPathToReload], with: .left)
        self.tableView.endUpdates()
        
    }
}
