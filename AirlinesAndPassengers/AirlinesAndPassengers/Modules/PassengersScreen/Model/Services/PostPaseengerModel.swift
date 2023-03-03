//
//  PostPassengerModel.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 20.9.22.
//

import UIKit

struct PassengerModel {
    
    func passengerModel(name: String, trips: UInt, airline: UInt) -> [String: Any] {
        return ["name": name, "trips": trips, "airline": airline]
    }
    
    func createPostForTestAPI(title: String, body: String) -> [String: Any] {
        return ["title": title, "body": body]
    }
}
