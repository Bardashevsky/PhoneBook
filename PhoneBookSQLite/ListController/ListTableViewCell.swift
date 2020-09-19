//
//  ListTableViewCell.swift
//  PhoneBookSQLite
//
//  Created by Oleksandr Bardashevskyi on 16.09.2020.
//  Copyright © 2020 Oleksandr Bardashevskyi. All rights reserved.
//

import UIKit
import Alamofire

protocol CellsProtocol {
    static var reuseID: String { get }
    func setupCell(contact: Contact)
}

fileprivate enum LoadingState {
    case notLoading
    case loading
    case loaded(UIImage)
}

class ListTableViewCell: UITableViewCell, CellsProtocol {
    
    static let reuseID = "ListCell"
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private let firstLabel = UILabel()
    private let lastLabel = UILabel()
    private let pictureImage = UIImageView()
    
    func setupCell(contact: Contact) {
        
        self.firstLabel.text = contact.first
        self.lastLabel.text = contact.last
        
        self.loadingState = .loading
        guard let url = URL(string: contact.picture) else { return }
        
        AF.request(url, method: .get).response { response in
           switch response.result {
            case .success(let responseData):
                guard let image = UIImage(data: responseData!, scale:1) else { return }
                self.loadingState = .loaded(image)
            case .failure(let error):
                print("error--->",error)
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .clear
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loadingState = .notLoading
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        pictureImage.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        pictureImage.contentMode = .scaleAspectFit
        pictureImage.addSubview(activityIndicator)
        
        let namesStack = UIStackView(arrangedSubviews: [firstLabel, lastLabel], axis: .vertical, spacing: 0)
        namesStack.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(pictureImage)
        self.addSubview(namesStack)
        
        NSLayoutConstraint.activate([
            pictureImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            pictureImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            pictureImage.heightAnchor.constraint(equalToConstant: 50),
            pictureImage.widthAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: pictureImage.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: pictureImage.centerYAnchor),
            
            namesStack.leadingAnchor.constraint(equalTo: pictureImage.trailingAnchor, constant: 20),
            namesStack.topAnchor.constraint(equalTo: self.topAnchor),
            namesStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            namesStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8)
        ])
    }
    
    
    //Activity Indicator in drinks imageView
    private var loadingState: LoadingState = .notLoading {
        didSet {
            switch loadingState {
            case .notLoading:
                pictureImage.image = nil
                activityIndicator.stopAnimating()
            case .loading:
                pictureImage.image = nil
                activityIndicator.startAnimating()
            case let .loaded(img):
                pictureImage.image = img
                activityIndicator.stopAnimating()
            }
        }
    }
    

}
