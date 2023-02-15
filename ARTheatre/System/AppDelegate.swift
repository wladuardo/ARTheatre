//
//  AppDelegate.swift
//  ARTheatre
//
//  Created by Владислав Ковальский on 15.02.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupNavigationController()
        return true
    }
    
    private func setupNavigationController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainVC = MainViewController()
        
        let navigationController = UINavigationController(rootViewController: mainVC)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

}

