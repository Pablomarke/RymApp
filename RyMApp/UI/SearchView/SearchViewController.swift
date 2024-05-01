//
//  SearchViewController.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 8/8/23.
//

import UIKit

final class SearchViewController: BaseViewController {
    //MARK: - IBOutlets -
    @IBOutlet weak var tabBarSearch: UITabBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var searchCollection: UICollectionView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var buttonView: UIView!
    
    // MARK: - Properties -
    var model: Characters = []
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        viewStyle()
        searchTextStyle()
        createButtonStyle()
        createTabBar(tabBar: tabBarSearch)
        createSearchCollection()
    }
    
    // MARK: - Buttons -
    @IBAction func searchAction(_ sender: Any) {
        searchCharacters()
    }
}

private extension SearchViewController {
    func viewStyle() {
        self.navigationController?.navigationBar.barTintColor = Color.mainColor
        self.view.backgroundColor = Color.mainColor
        self.navigationController?.navigationBar.tintColor = Color.secondColor
        navigationItem.title = "Character finder"
        let textAttributes = [NSAttributedString.Key.foregroundColor: Color.secondColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        backImage.image = LocalImages.searchImage
        backImage.contentMode = .scaleAspectFill
    }
    
    func searchTextStyle() {
        searchText.placeholder = "Enter a name"
        searchText.layer.cornerRadius = 40
        searchText.backgroundColor = Color.secondColor
    }
    
    func createButtonStyle() {
        buttonView.backgroundColor = Color.secondColor
        buttonView.layer.cornerRadius = 24
        searchButton.setTitle("Search",
                              for: .normal)
        searchButton.tintColor = .black
    }
    
    func createSearchCollection() {
        searchCollection.clearBackground()
        searchCollection.dataSource = self
        searchCollection.delegate = self
        searchCollection.register(UINib(nibName: CharacterCell.identifier,
                                        bundle: nil),
                                  forCellWithReuseIdentifier: CharacterCell.identifier)
        searchCollection.isHidden = true
    }
    
    func searchCharacters() {
        let newName = searchText.text
        if newName == "" {
            searchText.placeholder = "Please, enter a name"
        } else {
            NetworkApi.shared.searchCharacters(name: newName!) { characters in
                self.model = characters.results
                self.searchText.backgroundColor = Color.secondColor
                self.searchCollection.isHidden = false
                self.searchCollection.reloadData()
            }
        }
    }
}

// MARK: - Extension de datasource -
extension SearchViewController: UICollectionViewDataSource,
                                UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = searchCollection.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier,
                                                              for: indexPath) as? CharacterCell else {
            return UICollectionViewCell()
        }
        
        let modelForCell = model[indexPath.row]
        cell.syncCellWithModel(model: modelForCell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let myID = model[indexPath.row].id
        NetworkApi.shared.getCharacter(id: myID ) { [weak self] character in
            let detailedView = DetailViewController(viewModel: CharacterDetailViewModel(model: character))
            self?.navigationController?.showDetailViewController(detailedView,
                                                                 sender: nil)
        }
    }
}
