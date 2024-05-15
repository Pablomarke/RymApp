//
//  CharactersViewController.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 28/7/23.
//

import UIKit
import Combine

final class CharactersViewController: BaseViewController {
    //MARK: - IBOutlets -
    @IBOutlet weak var characterBar: UITabBar!
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var collectionCharacters: UICollectionView!
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var pagesLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK: - Properties -
    var viewModel: CharactersViewModel
    
    init(viewModel: CharactersViewModel) {
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
        viewStyle(title: "Characters")
        anotherViewStyle()
        collectionStyle()
        pagesStyle()
        createTabBar(tabBar: characterBar)
        viewModel.initData()
        responseViewModel()
    }
    
    // MARK: - Buttons -
    @IBAction func nextButtonAction(_ sender: Any) {
        viewModel.nextPageDataByAPI()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        viewModel.prevPageDagaByAPI()
    }
}

private extension CharactersViewController {
    func responseViewModel() {
        viewModel.nextPage.sink { error in
            print(error)
        } receiveValue: { [weak self] _ in
            self?.nextPage()
        }.store(in: &cancellables)
        
        viewModel.prevPage.sink { error in
            print(error)
        } receiveValue: { [weak self] _ in
            self?.prevPage()
        }.store(in: &cancellables)
        
        viewModel.detailPage.sink { error in
            print(error)
        } receiveValue: { [weak self] character in
            self?.navigateToDetail(character: character)
        }.store(in: &cancellables)
    }
    
    func nextPage() {
        self.showBackButton()
        self.collectionCharacters.reloadData()
    }
    
    func prevPage() {
        self.showPrevButton()
        self.collectionCharacters.reloadData()
    }
    
    func anotherViewStyle() {
        backImage.image = LocalImages.charactersImage
        backImage.contentMode = .scaleToFill
    }
    
    func collectionStyle() {
        collectionCharacters.dataSource = self
        collectionCharacters.delegate = self
        collectionCharacters.rymCollectionStyle(cellIdentifier: CharacterCell.identifier)
    }
    
    func pagesStyle() {
        pageView.backgroundColor = .clear
        pagesLabel.text = "\(viewModel.countPage) / \(viewModel.model?.info?.pages  ?? 1)"
        pagesLabel.textColor = Color.secondColor
        pagesLabel.font = Font.size24
        backButton.isHidden = true
    }
    
    func showBackButton() {
        self.pagesLabel.text = "\(viewModel.countPage) / \(viewModel.model?.info?.pages ?? 1)"
        self.backButton.isHidden = viewModel.countPage == 1
        if viewModel.model?.info?.next == nil {
            self.nextButton.isHidden = true
        }
    }
    
    func showPrevButton() {
        self.pagesLabel.text = "\(viewModel.countPage) / \(viewModel.model?.info?.pages ?? 1)"
        self.nextButton.isHidden = viewModel.countPage == viewModel.model?.info?.pages
        if viewModel.model?.info?.prev == nil {
            self.backButton.isHidden = true
        }
    }
    
    func navigateToDetail(character: Character) {
        let detailedView = DetailViewController(viewModel: CharacterDetailViewModel(model: character))
        self.navigationController?.show(detailedView,
                                        sender: nil)
    }
}

// MARK: - Extension de datasource -
extension CharactersViewController: UICollectionViewDataSource,
                                    UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionCharacters.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier,
                                                                  for: indexPath) as? CharacterCell else {
            return UICollectionViewCell()
        }
        
        let cellModel = viewModel.characters[indexPath.row]
        cell.syncCellWithModel(model: cellModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel.get(index: indexPath.row)
    }
}
