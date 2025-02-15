//
//  EpisodeDetailViewController.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 12/8/23.
//

import UIKit

final class EpisodeDetailViewController: BaseViewController {
    //MARK: - IBOutlets -
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var estrenoLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var collectionCharacters: UICollectionView!
    
    // MARK: - Properties -
    var model: Episode
    
    // MARK: - Init -
    init(_ model: Episode) {
        self.model = model
        super.init(
            nibName: nil,
            bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        syncModelWithView()
        createCollectionCharacter()
        viewStyle()
    }
}

private extension EpisodeDetailViewController {
    func viewStyle() {
        viewStyle(title: "")
        topView.backgroundColor = Color.secondColor
        topView.layer.cornerRadius = 22
        characterLabel.text = "Characters"
        characterLabel.textColor = Color.secondColor
        backImage.image = LocalImages.episodeDetailImage
        backImage.contentMode = .scaleToFill
        topView.backgroundColor = .clear
        nameLabel.font = Font.size24
        nameLabel.textColor = Color.secondColor
        nameLabel.numberOfLines = 2
    }
    
    func syncModelWithView(){
        nameLabel.text = model.name
        episodeLabel.text = model.episode
        estrenoLabel.text = model.air_date
    }
    
    func createCollectionCharacter(){
        collectionCharacters.dataSource = self
        collectionCharacters.delegate = self
        collectionCharacters.rymCollectionStyle(cellIdentifier: CharacterCell.identifier)
    }
}

// MARK: - Extension de datasource -
extension EpisodeDetailViewController: UICollectionViewDataSource,
                                       UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return model.characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionCharacters.dequeueReusableCell(withReuseIdentifier: CharacterCell.identifier,
                                                                  for: indexPath) as? CharacterCell else {
            return UICollectionViewCell()
        }
        
        NetworkApi.shared.getCharacterUrl(url: model.characters[indexPath.row]) { character in
            cell.syncCellWithModel(model: character)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        NetworkApi.shared.getCharacterUrl(url: model.characters[indexPath.row]) { character in
            let detailedView = DetailViewController(viewModel: CharacterDetailViewModel(model: character))
            self.navigationController?.showDetailViewController(detailedView,
                                                                sender: nil)
        }
    }
}
