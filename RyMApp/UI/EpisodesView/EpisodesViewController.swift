//
//  EpisodesViewController.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 11/8/23.
//

import UIKit

final class EpisodesViewController: BaseViewController {
    //MARK: - IBOutlets -
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var episodeTable: UITableView!
    @IBOutlet weak var tabBarEpisode: UITabBar!
    @IBOutlet weak var buttonSeason: UIButton!
    @IBOutlet weak var seasonMenu: UIMenu!
    
    // MARK: - Properties -
    var model: Episodes
    
    // MARK: - Init -
    init(_ model: Episodes) {
        self.model = model
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
    }
}

private extension EpisodesViewController {
    func viewStyle() {
        backImage.image = LocalImages.locationEpisodeImage
        self.navigationController?.navigationBar.tintColor = Color.secondColor
        navigationItem.title = "Episodes"
        let textAttributes = [NSAttributedString.Key.foregroundColor: Color.secondColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
        self.view.backgroundColor = Color.mainColor
    }
    
    func createMenu() {
        let item1 = UIAction(title: "Season 1") { (action) in
            NetworkApi.shared.getArrayEpisodes(season: "1,2,3,4,5,6,7,8,9,10,11") { episodes in
                self.model = episodes
                self.episodeTable.reloadData()
            }
        }
        let item2 = UIAction(title: "Season 2") { (action) in
            NetworkApi.shared.getArrayEpisodes(season: "12,13,14,15,16,17,18,19,20,21") { episodes in
                self.model = episodes
                self.episodeTable.reloadData()
            }
        }
        let item3 = UIAction(title: "Season 3") { (action) in
            
            NetworkApi.shared.getArrayEpisodes(season: "22,23,24,25,26,27,28,29,30,31") { episodes in
                self.model = episodes
                self.episodeTable.reloadData()
            }
        }
        let item4 = UIAction(title: "Season 4") { (action) in
            NetworkApi.shared.getArrayEpisodes(season: "32,33,34,35,36,37,38,39,40,41") { episodes in
                self.model = episodes
                self.episodeTable.reloadData()
            }
        }
        let item5 = UIAction(title: "Season 5") { (action) in
            NetworkApi.shared.getArrayEpisodes(season: "42,43,44,45,46,47,48,49,50,51") { episodes in
                self.model = episodes
                self.episodeTable.reloadData()
            }
        }
        let menu = UIMenu(title: "Select Season",
                          options: .displayInline,
                          children: [item1, item2, item3, item4, item5])
        
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
        return model.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = episodeTable.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.syncEpisodeWithCell(model: model[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        NetworkApi.shared.getEpisode(url: (model[indexPath.row].url)) { [weak self] episode in
            let detail = EpisodeDetailViewController(episode)
            self?.navigationController?.show(detail,
                                             sender: nil)
        }
    }
}
