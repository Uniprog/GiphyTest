//
//  GiphySearchRequest.swift
//  GiphyTest
//
//  Created by Alexander on 17/06/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

//! TODO: Add custom error

class GiphySearchRequest: NSObject {
    var completion:((_ request:GiphySearchRequest, _ items:[GiphyItem], _ error:Error?)->())?
    
    //! TODO: Add init with completion function
    
    func find(key:String, offset:Int, limit:Int, completion:((_ request:GiphySearchRequest, _ items:[GiphyItem], _ error:Error?)->())?) {
        self.completion = completion
        
        var params = [String : Any]()
        
        //! TODO: Move API Key to Constants
        let validAPIKey = "Q2c8RC5sMzITCeEXAukgCZDF0Sft3hOG"
        
        params["api_key"] = validAPIKey
        
        params["q"] = key
        params["limit"] = limit
        params["rating"] = "pg-13"
        params["offset"] = offset
        
        //! TODO: Move URL to Constants
        let url = URL(string: "https://api.giphy.com/v1/gifs/search")!
        Alamofire.request(url, parameters: params, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success:
                guard let value = response.result.value,
                    200 == response.response?.statusCode else {
                        //! TODO: Error type handling
                    self.completion?(self, [], nil)
                    return
                }
                
                let json = JSON(value)
                let data = json["data"]
                
                var giphyItems = [GiphyItem]()
                
                Realm.instance.safeWrite {
                    for item in data.arrayValue {
                        let id = GiphyItem.idFrom(json: item)
                        let giphyItem:GiphyItem = GiphyItem.safeFindOrCreateObject(primaryKey: id)
                        giphyItem.update(json: item)
                        giphyItems.append(giphyItem)
                    }
                }
                
                self.completion?(self, giphyItems, nil)
                
            case .failure(let error):
                print(error)
                self.completion?(self, [], error)
            }
            print(response)
        }
    }
    
    func cancel() {
        //! TODO: Cancel Alamofire request
        self.completion = nil
    }
}
