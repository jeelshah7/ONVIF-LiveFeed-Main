//
//  UIViewExt.swift
//  ONVIF-LiveFeed
//
//  Created by Jeel Shah on 31/05/18.
//  Copyright © 2018 Jeel Shah. All rights reserved.
//

import UIKit

extension UIView {
    
    
    
    func addDoneButtonToKeyboard(textField: UITextField) {
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(UIView.endEditing(_:)))
        let toolbar: UIToolbar = UIToolbar()
        toolbar.sizeToFit()
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.setItems([spacer,doneButton], animated: false)
        textField.inputAccessoryView = toolbar
    }
}
