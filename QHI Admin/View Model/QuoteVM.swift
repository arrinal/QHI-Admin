//
//  QuoteVM.swift
//  QHI Admin
//
//  Created by Arrinal Sholifadliq on 19/04/22.
//

import Foundation
import Firebase
import Network

protocol VMDelegate {
    func reloadData()
    
    func allowTableSelection(allow: Bool)
}

class QuoteListVM {
    
    @Published var quoteList = [Quote]()
    
    let db = Firestore.firestore()
    
    var filteredQuoteForUncheckFirebase = Quote()
    
    var delegate: VMDelegate?
    
    func monitorInternet() {
        
        let monitor = NWPathMonitor()
        var isInternetError = false

        monitor.pathUpdateHandler = { path in
            
            if path.status == .satisfied {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isInternetError = false
                    self.delegate!.allowTableSelection(allow: true)
                    self.delegate!.reloadData()
                }
                
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    isInternetError = true
                    self.delegate!.allowTableSelection(allow: false)
                    self.delegate!.reloadData()
                }
                
            }
        }
        
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
    
    func getQuote() {
        
        
        let collection = db.collection("quote").order(by: "id")
        collection.getDocuments { snapshot, error in
            if error == nil && snapshot != nil {
                var quoteList = [Quote]()
                
                for doc in snapshot!.documents {
                    var q = Quote()
                    
                    q.id = doc["id"] as? Int ?? 0
                    q.firebaseID = doc["firebaseID"] as? String ?? ""
                    q.author = doc["author"] as? String ?? ""
                    q.quoteText = doc["quoteText"] as? String ?? ""
                    q.isQuoteOfTheDay = doc["isQuoteOfTheDay"] as? Bool ?? false
                    q.isViewed = false
                    
                    quoteList.append(q)
                }
                
                DispatchQueue.main.async {
                    self.quoteList = quoteList
                    self.delegate!.reloadData()
                }
                
                
            }
        }
    }
    
    func saveQuote(quote: String, author: String) {
        
        let max = quoteList.max(by: { first, second in
            first.id < second.id
        })
        
        let quoteCollection = db.collection("quote")
        
        let document = quoteCollection.addDocument(data: ["id": max!.id + 1 as Int,
                                                "author": author,
                                                "quoteText": quote,
                                                "isQuoteOfTheDay": false])
        
        document.updateData(
            [
                "firebaseID": document.documentID
            ]
        )
        
        getQuote()
    }
    
    func uncheckPreviousQuote(quotes: [Quote]) {
        print(quotes.filter( { $0.isQuoteOfTheDay } ).count)
        guard quotes.filter( { $0.isQuoteOfTheDay } ).count == 1 else { return }
        
        quoteList = quoteList.map { (quote) -> Quote in
            var quote = quote
            if quote.isQuoteOfTheDay == quotes.filter( { $0.isQuoteOfTheDay } )[0].isQuoteOfTheDay {
                quote.isQuoteOfTheDay = false
                filteredQuoteForUncheckFirebase = quote
            }
            return quote
        }
    }
    
    func uncheckPreviousQuoteFirebase() {
        let query = db.collection("quote").document(filteredQuoteForUncheckFirebase.firebaseID)
        query.updateData(["isQuoteOfTheDay": false])
    }
    
    func checklistNewQuote(quote: inout Quote) {
        quote.isQuoteOfTheDay = true
    }
    
    func checklistNewQuoteFirebase(indexPath: IndexPath) {
        let newQuoteClicked = db.collection("quote").document(quoteList[indexPath.row].firebaseID)
        newQuoteClicked.updateData(["isQuoteOfTheDay": true])
    }
    
    func sendPushNotification(indexPath: IndexPath) {
        var pushNotifID = PushNotification()
        
        let quote = quoteList[indexPath.row].quoteText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let author = quoteList[indexPath.row].author.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        var request = URLRequest(url: URL(string: "https://arrinal.com/quotehariini/send.php?quote=\(quote ?? "")&author=\(author ?? "")")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            
            let result = try? JSONDecoder().decode(PushNotification.self, from: data)
            if let result = result {
                DispatchQueue.main.async {
                    pushNotifID = result
                    print(pushNotifID)
                }
            } else {
                print("error parsing")
            }
        }.resume()
    }
}
