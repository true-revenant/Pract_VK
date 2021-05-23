//
//  FriendSearch.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 18.03.2021.
//

import UIKit

class FriendSearchControl: UIControl {
    
    var letters = [Character]() {
        didSet {
            print("обновили массив букв!")
        }
    }
    
    var selectedLetter: String = "" {
        didSet {
            self.updateSelectedLetter()
            self.sendActions(for: .valueChanged)
        }
    }
    
    private var letterButtons = [UIButton]()
    private var stackView: UIStackView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func initButtonsArray() {
        //letters = ["a", "b", "c", "d", "e"]
        letterButtons.removeAll()
        for l in letters {
            let button = UIButton(type: .system)
            button.setTitle(String(l), for: .normal)
            button.setTitleColor(.systemGray, for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.addTarget(self, action: #selector(selectLetter(sender:)), for: .touchUpInside)
            letterButtons.append(button)
        }
        print("Кол-во кнопок с буквами = \(letterButtons.count)")
    }
    
    func removeButton(name: String) {
        
    }
    
    func initControl() {
        backgroundColor = .clear
        
        if subviews.count > 0 { stackView.removeFromSuperview() }
        
        initButtonsArray()
        
        stackView = UIStackView(arrangedSubviews: self.letterButtons)
        self.addSubview(stackView)
        
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    @objc private func selectLetter(sender: UIButton) {
        guard self.letterButtons.firstIndex(of: sender) != nil else { return }
        selectedLetter = sender.titleLabel?.text ?? ""
    }
    
    private func updateSelectedLetter() {
        for b in self.letterButtons {
            b.isSelected = selectedLetter == b.titleLabel?.text
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
