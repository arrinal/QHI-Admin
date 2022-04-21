//
//  AddQuoteViewController.swift
//  QHI Admin
//
//  Created by Arrinal Sholifadliq on 20/04/22.
//

import UIKit

protocol AddQuoteDelegate {
    
    func saveQuote(quote: String, author: String)
}

class AddQuoteViewController: UIViewController {
    
    var delegate: AddQuoteDelegate?
    
    
    let quoteTextView: UITextView = {
        let textView = UITextView()
        
        textView.text = ""
        textView.textAlignment = .left
        textView.layer.cornerRadius = 5
        textView.isEditable = true
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var authorTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Title *"
        textField.autocorrectionType = .no
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let submitButton: UIButton = {
       let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .bold)
        button.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 2
        button.layer.borderColor = CGColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print("didload")
        view.backgroundColor = .brown
        setupUI()
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func setupUI() {
        view.addSubview(quoteTextView)
        view.addSubview(authorTextField)
        view.addSubview(submitButton)
        
        quoteTextView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        quoteTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        quoteTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        quoteTextView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        
        authorTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        authorTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        authorTextField.topAnchor.constraint(equalTo: quoteTextView.bottomAnchor, constant: 10).isActive = true
        authorTextField.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        
        submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        submitButton.topAnchor.constraint(equalTo: authorTextField.bottomAnchor, constant: 30).isActive = true
        submitButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        submitButton.addTarget(self, action: #selector(submitQuote), for: .touchUpInside)
        
        
    }
    
    @objc func submitQuote() {
        
        guard quoteTextView.text.count != 0 else {return}
        guard authorTextField.text?.count != 0 else {return}
        submitButton.isEnabled = false
        delegate?.saveQuote(quote: quoteTextView.text, author: authorTextField.text!)
        dismiss(animated: true)
    }
    
}
