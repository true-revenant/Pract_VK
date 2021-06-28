//
//  FirestoreManager.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 27.06.2021.
//

import Foundation
import FirebaseFirestore

class FirestoreManager {
    
    private init() {}
    
    //static let instance = FirestoreManager()
    
    static func saveGroupToFirestore(_ group: Group, _ userId: String)
    {
        let database = Firestore.firestore()
        let groupToSend = group.toFiresrore(userId: userId)
           
        database.collection("GroupsAddedByUser_" + userId).document("group_" + String(group.id)).setData(groupToSend, merge: true) { error in
        if let error = error {
            print(error.localizedDescription)
            } else { print("data saved")}
        }
    }
    
}
