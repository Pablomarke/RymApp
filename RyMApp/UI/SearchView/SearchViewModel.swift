//
//  SearchViewModel.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 17/4/24.
//

import Foundation
import Combine

final class SearchViewModel {
    // MARK: - Properties -
    @Published var model: Characters = []
    var cancellables = Set<AnyCancellable>()
    var reloadCharacters = PassthroughSubject<Void, Never>()
    
    func searchCharacters(name: String) {
        NetworkApi.shared.searchCharacters(name: name) { characters in
            self.model = characters.results
            self.reloadCharacters.send()
        }
    }
}
