//
//  GiphySearch.swift
//  GiphyTest
//
//  Created by Alexander on 17/06/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit
import RealmSwift

class GiphySearch: Object {
    @objc dynamic var id:String = NSUUID().uuidString

    //! Search result items
    let items = List<GiphyItem>()
    
    @objc dynamic var offset: Int = 0
    @objc dynamic var limit: Int = 20

    //! Search key
    @objc dynamic var key: String = ""

    //! Network request
    var request:GiphySearchRequest?

    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["request"]
    }
}

extension GiphySearch {
    
    func find(searchKey:String, onlyFromCache:Bool = false) {
        //! Set search info
        Realm.instance.safeWrite {
            self.key = searchKey
            self.offset = 0
        }
        
        //! Load from network of from cache
        if onlyFromCache {
            DispatchQueue.main.async {
                //! Simple search through cached items
                let results = Realm.instance.objects(GiphyItem.self).filter("title CONTAINS[cd] %@", searchKey)
                
                //! Save and notify about new serch
                Realm.instance.safeWrite {
                    self.items.removeAll()
                }
                Realm.instance.safeWrite {
                    self.items.append(objectsIn: results)
                }
                self.request = nil
            }
        } else {
            //! Load from network
            loadData()
        }
    }
    
    //! Load next page
    func loadMore() {
        //! Check previous request
        if request != nil { return }
        
        //! Set current offset
        Realm.instance.safeWrite {
            self.offset = self.items.count
        }
        
        //! Load page
        loadData()
    }
    
    private func loadData() {
        let offset = self.offset
        
        request = GiphySearchRequest()
        request?.find(key: self.key, offset: offset, limit: limit, completion: {[weak self] (r, items, error) in
            if r != self?.request { return }
            
            DispatchQueue.main.async {
                //! Remove all items and notify to reload UI
                Realm.instance.safeWrite {
                    if offset == 0 {
                        self?.items.removeAll()
                    }
                }
                
                //! Save and notify about new items
                Realm.instance.safeWrite {
                    self?.items.append(objectsIn: items)
                }
                
                //! Clear request to allow new search request
                self?.request = nil
            }
        })
    }
    
    //! Clear search
    func clear()  {
        Realm.instance.safeWriteAsync {
            self.offset = 0
            self.key = ""
            self.items.removeAll()
        }
        self.request = nil
    }
}
