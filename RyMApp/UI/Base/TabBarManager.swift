//
//  TabBarApp.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 30/3/24.
//

import UIKit

final class TabBarManager {
    static func configureTabBar(for navigationController: UINavigationController) {
        guard let tabBarController = navigationController.tabBarController else {
            return
        }
        
        let tabBar = tabBarController.tabBar
        tabBar.tintColor = Color.secondColor
        tabBar.barTintColor = Color.mainColor
        tabBar.isTranslucent = false
    }
    
    enum TabBarItemTitle: String {
        case characters = "Characters"
        case episodes = "Episodes"
        case locations = "Locations"
        case search = "Search"
    }
    
    static func handleTabBarItemSelection(for item: UITabBarItem,
                                          navigationController: UINavigationController) {
        guard let title = TabBarItemTitle(rawValue: item.title ?? "") else {
            return
        }
        
        switch title {
            case .characters:
                    let myView = CharactersViewController(viewModel: CharactersViewModel())
                    navigationController.setViewControllers([myView],
                                                            animated: true)
            case .episodes:
                let myView = EpisodesViewController(viewModel: EpisodesViewModel())
                    navigationController.setViewControllers([myView], 
                                                            animated: true)
            case .locations:
                    let myView = LocationViewController(viewModel: LocationViewModel())
                    navigationController.setViewControllers([myView], 
                                                            animated: true)
            case .search:
                    let myView = SearchViewController()
                    navigationController.setViewControllers([myView],
                                                            animated: true)
        }
    }
}
