//
//  TableViewCell.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 9/8/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    //MARK: - IBOutlets -
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var dataView: UIView!
    
    static let identifier: String = "TableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellStyle()
    }
    
    // MARK: - Methods -
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        dataLabel.text = nil
    }
    
    func syncEpisodeWithCell(model: Episode) {
        titleLabel.text = model.episode
        dataLabel.text = model.name
    }
    
    func syncLocationWithCell(model: Location){
        titleLabel.text = model.type
        dataLabel.text = model.name
    }
}

private extension TableViewCell {
    func cellStyle(){
        contentView.backgroundColor = Color.clearColor
        self.backgroundColor = .clear
        titleLabel.textColor = .black
        dataLabel.textColor = Color.mainColor
        titleView.cornerToTableView()
        dataView.cornerToTableView()
    }
}
