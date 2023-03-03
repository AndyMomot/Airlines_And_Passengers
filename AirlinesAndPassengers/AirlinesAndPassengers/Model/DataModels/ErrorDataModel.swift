//
//  ErrorDataModel.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 24.9.22.
//

import Foundation
struct ErrorDataModel: Codable, Error {
    let errors: [ErrorModel]
}

struct ErrorModel: Codable {
    let code: Int?
    let description: String?
}
