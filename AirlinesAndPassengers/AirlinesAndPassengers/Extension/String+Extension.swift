//
//  String+Extension.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 24.9.22.
//

import Foundation
extension String {
    
    var urlValue: URL? {
        return URL(string: self)
    }
}
