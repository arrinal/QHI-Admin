//
//  ViewController.swift
//  QHI Admin
//
//  Created by Arrinal Sholifadliq on 19/04/22.
//

import UIKit
import Firebase



enum Checkbox: String {
    case checklist = "checkmark.square"
    case unchecklist = "square"
}

class ViewController: UIViewController {
    
    var quoteListVM = QuoteListVM()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        quoteListVM.delegate = self
        quoteListVM.getQuote()
        quoteListVM.monitorInternet()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    func setupUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Quote", style: .plain, target: self, action: #selector(addQuote))
        
        
        
    }
    
    @objc private func addQuote() {
        let vc = AddQuoteViewController()
        vc.delegate = self
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .automatic
        self.present(navController, animated: true)
    }
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, VMDelegate, AddQuoteDelegate {
    
    func saveQuote(quote: String, author: String) {
        
        quoteListVM.saveQuote(quote: quote, author: author)
    }
    
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func allowTableSelection(allow: Bool) {
        self.tableView.allowsSelection = allow
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return quoteListVM.quoteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as! CustomTableViewCell
        
        cell.configure(checkbox: quoteListVM.quoteList[quoteListVM.quoteList.count - 1 - indexPath.row].isQuoteOfTheDay ?  Checkbox.checklist.rawValue : Checkbox.unchecklist.rawValue, text: "\(quoteListVM.quoteList[quoteListVM.quoteList.count - 1 - indexPath.row].quoteText)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        DispatchQueue.main.async {
            self.quoteListVM.uncheckPreviousQuote(quotes: self.quoteListVM.quoteList)
            self.quoteListVM.uncheckPreviousQuoteFirebase()
            self.quoteListVM.checklistNewQuote(quote: &self.quoteListVM.quoteList[self.quoteListVM.quoteList.count - 1 - indexPath.row])
            self.quoteListVM.checklistNewQuoteFirebase(indexPath: indexPath)
            self.quoteListVM.sendPushNotification(indexPath: indexPath)
            
            tableView.reloadData()
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            quoteListVM.deleteRowFirebase(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
