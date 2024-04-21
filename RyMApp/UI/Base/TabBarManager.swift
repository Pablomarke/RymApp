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
                NetworkApi.shared.getArrayEpisodes(season: "1,2,3,4,5,6,7,8,9,10,11") { episodes in
                    let myView = EpisodesViewController(episodes)
                    navigationController.setViewControllers([myView], 
                                                            animated: true)
                }
            case .locations:
                NetworkApi.shared.getAllLocations() { locations in
                    let myView = LocationViewController(viewModel: LocationViewModel())
                    navigationController.setViewControllers([myView], 
                                                            animated: true)
                }
            case .search:
                    let myView = SearchViewController()
                    navigationController.setViewControllers([myView],
                                                            animated: true)
        }
    }
}
