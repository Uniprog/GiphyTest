//
//  Realm+List.swift
//
//
//  Created by Alexander Bukov on 20/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import RealmSwift

extension List {
    var toArray: [Element]? {
        return self.count > 0 ? self.map { $0 } : nil
    }
    
    func appendIfNotExist(_ element:Element) {
        if !self.contains(element) {
            self.append(element)
        }
    }
    
    func removeIfExist(_ element:Element) {
        if let index = self.index(of: element) {
            self.remove(at: index)
        }
    }
}
