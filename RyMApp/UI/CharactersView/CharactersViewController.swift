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

    var viewModel: CharactersViewModel
    var cancellables = Set<AnyCancellable>()

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
        viewStyle()
        collectionStyle()
        pagesStyle()
        createTabBar(tabBar: characterBar)
        responseViewModel()
    }
    
    // MARK: - methods -
   
    
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
    
    func viewStyle() {
        backImage.image = LocalImages.charactersImage
        backImage.contentMode = .scaleToFill
        self.view.backgroundColor = Color.mainColor
        self.navigationController?.navigationBar.tintColor = Color.secondColor
        navigationItem.title = "Characters"
        let textAttributes = [NSAttributedString.Key.foregroundColor: Color.secondColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
    }
    
    func collectionStyle() {
        collectionCharacters.clearBackground()
        collectionCharacters.dataSource = self
        collectionCharacters.delegate = self
        collectionCharacters.register(UINib( nibName: CharacterCell.identifier,
                                             bundle: nil),
                                      forCellWithReuseIdentifier: CharacterCell.identifier)
    }
    
    func pagesStyle() {
        pageView.backgroundColor = .clear
        pagesLabel.text = "\(viewModel.countPage) / \(viewModel.model.info?.pages  ?? 1)"
        pagesLabel.textColor = Color.secondColor
        pagesLabel.font = Font.size24
        
        if viewModel.model.info?.prev == nil || viewModel.model.info?.next == nil {
            backButton.isHidden = true
        }
    }
   
    func showBackButton() {
        self.pagesLabel.text = "\(viewModel.countPage) / \(viewModel.model.info?.pages ?? 1)"
        self.backButton.isHidden = false
        if viewModel.model.info?.next == nil {
            self.nextButton.isHidden = true
        }
    }
    
    func showPrevButton() {
        self.pagesLabel.text = "\(viewModel.countPage) / \(viewModel.model.info?.pages ?? 1)"
        self.nextButton.isHidden = false
        if viewModel.model.info?.prev == nil {
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
        return viewModel.model.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionCharacters.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier,
                                                                  for: indexPath) as? CharacterCell else {
            return UICollectionViewCell()
        }
        
        if let cellModel = viewModel.model.results?[indexPath.row] {
            cell.syncCellWithModel(model: cellModel)
        } 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        viewModel.get(index: indexPath.row)
    }
}
