//
//  DetailViewController.swift
//  PhoneBookSQLite
//
//  Created by Oleksandr Bardashevskyi on 16.09.2020.
//  Copyright © 2020 Oleksandr Bardashevskyi. All rights reserved.
//

import UIKit
import Alamofire

class DetailViewController: UIViewController {
    
    weak var delegate: EditContactDelegate!
    var contact: Contact!
    
    var imageView = UIImageView()
    
    var firstLabel = UILabel(text: "First Name")
    var lastLabel = UILabel(text: "Last Name")
    var emailLabel = UILabel(text: "Email")
    
    var firstTextField = OneLineTextField(color: .black)
    var lastTextField = OneLineTextField(color: .black)
    var emailTextField = OneLineTextField(color: .black)
    
    var saveAndBackButton = UIButton(color: .white, title: "Save & Exit", titleColor: .black)
    var deleteContactButton = UIButton(color: .red, title: "DELETE", titleColor: .white)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.9725490196, blue: 0.9921568627, alpha: 1)
        self.navigationController?.navigationBar.tintColor = .black
        setupConstraints()
        
        
        firstTextField.delegate = self
        lastTextField.delegate = self
        emailTextField.delegate = self
        
        firstTextField.text = contact.first
        lastTextField.text = contact.last
        emailTextField.text = contact.email
        
        
        saveAndBackButton.addTarget(self, action: #selector(saveAndExitAction(_:)), for: .touchUpInside)
        deleteContactButton.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
        setImage(imagePath: contact.picture)
    }
    
    deinit {
        print("Deinited")
    }
    
    private func setImage(imagePath: String) {
        guard let url = URL(string: imagePath) else { return }
        AF.request(url, method: .get).response { response in
           switch response.result {
            case .success(let responseData):
                guard let image = UIImage(data: responseData!, scale:1) else { return }
                self.imageView.image = image
            case .failure(let error):
                print("error--->",error)
            }
        }
    }
    
    //MARK: - Actions -
    
    @objc private func saveAndExitAction(_ sender: UIButton) {
        let contact = Contact(first: firstTextField.text ?? "NO DATA",
                              last: lastTextField.text ?? "NO DATA",
                              email: emailTextField.text ?? "NO DATA",
                              picture: self.contact.picture,
                              userID: self.contact.userID)
        
        delegate.save(contact: contact)
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteAction(_ sender: UIButton) {
        let contact = Contact(first: firstTextField.text ?? "NO DATA",
                              last: lastTextField.text ?? "NO DATA",
                              email: emailTextField.text ?? "NO DATA",
                              picture: self.contact.picture,
                              userID: self.contact.userID)
        
        delegate.delete(contact: contact)
        navigationController?.popViewController(animated: true)
    }
    
    
}

extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - Setup Constaints -
extension DetailViewController {
    func setupConstraints() {
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.imageView)
        self.imageView.image = UIImage(named: "look")
        
        let emailStackView = UIStackView(arrangedSubviews: [firstLabel, firstTextField], axis: .vertical, spacing: 0)
        let passwordStackView = UIStackView(arrangedSubviews: [lastLabel, lastTextField], axis: .vertical, spacing: 0)
        let confirmPasswordStackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField], axis: .vertical, spacing: 0)
        
        let textFieldsStackView = UIStackView(arrangedSubviews: [emailStackView, passwordStackView, confirmPasswordStackView], axis: .vertical, spacing: 40)
        textFieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldsStackView.distribution = .fillEqually
        self.view.addSubview(textFieldsStackView)
        
        let buttonsSteck = UIStackView(arrangedSubviews: [deleteContactButton, saveAndBackButton], axis: .horizontal, spacing: 40)
        buttonsSteck.distribution = .fillEqually
        buttonsSteck.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(buttonsSteck)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            
            textFieldsStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            textFieldsStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 40),
            textFieldsStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -40),
            textFieldsStackView.heightAnchor.constraint(equalToConstant: 250),
            
            buttonsSteck.topAnchor.constraint(equalTo: textFieldsStackView.bottomAnchor, constant: 40),
            buttonsSteck.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 50),
            buttonsSteck.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -50),
            buttonsSteck.heightAnchor.constraint(equalToConstant: 50)
            
        ])
        
        
        
        
    }
}
