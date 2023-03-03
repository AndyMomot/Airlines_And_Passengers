//
//  AirlinesDataModel.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 16.9.22.
//   let airlinesDataModel = try? newJSONDecoder().decode(AirlinesDataModel.self, from: jsonData)

import Foundation

// MARK: - AirlinesDataModelElement
struct AirlinesDataModelElement: Codable {
    let id: Double?
    let name: String?
    let country: String?
    let logo: String?
    let slogan, headQuaters: String?
    let website: String?
    let established: String?
    let createdDate: String?

    enum CodingKeys: String, CodingKey {
        case id, name, country, logo, slogan
        case headQuaters = "head_quaters"
        case website, established, createdDate
    }
}

typealias AirlinesDataModel = [AirlinesDataModelElement]

