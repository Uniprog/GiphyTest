//
//  GiphyItem.swift
//  GiphyTest
//
//  Created by Alexander on 17/06/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON

class GiphyItem: Object {
    @objc dynamic var id:String = NSUUID().uuidString

    @objc dynamic var title: String = ""

    @objc dynamic var width: Float = 100
    @objc dynamic var heigth: Float = 100
    @objc dynamic var url: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return []
    }
}


extension GiphyItem {
    
    //! Update object info
    func update(json:JSON) {
        if id != json["id"].string { return }
        
        title = json["title"].stringValue

        //! TODO: Choose best image size
        let imageInfo = json["images"]["fixed_width"]
        
        width = imageInfo["width"].floatValue
        heigth = imageInfo["height"].floatValue
        url = imageInfo["url"].stringValue
    }
    
    //! Get id from json
    class func idFrom(json:JSON) -> String? {
        return json["id"].string
    }
}
