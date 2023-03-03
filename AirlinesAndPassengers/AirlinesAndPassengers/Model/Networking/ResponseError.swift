//
//  ResponseError.swift
//  MtsAstra
//
//  Created by SerhiiHaponov on 02.08.2021.
//

import Foundation

enum ResponseError: LocalizedError {
    case dataMissed
    case invalidFormat(for: Any.Type)
    case failed(code: StatusCodes, description: String? = nil, data: Data?)
    
    var statusCode: StatusCodes? {
        switch self {
        case .failed(let code, _, _):
            return code
        default:
            return nil
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .dataMissed:
            return "Error: Data missed"
        case .invalidFormat(for: let entityType):
            return "Error: Wrong format for \(entityType)"
        case .failed(_, let description, _):
            return description
        }
    }
    
    var data: Data? {
        switch self {
        case .failed( _, _, let data):
            return data
        default:
            return nil
        }
    }
}
