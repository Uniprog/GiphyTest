//
//  AppManager.swift
//  GiphyTest
//
//  Created by Alexander on 18/06/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

class AppManager: NSObject {
    static let instance = AppManager()
    
    //! App delegate
    var appDelegate:AppDelegate!
    
    //! App coordinator
    var appCoordinator:AppCoordinator!
    
    
    private override init() {
        super.init()
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        //! App delegate
        appDelegate = application.delegate as? AppDelegate
        
        //! Configure realm
        _ = RealmManager.instance
        
        //! TODO: Add DB size limit
        //! TODO: Add image cache limit/check
        
        //! Create App coordinator base on launchOptions
        appCoordinator = AppCoordinator(window:appDelegate.window!)
        appCoordinator.start()
        
        //! Handle launch options in coordinator
        appCoordinator.application(application, didFinishLaunchingWithOptions: launchOptions)
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        //! Handle open url in coordinator
        return appCoordinator.application(app, open: url, options: options)
    }
}


