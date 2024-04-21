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
    @Published var model: AllCharacters?
    @Published var characters: Characters = []
    var countPage = 1
    var cancellables = Set<AnyCancellable>()
    let nextPage = PassthroughSubject<Void, Error>()
    let prevPage = PassthroughSubject<Void, Error>()
    let detailPage = PassthroughSubject<Character, Error>()

    
    // MARK: - Public methods -
    func initData() {
        NetworkApi.shared.getAllCharacters { [weak self] allCharacters in
            self?.characters = allCharacters.results
            self?.model = allCharacters
            self?.nextPage.send()
        }
    }
    
    func nextPageDataByAPI() {
        NetworkApi.shared.pages(url: (model?.info?.next ?? "")) { [weak self] allCharacters in
            self?.characters = allCharacters.results
            self?.model = allCharacters
            self?.countPage += 1
            self?.nextPage.send()
        }
    }
    
    func prevPageDagaByAPI() {
        NetworkApi.shared.pages(url: (model?.info?.prev ?? "")) { [weak self] allCharacters in
            self?.characters = allCharacters.results
            self?.model = allCharacters
            self?.countPage -= 1
            self?.prevPage.send()
        }
    }
    
    func get(index: Int) {
        NetworkApi.shared.getCharacter(id: model?.results[index].id ?? 1) { [weak self] character in
            self?.detailPage.send(character)
        }
    }
}
