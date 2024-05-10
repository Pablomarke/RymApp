//
//  EpisodesViewController.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 11/8/23.
//

import UIKit
import Combine

final class EpisodesViewController: BaseViewController {
    //MARK: - IBOutlets -
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var episodeTable: UITableView!
    @IBOutlet weak var tabBarEpisode: UITabBar!
    @IBOutlet weak var buttonSeason: UIButton!
    @IBOutlet weak var seasonMenu: UIMenu!
    
    // MARK: - Properties -
    var viewModel: EpisodesViewModel
    
    init(viewModel: EpisodesViewModel) {
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
        createMenu()
        createEpisodeTable()
        viewStyle()
        createTabBar(tabBar: tabBarEpisode)
        buttonStyle()
        viewModel.initDataView()
        responseViewModel()
    }
}

private extension EpisodesViewController {
    func responseViewModel() {
        viewModel.reloadData.sink { _ in
            self.episodeTable.reloadData()
        }.store(in: &cancellables)
    }
    
    func viewStyle() {
        backImage.image = LocalImages.locationEpisodeImage
        self.navigationController?.navigationBar.tintColor = Color.secondColor
        navigationItem.title = "Episodes"
        let textAttributes = [NSAttributedString.Key.foregroundColor: Color.secondColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        self.view.backgroundColor = Color.mainColor
    }
    
    func createSeasons() -> [UIAction] {
        let item1 = UIAction(title: "Season 1") { [weak self] (action) in
            self?.viewModel.createItem(season: Seasons.season1)
        }
        
        let item2 = UIAction(title: "Season 2") { [weak self] (action) in
            self?.viewModel.createItem(season: Seasons.season2)
        }
        
        let item3 = UIAction(title: "Season 3") { [weak self] (action) in
            self?.viewModel.createItem(season: Seasons.season3)
        }
        
        let item4 = UIAction(title: "Season 4") { [weak self] (action) in
            self?.viewModel.createItem(season: Seasons.season4)
        }
        
        let item5 = UIAction(title: "Season 5") { [weak self] (action) in
            self?.viewModel.createItem(season: Seasons.season5)
        }
        
        return [item1, item2, item3, item4, item5]
    }
    
    func createMenu() {
        let menu = UIMenu(title: "Select Season",
                          options: .displayInline,
                          children: createSeasons())
        
        buttonSeason.menu = menu
        buttonSeason.showsMenuAsPrimaryAction = true
    }
    
    func createEpisodeTable() {
        episodeTable.dataSource = self
        episodeTable.delegate = self
        episodeTable.register(UINib(nibName: TableViewCell.identifier,
                                    bundle: nil), forCellReuseIdentifier: TableViewCell.identifier)
        episodeTable.backgroundColor = .clear
    }
    
    func buttonStyle(){
        buttonSeason.backgroundColor = Color.secondColor
        buttonSeason.layer.cornerRadius = 24
    }
}

// MARK: - Extension Data Source -
extension EpisodesViewController: UITableViewDataSource,
                                  UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = episodeTable.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.syncEpisodeWithCell(model: viewModel.model[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        NetworkApi.shared.getEpisode(url: (viewModel.model[indexPath.row].url)) { [weak self] episode in
            let detail = EpisodeDetailViewController(episode)
            self?.navigationController?.show(detail,
                                             sender: nil)
        }
    }
}
