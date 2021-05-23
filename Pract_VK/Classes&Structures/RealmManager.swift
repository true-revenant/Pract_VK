//
//  RealmManager.swift
//  Pract_VK
//
//  Created by Сергей Бадасян on 13.05.2021.
//

import Foundation
import RealmSwift

class RealmManager {
    
    var currentPhotoOwnerID = 0
    
    static let instance = RealmManager()
    
    private init() {}
    
    func saveToRealm<RealmObj: Object>(arr: [RealmObj]) throws {
        let realm = try Realm()
        
        try realm.write {
            realm.add(arr, update: .all)
        }
        
        print(realm.configuration.fileURL ?? "(no data)")
    }
    
    func removeFromRealm<RealmObj: Object>(obj: RealmObj) {
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.delete(obj)
            }
            
            print(realm.configuration.fileURL ?? "(no data)")
        }
        catch { print(error) }
    }
    
    func addNewGroupToRealm(g : Group) throws {
        let realm = try Realm()
        
        try realm.write {
            
            if realm.object(ofType: Group.self, forPrimaryKey: g.id) != nil { return }
            else { realm.add(g) }

        }
        
        print(realm.configuration.fileURL ?? "(no data)")
    }
    
    func savePhotosToRealm(friendID: Int, phArray: [Photo]) throws {
        let realm = try Realm()
        
        guard let owner = realm.object(ofType: Friend.self, forPrimaryKey: friendID) else { return }
        
        let oldPhotos = owner.photos
        
        try realm.write {
            realm.delete(oldPhotos)
            owner.photos.append(objectsIn: phArray)
        }
        
        print(realm.configuration.fileURL ?? "(no data)")
    }
    
    func loadFromRealm<RealmObj: Object>() throws -> Results<RealmObj> {
        let realm = try Realm()
        return realm.objects(RealmObj.self)
    }
    
    func loadPhotosFromRealm() throws -> List<Photo>? {
        let realm = try Realm()
        
        guard let owner = realm.object(ofType: Friend.self, forPrimaryKey: currentPhotoOwnerID) else { return nil }
        
        return owner.photos
    }
    
    func removeObjsFromRealm<RealmObj: Object>(objs: Results<RealmObj>) {
        do {
            let realm = try Realm()
            realm.delete(objs)
        }
        catch { print(error) }
    }
}
