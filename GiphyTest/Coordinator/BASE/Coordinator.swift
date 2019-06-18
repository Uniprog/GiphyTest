//
//  Coordinator.swift
//  PACoordinatorTemplate
//
//  Created by Alexander on 06/06/2019.
//  Copyright © 2019 Alexander. All rights reserved.
//

import UIKit

protocol CoordinatorProtocol: class {
    func start()
}

//! Simple coordinator implementation
class Coordinator: CoordinatorProtocol {
    private var childCoordinators: [CoordinatorProtocol] = []
    
    deinit {
        print("deinit " + String(describing: self))
    }
    
    func start() {}
    
    func getRootViewController() -> UIViewController {
        fatalError("getRootViewController must be override")
    }
    
    func addDependency(_ coordinator:CoordinatorProtocol) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
        print("ADDED " + String(describing: self) + " addDependency " + String(describing: coordinator))
    }
    
    func removeDependency(_ coordinator: CoordinatorProtocol?) {
        guard childCoordinators.isEmpty == false, let coordinator = coordinator else { return }
        
        // Clear child-coordinators recursively
        if let coordinator = coordinator as? Coordinator, !coordinator.childCoordinators.isEmpty {
            coordinator.childCoordinators
                .filter({ $0 !== coordinator })
                .forEach({ coordinator.removeDependency($0) })
        }
        //! Remove
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            print("REMOVED " + String(describing: self) + " removeDependency " + String(describing: coordinator))
            break
        }
    }
}


//! Coordinators search
extension Coordinator {
    func findAllCoordinators<T:Coordinator>() -> [T] {
        return childCoordinators.compactMap { $0 as? T }
    }
    
    func findFirstCoordinator<T:Coordinator>() -> T? {
        return childCoordinators.compactMap { $0 as? T }.first
    }
}

