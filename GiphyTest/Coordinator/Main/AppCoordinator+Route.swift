//
//  AppCoordinator+Route.swift
//  PACoordinatorTemplate
//
//  Created by Alexander on 07/06/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit


extension AppCoordinator {
    
    func goTo(route: AppCoordinator.Route) {
        
        //! Handle regular route
        switch route {
            //! Go to Giphy search
        case .giphySearch:
            let sb = UIStoryboard(name: "Giphy", bundle: nil)
            let vc = sb.instantiateInitialViewController() as! GiphyViewController
            rootViewController.viewControllers = [vc]
            break
            
            //! Clear and reload all coordinator content
        case .reload:
            removeDependency(self)
            rootViewController.viewControllers = []
            start()
            //! Set factories
            coordinatorFactory = MainCoordinatorFactory()
            viewModelFactory = MainViewModelFactory()
            
            //! Go to route
            goTo(route: AppCoordinator.Route.giphySearch)
            break
            
            //! Clear coordinator UI
        case .clear:
            removeDependency(self)
            rootViewController.viewControllers = []
            break
        }
    }
    
    //! Handle deep link route
    func goTo(route: AppCoordinator.Route.DeepLink) {
        switch route {
        case .giphySearch(let searchKey):
            let sb = UIStoryboard(name: "Giphy", bundle: nil)
            let vc = sb.instantiateInitialViewController() as! GiphyViewController
            vc.defaultSearchKey = searchKey
            rootViewController.viewControllers = [vc]
            break
        }
    }
}

//! App coordinator routes
extension AppCoordinator {
    enum Route {
        case giphySearch
        case reload
        case clear
    }
}

//! Deep link routes
extension AppCoordinator.Route {
    enum DeepLink {
        case giphySearch(searchKey:String)
    }
}
