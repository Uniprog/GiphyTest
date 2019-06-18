//
//  RealmManager.swift
//  Girl Scouts
//
//  Created by Alexander Bukov on 19/01/2019.
//  Copyright © 2019 GGA. All rights reserved.
//

import UIKit
import RealmSwift

class RealmManager: NSObject {
    public static let instance = RealmManager()

    private override init() {
        super.init()
        
        //! Setup Realm confuguration
        setupRealmConfiguration()
    }
    
    //! Realm configuration
    private func setupRealmConfiguration() {
        
        let defaultConfig = Realm.Configuration()
        let fileURL = defaultConfig.fileURL!.deletingLastPathComponent().appendingPathComponent("gt.realm")
        
        var config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 0,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        //! Skip migration
        config.deleteRealmIfMigrationNeeded = true
        
        //! Realm db file
        config.fileURL = fileURL
        print("Realm folderPath = \(fileURL.absoluteString)")
        
        //! Update default configuration
        Realm.Configuration.defaultConfiguration = config
        let realm = try? Realm(configuration: Realm.Configuration.defaultConfiguration)
        print(realm.debugDescription)
    }
}
