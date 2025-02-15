//
//  CharacterCell.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 4/8/23.
//

import UIKit
import Kingfisher

final class CharacterCell: UICollectionViewCell {
    //MARK: - IBOutlets -
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var CharacterView: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var characterStatus: UILabel!
    
    // MARK: - Properties -
    static let identifier: String = "CharacterCell"
    
    // MARK: - Methods -
    override func awakeFromNib() {
        super.awakeFromNib()
        cellStyle()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        characterName.text = nil
        characterStatus.text = nil
        statusView.backgroundColor = nil
    }
    
    func syncCellWithModel(model: Character) {
        characterName.text = model.name
        characterStatus.text = model.status
        let urlImage = URL(string: model.image)
        CharacterView.kf.setImage(with: urlImage)
        statusView.backgroundColor = model.statusColor()
    }
}

private extension CharacterCell {
    func cellStyle(){
        backView.backgroundColor = Color.mainColor
        characterName.numberOfLines = 2
        characterName.textColor = .white
        backView.layer.cornerRadius = 16
        characterStatus.textColor = .black
        CharacterView.layer.cornerRadius = 40
        statusView.layer.cornerRadius = 8
    }
}
