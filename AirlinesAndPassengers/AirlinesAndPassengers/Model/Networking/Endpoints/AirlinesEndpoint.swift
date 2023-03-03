//
//  AirlinesEndpoint.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 25.9.22.
//

import Foundation
struct AirlinePost {
    let id: Int
    let name: String
    let country: String
    let logo: String
    let slogan: String
    let headQuaters: String
    let website: String
    let established: String
    
    init(id: Int, name: String, country: String, logo: String, slogan: String, headQuaters: String, website: String, established: String) {
        self.id = id;           self.name = name;      self.country = country
        self.logo = logo;       self.slogan = slogan;  self.headQuaters = headQuaters
        self.website = website; self.established = established
    }
}

enum AirlinesEndpoint: Endpoint {
    case getAllAirlines
    case getSomeAirlines(id: Int)
    case postAirline(model: AirlinePost)
}

extension AirlinesEndpoint {
    var path: String {
        switch self {
        case .getAllAirlines:
            return "airlines"
        case .getSomeAirlines(id: let id):
            return "airlines/\(id)"
        case .postAirline(model: _):
            return "airlines"
        }
    }
    
    var method: ConstantsGlobal.HTTPMethod {
        switch self {
        case .getAllAirlines, .getSomeAirlines:
            return .get
        case .postAirline:
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
        case .getAllAirlines, .getSomeAirlines:
            params = [:]
        case .postAirline(model: let model):
            params = [
                "id": model.id,
                "name": model.name,
                "country": model.country,
                "logo": model.logo,
                "slogan": model.slogan,
                "head_quaters": model.headQuaters,
                "website": model.website,
                "established": model.established
            ]
        }
        return params
    }
}
