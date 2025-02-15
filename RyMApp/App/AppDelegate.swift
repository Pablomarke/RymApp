//
//  AppDelegate.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 27/7/23.
//

import UIKit

@main
class AppDelegate: UIResponder,
                    UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let viewModel = CharactersViewModel()
        let home = CharactersViewController(viewModel: viewModel)
        let nav = UINavigationController(rootViewController: home)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }
}
