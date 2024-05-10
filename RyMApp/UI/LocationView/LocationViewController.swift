//
//  LocationViewController.swift
//  RyMApp
//
//  Created by Pablo Márquez Marín on 13/8/23.
//

import UIKit
import Combine

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
    private var viewModel: LocationViewModel
    
    init(viewModel: LocationViewModel) {
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
        viewModel.initViewAndData()
        responseViewModel()
        locationTableStyle()
        navigationBarStyle()
        viewStyle()
        pagesViewStyle()
        createTabBar(tabBar: locationTabBar)
    }

    // MARK: - Buttons -
    @IBAction func nextBAct(_ sender: Any) {
        viewModel.nextPage()
    }
    
    @IBAction func backBAct(_ sender: Any) {
        viewModel.prevPage()
    }
}

private extension LocationViewController {
    func responseViewModel() {
        viewModel.otherPage.sink { error in
            print(error)
        } receiveValue: { [weak self] _ in
            self?.pageLabel.text = "\(self?.viewModel.pageCount) / \(self?.viewModel.locations?.info.pages )"
            self?.locationTable.reloadData()
            self?.buttonsViews()
        }.store(in: &cancellables)
    }
    
    func viewStyle() {
        self.view.backgroundColor = Color.mainColor
        backImage.image = LocalImages.locationEpisodeImage
    }
    
    func pagesViewStyle() {
        pagesView.backgroundColor = .clear
        pageLabel.text = "\(self.viewModel.pageCount) / \(self.viewModel.locations?.info.pages)"
        pageLabel.textColor = Color.secondColor
        pageLabel.font = Font.size24
        if viewModel.locations?.info.prev == nil {
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
    
    func buttonsViews() {
        self.nextButton.isHidden = false
        self.backButton.isHidden = false
        if viewModel.locations?.info.next == nil {
            self.nextButton.isHidden = true
        }
        if viewModel.locations?.info.prev == nil {
            self.backButton.isHidden = true
        }
    }
}

    // MARK: - Extension datasource -
extension LocationViewController: UITableViewDataSource,
                                  UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier) as? TableViewCell else {
            return UITableViewCell()
        }
        
        cell.syncLocationWithCell(model: viewModel.model[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        NetworkApi.shared.getLocationUrl(url: (viewModel.model[indexPath.row].url)) { [weak self] location in
            let viewModel = LocationDetailViewModel(location)
            let detail = LocationDetailViewController(viewModel: viewModel)
         self?.navigationController?.show(detail,
                                          sender: nil)
         }
    }
}
