//
//  SearchBar+Extension.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 18.9.22.
//

import UIKit
extension UISearchBar {
    func setTextFieldColor(_ color: UIColor) {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                let view = subSubView as? UITextInputTraits
                if view != nil {
                    let textField = view as? UITextField
                    textField?.backgroundColor = color
                    break
                }
            }
        }
    }
    
    func setIconColor(_ color: UIColor) {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                let view = subSubView as? UITextInputTraits
                if view != nil {
                    let textField = view as? UITextField
                    let glassIconView = textField?.leftView as? UIImageView
                    glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
                    glassIconView?.tintColor = color
                    break
                }
            }
        }
    }
    
    func setButtonColor(_ color: UIColor) {
        for subView in self.subviews {
            for subSubView in subView.subviews {
                let view = subSubView as? UITextInputTraits
                if view != nil {
                    let textField = view as? UITextField
                    let glassIconView = textField?.leftView as? UIButton
                    glassIconView?.setTitle("TEST", for: .normal)
                    break
                }
            }
        }
    }
    
    func setPlaceholderColor(_ color: UIColor) {
        let textField = self.value(forKey: "searchField") as? UITextField
        let placeholder = textField!.value(forKey: "placeholderLabel") as? UILabel
        placeholder?.textColor = color
    }
}
