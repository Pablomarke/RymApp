//
//  LocationDetailViewController.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 15/8/23.
//

import UIKit
import Kingfisher

class LocationDetailViewController: UIViewController {
    //MARK: - IBOutlets -
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var dimensionLabel: UILabel!
    @IBOutlet weak var residentsLabel: UILabel!
    @IBOutlet weak var residentsCollection: UICollectionView!
    
    // MARK: - Propiedades -
    var model: Location
    
    // MARK: - Init -
    init(_ model: Location) {
        self.model = model
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Ciclo de vida -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "dark")
        backImage.image = UIImage(named: "w10")
        backImage.contentMode = .scaleToFill
        
        topView.backgroundColor = .clear
        nameLabel.font = UIFont(name: "Get Schwifty Regular",
                                size: 24)
        nameLabel.textColor = UIColor(named: "rickHair")
        nameLabel.numberOfLines = 2
        nameLabel.text = model.name
        typeLabel.text = model.type
        typeLabel.textColor = UIColor(named: "rickHair")
        typeLabel.numberOfLines = 2
        dimensionLabel.text = model.dimension
        dimensionLabel.textColor = UIColor(named: "rickHair")
        dimensionLabel.numberOfLines = 2
        
        if model.residents.count != 0 {
            residentsLabel.text = "Residentes"
        } else {
            residentsLabel.text = "No hay residentes"
        }
        
        residentsLabel.textColor = UIColor(named: "rickHair")
        residentsCollection.backgroundColor = .clear
       
        residentsCollection.dataSource = self
        residentsCollection.delegate = self
        residentsCollection.register(UINib(nibName: "CharacterCell", bundle: nil),
                                     forCellWithReuseIdentifier: "RC")
    }
}

// MARK: - Extension de datasource -
extension LocationDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return model.residents.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = residentsCollection.dequeueReusableCell(withReuseIdentifier: "RC",
                                                           for: indexPath) as! CharacterCell
        NetworkApi.shared.getCharacterUrl(url: model.residents[indexPath.row]) { character in
            cell.characterName.text = character.name
            let urlImage = URL(string: character.image)
            cell.CharacterView.kf.setImage(with: urlImage)
            cell.characterStatus.text = character.status
            cell.statusView.backgroundColor = character.statusColor()
        }
        return cell
    }
}

extension LocationDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NetworkApi.shared.getCharacterUrl(url: model.residents[indexPath.row]) { character in
            let detailView = DetailViewController(model: character)
            self.navigationController?.showDetailViewController(detailView,
                                                                sender: nil)
        }
    }
}
