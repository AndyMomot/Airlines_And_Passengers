//
//  Array+Extension.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 17.9.22.
//

import Foundation
extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
