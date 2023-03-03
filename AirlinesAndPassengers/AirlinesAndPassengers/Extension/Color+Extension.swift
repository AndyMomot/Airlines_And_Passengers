//
//  Color+Extension.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 14.9.22.
//

import UIKit

extension UIColor {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat, opacity: CGFloat) {
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: opacity)
    }
}
