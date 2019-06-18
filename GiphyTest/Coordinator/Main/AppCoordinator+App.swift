//
//  AppCoordinator+DeepLink.swift
//  PACoordinatorTemplate
//
//  Created by Alexander on 07/06/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

//! To handle app start and deep link
protocol AppProtocol {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool
}


extension AppCoordinator {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) {
        
        //! Check for remote notification
        if let remoteNotification = launchOptions?[.remoteNotification] as?  [AnyHashable : Any] {
            
            //! Handle remote notification on app launch
            _ = remoteNotification
            
            //! Create deeplink route
            //! TODO:
            
            return
        }
        
        //! TODO: Handle other launch options
        //
        
        
        //! Handle default launch
        //! Set factories
        coordinatorFactory = MainCoordinatorFactory()
        viewModelFactory = MainViewModelFactory()
        
        //! Go to route
        goTo(route: AppCoordinator.Route.giphySearch)
        
        //! To test
//        goTo(route: AppCoordinator.Route.DeepLink.giphySearch(searchKey: "test"))
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.goTo(route: AppCoordinator.Route.clear)
//        }

    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        //! TODO: Handle url and options to create deeplink route
        
        return true
    }
}
