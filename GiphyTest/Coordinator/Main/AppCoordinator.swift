//
//  AppCoordinator.swift
//  PACoordinatorTemplate
//
//  Created by Alexander on 07/06/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

protocol MainCoordinatorFactoryProtocol:class {
}
protocol MainViewModelFactoryProtocol {
}

class AppCoordinator: Coordinator, AppProtocol {
    //! Root controller (Possible update to Router with custom presentations)
    var window: UIWindow
    private(set) var rootViewController: UINavigationController!
    
    //! Coordinators and view models
    var coordinatorFactory:MainCoordinatorFactoryProtocol!
    var viewModelFactory:MainViewModelFactoryProtocol!
    
    //! Not used
    private override init() { self.window = UIWindow() }
    
    //! Init
    init(window: UIWindow) {
        self.window = window
    }
    
    //! Prepare coordinator to handle first route
    override func start() {
        self.rootViewController = UINavigationController()
        self.rootViewController.isNavigationBarHidden = false
        window.rootViewController = self.rootViewController
    }
    
}

