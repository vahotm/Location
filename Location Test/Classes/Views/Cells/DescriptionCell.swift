//
//  DescriptionCell.swift
//  Location Test
//
//  Created by isamalazau on 14.2.18.
//  Copyright © 2018 Ivan Samalazau. All rights reserved.
//

import UIKit

class DescriptionCell: UITableViewCell {
    
    struct ViewModel {
        let description: String
        let onChange: (String) -> Void
    }
    
    @IBOutlet weak var textView: UITextView!
    
    private var data: ViewModel?
    
    func setup(with data: ViewModel) {
        textView.text = data.description
    }
}

// MARK: - UITextViewDelegate

extension DescriptionCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textFieldText: NSString = (textView.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: text)
        data?.onChange(txtAfterUpdate)
        return true
    }
}
