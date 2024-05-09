//
//  LocationDetailViewModel.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 17/4/24.
//

import Foundation
import Combine
final class LocationDetailViewModel {
    // MARK: - Properties -
    @Published var model: Location
    
    // MARK: - Init -
    init(_ model: Location) {
        self.model = model
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
