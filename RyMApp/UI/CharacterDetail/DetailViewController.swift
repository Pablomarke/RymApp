//
//  DetailViewController.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 27/7/23.
//

import UIKit
import Combine

final class DetailViewController: BaseViewController {
    
    //MARK: - IBOutlets -
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageDetail: UIImageView!
    @IBOutlet weak var colorCharacter: UIView!
    @IBOutlet weak var colorStatus: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var episodeTable: UITableView!
    @IBOutlet weak var speciesView: UIView!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var originView: UIView!
    @IBOutlet weak var tSpeciesView: UIView!
    @IBOutlet weak var tSpeciesLabel: UILabel!
    @IBOutlet weak var tTypeView: UIView!
    @IBOutlet weak var tTypeLabel: UILabel!
    @IBOutlet weak var tGendeView: UIView!
    @IBOutlet weak var tGenderLabel: UILabel!
    @IBOutlet weak var tLocationView: UIView!
    @IBOutlet weak var tLocationLabel: UILabel!
    @IBOutlet weak var tOriginaView: UIView!
    @IBOutlet weak var tOriginLabel: UILabel!
    
    // MARK: - Properties -
    var viewModel: CharacterDetailViewModel
    
    // MARK: - Init -
    init(viewModel: CharacterDetailViewModel) {
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
        viewModel.initViewAndChargeData()
        responseViewModel()
        createTableAndStyle()
        createViewsforData()
        viewStyle()
    }
}

private extension DetailViewController {
    func responseViewModel() {
        viewModel.episode
            .sink { error in
                print(error)
            } receiveValue: { [weak self] _ in
                self?.episodeTable.reloadData()
                self?.syncCharacterModelwithView()
            }
            .store(in: &cancellables)
    }
    
    func viewStyle() {
        backImage.image = LocalImages.detailImage
        backImage.contentMode = .scaleToFill
        imageDetail.cornerToImagedetailViews()
        colorCharacter.cornerToImagedetailViews()
        colorStatus.cornerToImagedetailViews(corner: 20)
        nameLabel.font = Font.size36
        nameLabel.textColor = Color.secondColor
    }
    
    func syncCharacterModelwithView() {
        var model = viewModel.model
        nameLabel.text = model.name
        statusLabel.text = model.status
        genderLabel.text = model.gender
        locationNameLabel.text = model.location.name
        originLabel.text = model.origin.name
        speciesLabel.text = model.species
        typeLabel.text = model.typeForVoidString()
        colorStatus.backgroundColor = model.statusColor()
        colorCharacter.backgroundColor = model.statusColor()
        imageDetail.kf.setImage(with: URL(string: model.image))
    }
    
    func createTableAndStyle() {
        episodeTable.dataSource = self
        episodeTable.delegate = self
        episodeTable.createTable(cellIdentifier: TableViewCell.identifier)
    }
    
    func createViewsforData() {
        createViewForData(label: speciesLabel,
                          view: speciesView,
                          view2: tSpeciesView,
                          title: "Specie")
        
        createViewForData(label: typeLabel,
                          view: typeView,
                          view2: tTypeView,
                          title: "Type")
        
        createViewForData(label: genderLabel,
                          view: genderView,
                          view2: tGendeView,
                          title: "Gender")
        
        createViewForData(label: locationNameLabel,
                          view: locationView,
                          view2: tLocationView,
                          title: "Location")
        
        createViewForData(label: originLabel,
                          view: originView,
                          view2: tOriginaView,
                          title: "Origin")
    }
}
// MARK: - Extension de datasource -
extension DetailViewController: UITableViewDataSource,
                                UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.episode.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detailCell = episodeTable.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
            return UITableViewCell()
        }
        
        let episode = viewModel.episodes[indexPath.row]
        detailCell.syncEpisodeWithCell(model: episode)
        return detailCell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let episode = viewModel.episodes[indexPath.row]
        let episodeNav = EpisodeDetailViewController(episode)
        self.navigationController?.showDetailViewController(episodeNav,
                                                            sender: nil)
    }
}
