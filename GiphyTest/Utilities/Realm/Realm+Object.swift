//
//  Realm+Object.swift
//
//
//  Created by Alexander Bukov on 19/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import RealmSwift



extension Object {
    class func findObject<T: Object, K>(primaryKey: K, _ realm:Realm = Realm.instance) -> T? {
        let obj = realm.object(ofType: T.self, forPrimaryKey: primaryKey) //! Try to find
        return obj
    }
    
    class func safeFindOrCreateObject<T: Object, K>(primaryKey: K, _ realm:Realm = Realm.instance) -> T {
        var obj = realm.object(ofType: T.self, forPrimaryKey: primaryKey) //! Try to find
        if obj == nil { //! Create
            obj = safeCreateObject(primaryKey: primaryKey) as T
        }
        return obj!
    }
    
    class func safeCreateObject<T: Object, K>(primaryKey: K, _ realm:Realm = Realm.instance) -> T {
        print("\n+++safeCreateObject \(T.self), primaryKey = \(primaryKey) isInWriteTransaction = \(realm.isInWriteTransaction)")
        var obj:T
        //! Create
        if realm.isInWriteTransaction {
            obj = realm.create(T.self, value: [T.primaryKey()!:primaryKey], update: .all)
        }else{
            realm.beginWrite()
            obj =  realm.create(T.self, value: [T.primaryKey()!:primaryKey], update: .all)
            try! realm.commitWrite()
        }
        
        return obj
    }
    
    class func safeCreateObject<T: Object>(_ value: Any = [:], _ realm:Realm = Realm.instance) -> T {
        print("\n+++safeCreateObject \(T.self), isInWriteTransaction = \(realm.isInWriteTransaction)")
        var obj:T
        //! Create
        if realm.isInWriteTransaction {
            obj = realm.create(T.self, value: value, update: .all)
        }else{
            realm.beginWrite()
            obj =  realm.create(T.self, value: value, update: .all)
            try! realm.commitWrite()
        }
        
        return obj
    }
    
}
