//
//  Session.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 25.04.2021.
//

import Foundation

class CurrentSession {
    
    static let instance = CurrentSession()
    
    private init() {}
    
    var fio : String = ""
    var token : String = ""
    var userID : String = ""
}
