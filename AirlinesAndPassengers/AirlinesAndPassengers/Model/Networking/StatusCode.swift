//
//  StatusCode.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 24.9.22.
//

import Foundation

enum StatusCodes: Int {
    case unknownError = 0
    case success = 200
    case created = 201
    case unauthorized = 401
    case notFound = 404
    case server = 500
}
