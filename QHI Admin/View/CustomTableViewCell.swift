//
//  CustomTableViewCell.swift
//  QHI Admin
//
//  Created by Arrinal Sholifadliq on 19/04/22.
//

import UIKit
import Firebase

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "quoteCell"
    
    let checkbox: UIImageView = {
        
        var image = UIImageView()
        image.image = UIImage(systemName: "square")
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    let quoteTextView: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Nunito-Bold", size: 15)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let authorTextView: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont(name: "Nunito-Bold", size: 15)
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(checkbox)
        contentView.addSubview(quoteTextView)
        
        checkbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        checkbox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        checkbox.widthAnchor.constraint(equalToConstant: 25).isActive = true
        checkbox.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        quoteTextView.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 10).isActive = true
        quoteTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        quoteTextView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        quoteTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    public func configure(checkbox: String, text: String ) {
        
        quoteTextView.text = text
        self.checkbox.image = UIImage(systemName: checkbox)
        
        
    }
    
}
