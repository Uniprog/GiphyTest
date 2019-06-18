//
//  Realm.swift
//
//
//  Created by Alexander Bukov on 19/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import RealmSwift


extension Realm {
    
    //! Realm instance
    static var instance:Realm {
        get {
            let realm: Realm
            do {
                realm = try Realm()
                return realm
            }
            catch let e {
                print(e)
                fatalError()
            }
        }
    }
}

extension Realm {
    
    func findObject<T: Object, K>(with primaryKey: K) -> T? {
        return self.object(ofType: T.self, forPrimaryKey: primaryKey)
    }
    
    func findOrCreateObject<T: Object, K>(with primaryKey: K) -> T {
        var obj = self.object(ofType: T.self, forPrimaryKey: primaryKey)
        
        if obj == nil { //! Create
            if self.isInWriteTransaction {
                obj =  self.create(T.self, value: [T.primaryKey()!:primaryKey], update: .all)
            }else{
                try! self.write {
                    obj =  self.create(T.self, value: [T.primaryKey()!:primaryKey], update: .all)
                }
            }
        }
        
        return obj!
    }
    
    public func safeWrite(_ block: (() -> Void)) {
        if self.isInWriteTransaction {
            block()
        }else{
            try! self.write {
                block()
            }
        }
    }
    
    public func safeWriteAsync(_ block: @escaping (() -> Void)) {
        DispatchQueue.main.async {
            if self.isInWriteTransaction {
                block()
            }else{
                try! self.write {
                    block()
                }
            }
        }
    }
}

