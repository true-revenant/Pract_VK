//
//  CustomSearchBar.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 05.04.2021.
//

import UIKit

class CustomSearchBar: UIControl {

    var searchText: String = "" {
        didSet {
            self.sendActions(for: .editingChanged)
        }
    }
    
    private var searchImage: UIImageView =  UIImageView()
    private var cancelButton: UIButton = UIButton()
    private var searchTextField: UITextField = UITextField()
    private var element_height : CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initControls()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initControls()
    }
    
    private func initialAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
            self.searchImage.transform = .identity
        }, completion: { success in })
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.cancelButton.alpha =  1
        }, completion: { success in })
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.searchTextField.alpha = 1
            self.searchTextField.transform = .identity
        }, completion: { success in })
    }
    
    private func exitAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [], animations: {
            self.searchImage.transform = CGAffineTransform(translationX: self.bounds.midX - self.element_height / 2, y: 3)
        }, completion: { success in })
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            self.cancelButton.alpha =  0
        }, completion: { success in })
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            self.searchTextField.alpha = 0
            self.searchTextField.transform = CGAffineTransform(scaleX: 0.1, y: 0)
        }, completion: { success in })
        
        beforeActivationState()
    }
    
    // BEFORE ANIMATION STATE
    private func beforeActivationState() {
        searchTextField.alpha = 0
        searchTextField.transform = CGAffineTransform(scaleX: 0.1, y: 0)
        cancelButton.alpha = 0
        searchImage.transform = CGAffineTransform(translationX: UIScreen.main.bounds.midX - element_height / 2, y: 0)
    }
    
    private func initControls() {
        
        backgroundColor = .systemGray
        
        element_height = bounds.height - 6
        let screen_width = UIScreen.main.bounds.width
        
        searchImage = UIImageView(frame: CGRect(x: 3, y: 3, width: element_height, height: element_height))
        searchImage.image = UIImage(named: "search_icon")
        searchImage.backgroundColor = .clear
        searchImage.tintColor = .black
        
        cancelButton = UIButton(frame: CGRect(x: element_height + (screen_width - element_height * 2) - 3, y: 3, width: element_height, height: element_height))
        cancelButton.setImage(UIImage(named: "cancel-sign"), for: .normal)
        cancelButton.tintColor = .black
        cancelButton.backgroundColor = .clear
        cancelButton.addTarget(self, action: #selector(cancelTapped(sender:)), for: .touchUpInside)
        
        searchTextField = UITextField(frame: CGRect(x: 3 + element_height + 3, y: 3, width: screen_width - 12 - element_height * 2, height: element_height))
        searchTextField.borderStyle = .roundedRect
        searchTextField.tintColor = .white
        searchTextField.placeholder = ".. введите ваш запрос .."
        searchTextField.autocorrectionType = .no
        searchTextField.contentVerticalAlignment = .center
        searchTextField.addTarget(self, action: #selector(searchBarTextChanged(sender:)), for: .editingChanged)
        searchTextField.addTarget(self, action: #selector(searchBarExit(sender:)), for: .editingDidEnd)
        
        addSubview(searchImage)
        addSubview(searchTextField)
        addSubview(cancelButton)
        
        beforeActivationState()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    @objc private func searchBarTextChanged(sender: UITextField) {
        searchText = sender.text ?? ""
    }
    
    @objc private func searchBarExit(sender: UITextField) {
        print("Сняли фокус со строки поиска!")
        exitAnimation()
    }
    
    @objc private func cancelTapped(sender: UIButton) {
        searchTextField.text = ""
        searchText = ""
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        initialAnimation()
    }
}
