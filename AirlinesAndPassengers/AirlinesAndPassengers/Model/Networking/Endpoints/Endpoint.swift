//
//  Endpoint.swift
//  MtsAstra
//
//  Created by SerhiiHaponov on 02.08.2021.
//

import Foundation

protocol Endpoint {
    var path: String { get }
    var method: ConstantsGlobal.HTTPMethod { get }
    var parameters: [String: Any]? { get }
}
