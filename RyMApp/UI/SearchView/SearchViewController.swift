//
//  SearchViewController.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 8/8/23.
//

import UIKit
import Combine

final class SearchViewController: BaseViewController {
    //MARK: - IBOutlets -
    @IBOutlet weak var tabBarSearch: UITabBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchText: UITextField!
    @IBOutlet weak var searchCollection: UICollectionView!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var buttonView: UIView!
    
    // MARK: - Properties -
    var viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        responseViewModel()
        viewStyle()
        searchTextStyle()
        createButtonStyle()
        createTabBar(tabBar: tabBarSearch)
        createSearchCollection()
    }
    
    // MARK: - Buttons -
    @IBAction func searchAction(_ sender: Any) {
        searchText.text == ""
        ? searchText.placeholder = "Please, enter a name"
        : viewModel.searchCharacters(name: searchText.text ?? "000000")
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
    
    func responseViewModel() {
        viewModel.reloadCharacters.sink { _ in
            self.searchText.backgroundColor = Color.secondColor
            self.searchCollection.isHidden = false
            self.searchCollection.reloadData()
        }.store(in: &cancellables)
    }
    
}

// MARK: - Extension de datasource -
extension SearchViewController: UICollectionViewDataSource,
                                UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.model.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = searchCollection.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier,
                                                              for: indexPath) as? CharacterCell else {
            return UICollectionViewCell()
        }
        
        let modelForCell = viewModel.model[indexPath.row]
        cell.syncCellWithModel(model: modelForCell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let myID = viewModel.model[indexPath.row].id
        NetworkApi.shared.getCharacter(id: myID ) { [weak self] character in
            let detailedView = DetailViewController(viewModel: CharacterDetailViewModel(model: character))
            self?.navigationController?.showDetailViewController(detailedView,
                                                                 sender: nil)
        }
    }
}
