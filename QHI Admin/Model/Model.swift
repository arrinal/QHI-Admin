//
//  Model.swift
//  QHI Admin
//
//  Created by Arrinal Sholifadliq on 19/04/22.
//

import Foundation

struct Quote: Codable, Identifiable {
    var id: Int = 0
    var firebaseID: String = ""
    var quoteText: String = ""
    var author: String = ""
    var isQuoteOfTheDay: Bool = false
    var isViewed: Bool = false
}

struct PushNotification: Codable {
    var message_id: Int = 0
}
