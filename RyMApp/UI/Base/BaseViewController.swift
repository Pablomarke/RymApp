//
//  BaseViewController.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 30/3/24.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    // MARK: - Properties -
    var cancellables = Set<AnyCancellable>()
    
    func createTabBar(tabBar: UITabBar) {
        tabBar.delegate = self
        tabBar.tintColor = Color.secondColor
        tabBar.barTintColor = Color.mainColor
        tabBar.isTranslucent = false
    }
    
    func viewStyle(title: String) {
        self.view.backgroundColor = Color.mainColor
        self.navigationController?.navigationBar.tintColor = Color.secondColor
        navigationItem.title = title
        let textAttributes = [NSAttributedString.Key.foregroundColor: Color.secondColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
    }
}

// MARK: - UItabBar -
extension BaseViewController: UITabBarDelegate {
    func tabBar(_ tabBar: UITabBar,
                didSelect item: UITabBarItem) {
        TabBarManager.handleTabBarItemSelection(for: item,
                                                navigationController: self.navigationController!)
    }
}
