//
//  DetailViewController.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 27/7/23.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {

    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var colorCharacter: UIView!
    @IBOutlet weak var colorStatus: UIView!
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
   
    var model: Character
    
    init(model: Character) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        syncModel()
        backImage.image = UIImage(named: "w3")
        backImage.contentMode = .scaleToFill
        
        imageDetail.layer.cornerRadius = 90
        colorCharacter.layer.cornerRadius = 90
        colorStatus.layer.cornerRadius = 20
        
        
        nameLabel.font = UIFont(name: "Get Schwifty Regular", size: 36)
        nameLabel.textColor = UIColor(named: "rickHair")
        speciesLabel.textColor = UIColor(named: "rickHair")
        speciesLabel.font = UIFont(name: "Get Schwifty Regular", size: 24)
        typeLabel.textColor = UIColor(named: "rickHair")
        typeLabel.font = UIFont(name: "Get Schwifty Regular", size: 24)
        genderLabel.textColor = UIColor(named: "rickHair")
        genderLabel.font = UIFont(name: "Get Schwifty Regular", size: 24)
        createdLabel.textColor = UIColor(named: "rickHair")
        createdLabel.font = UIFont(name: "Get Schwifty Regular", size: 24)
        
        
        
    }
    
    func syncModel() {
        self.view.backgroundColor = UIColor(named: "dark")
        
        nameLabel.text = model.name
        statusLabel.text = model.status
        
        speciesLabel.text = model.species
        typeLabel.text = model.type
        genderLabel.text = model.gender
        createdLabel.text = dateToString(date: model.created)
        
        let imageUrl = model.image
        imageDetail.kf.setImage(with: URL(string: imageUrl))
        
        if model.status == "Alive" {
            colorStatus.backgroundColor = .green
            colorCharacter.backgroundColor = .green
        } else if model.status == "Dead" {
            colorStatus.backgroundColor = .red
            colorCharacter.backgroundColor = .red
        } else if model.status == "unknown" {
            colorStatus.backgroundColor = .gray
            colorCharacter.backgroundColor = .gray
        }
    }
    
    func dateToString(date: Date) -> String {
        let myDate = DateFormatter()
        myDate.dateStyle = .short
        let newDate = myDate.string(from: date)
        return newDate
    }
}
