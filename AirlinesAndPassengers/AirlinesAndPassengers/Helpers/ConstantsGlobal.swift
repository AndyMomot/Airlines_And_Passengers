//
//  Constants.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 24.9.22.
//

enum ConstantsGlobal {
    enum Heder {
        static let value = "application/json"
        static let field = "Content-Type"
    }
    
    enum HTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
    
    enum PaginationLimits {
        static let passengers = 20
    }
}
