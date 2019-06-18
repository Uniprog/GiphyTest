//
//  Realm+Results.swift
//
//
//  Created by Alexander Bukov on 19/01/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import RealmSwift

extension Results {
    var toArray: [Element]? {
        return self.count > 0 ? self.map { $0 } : nil
    }
}
