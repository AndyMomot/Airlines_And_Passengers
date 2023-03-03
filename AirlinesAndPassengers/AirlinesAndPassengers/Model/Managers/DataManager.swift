//
//  DataManager.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 24.9.22.
//

import Foundation

final class DataManager: UnwrappableNetworkResponse {
    static let instance = DataManager()
}

// MARK: - Passengers API
extension DataManager {
    // POST
    func saveNewPassenger(name: String, trips: Int, airline: Int, completionHandler: @escaping () -> Void) {
        NetworkService.postRequest(endpoint: PassengersEndpoint.postPassenger(name: name, trips: trips, airline: airline)) { [unowned self] response in
            let parsedResult: Results<PassengerModelElement> = Parser.parseData(response)
            guard self.unwrapResult(parsedResult, with: .DidFailPostNewPassenger) != nil else { return }
            
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
    // PUT
    func updatePassengerData(id: String?, name: String?, trips: Int?, airline: Int?, completionHandler: @escaping () -> Void) {
        guard
            let id = id,
            let name = name,
            let trips = trips,
            let airline = airline
        else {
            print("Some of the data (id, name, trips, airline) = nil")
            return
        }

        NetworkService.postRequest(endpoint: PassengersEndpoint.putPassenger(id: id, name: name, trips: trips, airline: airline)) { [unowned self] response in
            let parsedResult: Results<PassengerModelElement> = Parser.parseData(response)
            guard self.unwrapResult(parsedResult, with: .DidFailUpdateNewPassenger) != nil else { return }

            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
    // PATCH
    func updatePassengerName(id: String?, name: String?, completionHandler: @escaping () -> Void) {
        guard
            let id = id,
            let name = name
        else {
            print("Some of the data (id, name) = nil")
            return
        }
        
        NetworkService.postRequest(endpoint: PassengersEndpoint.patchPassenger(id: id, name: name)) { [unowned self] response in
            let parsedResult: Results<PassengerModelElement> = Parser.parseData(response)
            guard self.unwrapResult(parsedResult, with: .DidFailUpdateNewPassenger) != nil else { return }

            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
    // GET
    func requestAllPassengers(completionHandler: @escaping ([PassengerModelElement]?) -> Void) {
        NetworkService.request(endpoint: PassengersEndpoint.getAllPassengers) { [unowned self] networkResponse in
            let parsedResult: Results<PassengerDataModel> = Parser.parseData(networkResponse)
            guard let loadedModel = self.unwrapResult(parsedResult, with: .DidFailGetPassengers) else { return }
            
            DispatchQueue.main.async {
                completionHandler(loadedModel.data)
            }
        }
    }
    
    // GET
    func requestSomePassengers(limit: Int = ConstantsGlobal.PaginationLimits.passengers,
                           completionHandler: @escaping ([PassengerModelElement]?) -> Void) {
        NetworkService.request(endpoint: PassengersEndpoint.getSomePassengers(limit: limit)) { [unowned self] networkResponse in
            let parsedResult: Results<PassengerDataModel> = Parser.parseData(networkResponse)
            guard let loadedModel = self.unwrapResult(parsedResult, with: .DidFailGetPassengers) else { return }
            
            DispatchQueue.main.async {
                completionHandler(loadedModel.data)
            }
        }
    }
    
    // DELETE
    func deletePassenger(id: String?, completionHandler: @escaping ([PassengerModelElement]?) -> Void) {
        guard let id = id else {
            print("Not found the id: \(id ?? "nil")")
            return
        }

        NetworkService.request(endpoint: PassengersEndpoint.delPassenger(id: id)) { [unowned self] networkResponse in
            let parsedResult: Results<PassengerDataModel> = Parser.parseData(networkResponse)
            guard let loadedModel = self.unwrapResult(parsedResult, with: .DidFailGetPassengers) else { return }
            
            DispatchQueue.main.async {
                completionHandler(loadedModel.data)
            }
        }
    }
}

// MARK: - Airlines API
extension DataManager {
    // POST
    func saveNewAirline(model: AirlinePost ,completionHandler: @escaping () -> Void) {
        let airline = AirlinePost(id: model.id, name: model.name, country: model.country,
                                  logo: model.logo, slogan: model.slogan, headQuaters: model.headQuaters,
                                  website: model.website, established: model.established)
        
        NetworkService.postRequest(endpoint: AirlinesEndpoint.postAirline(model: airline)) { [unowned self] response in
            let parsedResult: Results<AirlinesDataModelElement> = Parser.parseData(response)
            guard self.unwrapResult(parsedResult, with: .DidFailPostNewAirline) != nil else { return }
            
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
    
    // GET
    func requestAllAirlines(completionHandler: @escaping ([AirlinesDataModelElement]?) -> Void) {
        NetworkService.request(endpoint: AirlinesEndpoint.getAllAirlines) { [unowned self] networkResponse in
            let parsedResult: Results<AirlinesDataModel> = Parser.parseData(networkResponse)
            guard let loadedModel = self.unwrapResult(parsedResult, with: .DidFailGetAirlines) else { return }
            
            DispatchQueue.main.async {
                completionHandler(loadedModel)
            }
        }
    }
    
    // GET
    func requestSomeAirline(id: Int, completionHandler: @escaping ([AirlinesDataModelElement]?) -> Void) {
        NetworkService.request(endpoint: AirlinesEndpoint.getSomeAirlines(id: id)) {[unowned self] networkResponse in
            let parsedResult: Results<AirlinesDataModelElement> = Parser.parseData(networkResponse)
            guard let loadedModel = self.unwrapResult(parsedResult, with: .DidFailGetAirlines) else { return }
            
            DispatchQueue.main.async {
                completionHandler([loadedModel])
            }
        }
    }
    
}
