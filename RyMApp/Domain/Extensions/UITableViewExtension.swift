//
//  UITableViewExtension.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 5/12/23.
//

import UIKit

extension UITableView {
    func clearBackground() {
        self.backgroundColor = Color.clearColor
        self.backgroundView = UIView.init(frame: CGRect.zero)
    }
    
    func createTable(cellIdentifier: String) {
        self.register(UINib(nibName: cellIdentifier,
                                    bundle: nil),
                              forCellReuseIdentifier: cellIdentifier)
        self.clearBackground()
    }
}
