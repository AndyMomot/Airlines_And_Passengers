//
//  Notification+Extension.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 24.9.22.
//

import Foundation
extension Notification.Name {
    // Internet connection
    static let InternetNotAvailable = Notification.Name("InternetNotAvailable")
    // Passengers
    static let DidFailPostNewPassenger = Notification.Name("DidFailPostNewPassenger")
    static let DidFailUpdateNewPassenger = Notification.Name("DidFailUpdateNewPassenger")
    static let DidFailGetPassengers = Notification.Name("DidFailGetPassengers")
    // Airlines
    static let DidFailPostNewAirline = Notification.Name("DidFailPostNewAirline")
    static let DidFailGetAirlines = Notification.Name("DidFailGetAirlines")
}

// Used as a namespace for all `Notification` user info dictionary keys
extension Notification {
    struct Key {
        static let ErrorStatusCode = "com.notification.key.errorStatusCode"
        static let ErrorDescription = "com.notification.key.errorDescription"
    }
}

