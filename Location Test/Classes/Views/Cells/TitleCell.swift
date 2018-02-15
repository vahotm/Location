//
//  TitleCell.swift
//  Location Test
//
//  Created by isamalazau on 14.2.18.
//  Copyright © 2018 Ivan Samalazau. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {
    
    struct ViewModel {
        let title: String
        let isEnabled: Bool
        let onChange: (String) -> Void
    }
    
    @IBOutlet weak var textField: UITextField!
    
    private var data: ViewModel?
    
    func setup(with data: ViewModel) {
        self.data = data
        textField.text = data.title
    }
}

// MARK: - UITextFieldDelegate

extension TitleCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        data?.onChange(txtAfterUpdate)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        data?.onChange("")
        return true
    }
}
