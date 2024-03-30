//
//  CharactersViewModel.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 30/3/24.
//

import Foundation
import Combine

final class CharactersViewModel {
    // MARK: - Properties -
    @Published var model: AllCharacters
    var countPage = 1
    var cancellables = Set<AnyCancellable>()
    let nextPage = PassthroughSubject<Void, Error>()
    let prevPage = PassthroughSubject<Void, Error>()

    
    // MARK: - Init -
    init(_ model: AllCharacters) {
        self.model = model
    }
    
    func nextPageDataByAPI() {
        NetworkApi.shared.pages(url: (model.info?.next ?? "")) { [weak self] allCharacters in
            self?.model = allCharacters
            self?.countPage += 1
            self?.nextPage.send()
        }
    }
    
    func prevPageDagaByAPI() {
        NetworkApi.shared.pages(url: (model.info?.prev ?? "")) { [weak self] allCharacters in
            self?.model = allCharacters
            self?.countPage -= 1
            self?.prevPage.send()
        }
    }
}
