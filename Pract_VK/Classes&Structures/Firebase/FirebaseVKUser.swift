//
//  FirebaseUser.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 24.06.2021.
//

import Foundation
import FirebaseDatabase

class FirebaseVKUser {
    
    var id : String
    var ref : DatabaseReference?
    
    init(id: String) {
        self.id = id
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
              let id = value["id"] as? String else {
            return nil
        }
        
        self.id = id
        self.ref = snapshot.ref
    }
    
    func toAnyObject() -> [String: Any] {
        
        return [
            "id": id,
        ]
    }
}
