//
//  TextFireldDelegate.swift
//  ComicMaker
//
//  Created by Ahmed Elgendy on 13/06/2017.
//  Copyright © 2017 Ahmed Elgendy. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    enum ButtonsType: Int {
        case top = 0, bottom
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField.text == "Top"{
            textField.text = ""
        }else if textField.text == "Bottom"{
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.isEmpty)!{
            switch ButtonsType(rawValue: textField.tag)! {
                case .top:
                    textField.text = "Top"
                case .bottom:
                    textField.text = "Bottom"
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}
