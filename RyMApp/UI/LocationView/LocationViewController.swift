//
//  LocationViewController.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 13/8/23.
//

import UIKit

final class LocationViewController: BaseViewController {
    //MARK: - IBOutlets -
    @IBOutlet weak var locationTable: UITableView!
    @IBOutlet weak var locationTabBar: UITabBar!
    @IBOutlet weak var backImage: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pagesView: UIView!
    @IBOutlet weak var pageLabel: UILabel!
    
    // MARK: - Properties -
    var model: AllLocations
    var pageCount = 1
    
    // MARK: - Init -
    init(_ model: AllLocations) {
        self.model = model
        super.init(
            nibName: nil,
            bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTableStyle()
        navigationBarStyle()
        viewStyle()
        pagesViewStyle()
        createTabBar(tabBar: locationTabBar)
    }

    // MARK: - Buttons -
    @IBAction func nextBAct(_ sender: Any) {
        nextPage()
    }
    
    @IBAction func backBAct(_ sender: Any) {
        prevPage()
    }
}

private extension LocationViewController {
    func viewStyle() {
        self.view.backgroundColor = Color.mainColor
        backImage.image = LocalImages.locationEpisodeImage
    }
    
    func pagesViewStyle() {
        pagesView.backgroundColor = .clear
        pageLabel.text = "\(pageCount) / \(model.info.pages)"
        pageLabel.textColor = Color.secondColor
        pageLabel.font = Font.size24
        if model.info.prev == nil {
            backButton.isHidden = true
        }
    }
    
    func navigationBarStyle() {
        self.navigationController?.navigationBar.tintColor = Color.secondColor
        navigationItem.title = "Locations"
        let textAttributes = [NSAttributedString.Key.foregroundColor: Color.secondColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
    }
    
    func locationTableStyle() {
        locationTable.dataSource = self
        locationTable.delegate = self
        locationTable.register(UINib(nibName: TableViewCell.identifier,
                                     bundle: nil),
                               forCellReuseIdentifier: TableViewCell.identifier)
        locationTable.backgroundColor = .clear
    }
    
    func nextPage() {
        NetworkApi.shared.pagesLocation(url: (model.info.next)! ) { [weak self] AllLocations in
            self?.model = AllLocations
            self?.locationTable.reloadData()
            self?.pageCount += 1
            self?.pageLabel.text = "\(self?.pageCount) / \(self?.model.info.pages )"
            self?.backButton.isHidden = false
            if self?.model.info.next == nil {
                self?.nextButton.isHidden = true
            }
        }
    }
    
    func prevPage() {
        NetworkApi.shared.pagesLocation(url: (model.info.prev)!) { [weak self] AllLocations in
            self?.model = AllLocations
            self?.locationTable.reloadData()
            self?.pageCount -= 1
            self?.pageLabel.text = "\(self?.pageCount) / \(self?.model.info.pages)"
            self?.nextButton.isHidden = false
            if self?.model.info.prev == nil {
                
                self?.backButton.isHidden = true
            }
        }
    }
}

    // MARK: - Extension datasource -
extension LocationViewController: UITableViewDataSource,
                                  UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return model.results.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.syncLocationWithCell(model: model.results[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        NetworkApi.shared.getLocationUrl(url: (model.results[indexPath.row].url)) { [weak self] locations in
         let detail = LocationDetailViewController(locations)
         self?.navigationController?.show(detail,
                                          sender: nil)
         }
    }
}
