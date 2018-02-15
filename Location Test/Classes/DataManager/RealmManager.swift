//
//  RealmManager.swift
//  Location Test
//
//  Created by isamalazau on 14.2.18.
//  Copyright © 2018 Ivan Samalazau. All rights reserved.
//

import RealmSwift

final class RealmManager {
    
    private init() { }
    
    class func setup() {
        let config = Realm.Configuration()
        Realm.Configuration.defaultConfiguration = config
    }
    
    class func create<T: Object>(_ object: T) {
        guard let realm = try? Realm() else { return }
        
        try? realm.write {
            realm.add(object)
        }
    }
    
    class func update<T: Object>(_ object: T, block: (T) -> Void) {
        guard let realm = try? Realm() else { return }
        
        try? realm.write {
            block(object)
        }
    }
    
    class func delete<T: Object>(_ object: T) {
        guard let realm = try? Realm() else { return }
        
        try? realm.write {
            realm.delete(object)
        }
    }
    
    class func fetchObjects<T: Object>(predicate: String? = nil) -> [T] {
        guard let realm = try? Realm() else { return [] }
        
        let objects = realm.objects(T.self)
        if let predicate = predicate {
            let filtered = objects.filter(predicate)
            return Array(filtered)
        }
        return Array(objects)
    }
    
    class func rewrite<T: Object>(_ objects: [T], with newObjects: [Any]) {
        guard let realm = try? Realm() else { return }
        
        try? realm.write {
            realm.delete(objects)
            for newItem in newObjects {
                realm.create(T.self, value: newItem, update: false)
            }
        }
    }
}
