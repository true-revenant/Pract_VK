//
//  CustomSearchBarHeader.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 05.04.2021.
//

import UIKit

class CustomSearchBarHeader : UITableViewHeaderFooterView {
    
    var isSearch : Bool = false
    var searchedText: String = "" {
        didSet {
            print("Searched Text = \(searchedText)")
            if searchedText != "" { isSearch = true }
            else { isSearch = false }
            searchTextField.sendActions(for: .editingChanged)
            searchTextField.sendActions(for: .editingDidEnd)
        }
    }
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBAction func searchTextFieldEdited(_ sender: UITextField) {
        searchedText = searchTextField.text ?? ""
    }
}
