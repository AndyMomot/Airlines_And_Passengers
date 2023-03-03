//
//  AirlinesVC.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 14.9.22.
//

import UIKit

class AirlinesVC: UIViewController {
    
    // MARK: Constants -
    enum Constants {
        static let heightForSafeAreaLayoutGuide: CGFloat = 60
        static let DarkGrayColor = #colorLiteral(red: 0.1599952579, green: 0.1600029767, blue: 0.1599760652, alpha: 1)
        static let BlackColor = #colorLiteral(red: 0.0500000082, green: 0.0500000082, blue: 0.0500000082, alpha: 1)
    }
    
    // MARK: Properties -
    private let searchController = UISearchController(searchResultsController: nil)
    private var timer: Timer?
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    private let tableView = UITableView()
    private var airlinesData = [AirlinesDataModelElement]()
    private var filteredAirlinesData = [AirlinesDataModelElement]()
    
    private let refreshControl = UIRefreshControl()

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        getAllAvialines()
        tableViewSettings()
        setupSearchController()
    }
    
    override func viewDidLayoutSubviews() {
        setUI()
    }
}

// MARK: Networking
private extension AirlinesVC {
    // MARK: POST -
    func postAirline(model: AirlinePost) {
        let airline = AirlinePost(id: model.id, name: model.name, country: model.country,
                                  logo: model.logo, slogan: model.slogan, headQuaters: model.headQuaters,
                                  website: model.website, established: model.established)
        DispatchQueue.main.async {
            DataManager.instance.saveNewAirline(model: airline) {
                DispatchQueue.main.async {
                    self.getAllAvialines()
                }
                print("CREATED NEW AIRLINE")
            }
        }
    }
    
    // MARK: GET ALL -
    func getAllAvialines() {
        DispatchQueue.main.async {
            DataManager.instance.requestAllAirlines { [weak self] airlines in
                guard let self = self else { return }
                guard let airlines = airlines else {
                    print("Failed to download airline data")
                    return
                }
                self.airlinesData = airlines
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                    self.tableView.alpha = 1
                }
            }
        }
    }
    
    // MARK: GET SOME
    func getSomeAirline(id: Int) {
        DispatchQueue.main.async {
            DataManager.instance.requestSomeAirline(id: id) { [weak self] airlines in
                guard let self = self else { return }
                guard let airlines = airlines else {
                    print("Failed to download airline data")
                    return
                }
                
                self.airlinesData = airlines
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                    self.tableView.alpha = 1
                }
            }
        }
    }
}

// MARK: Private Extension
private extension AirlinesVC {
    // MARK: Constraints -
    func setConstraints() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // table View
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    // MARK: Setup Search Controller -
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    // MARK: Setup UI -
    func setUI() {
        setupSelfView()
        setupSearchBar()
        setRefreshControl()
    }
    
    // MARK: Setup Self view -
    func setupSelfView() {
        self.view.backgroundColor = Constants.BlackColor
        self.navigationController?.navigationBar.tintColor = Constants.BlackColor
        self.view.isUserInteractionEnabled = true
        self.title = "Airlines"
        
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationController?.navigationBar.barTintColor = Constants.BlackColor
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
    // MARK: Setup Search Bar view -
    func setupSearchBar() {
        let searchBar = searchController.searchBar
        searchBar.placeholder = "Search..."
        searchBar.setPlaceholderColor(.white)
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.tintColor = .white
        searchBar.setIconColor(.white)
        searchBar.barTintColor = .clear
        searchBar.setButtonColor(.white)
                
        let appearance = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        appearance.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
    }
    
    // MARK: Setup Refresh Control -
    func setRefreshControl() {
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(refreshAction), for: .valueChanged)
    }
    
    // MARK: Refresh action
    @objc func refreshAction() {
        print("start Refreshing")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.getAllAvialines()
        }
        self.tableView.alpha = 0.3
    }
}

// MARK: Data Source -
extension AirlinesVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableViewSettings() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AirlineCell.self)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.addSubview(refreshControl)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredAirlinesData.count
        } else {
            return airlinesData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AirlineCell = tableView.dequeueReusableCell(for: indexPath)
        let airline: AirlinesDataModelElement
        
        if isFiltering {
            airline = filteredAirlinesData[indexPath.row]
        } else {
            airline = airlinesData[indexPath.row]
        }
        
        let viewModel = AirlineCellModel(name: airline.name, slogan: airline.slogan, imageURL: airline.logo)
        
        cell.config(viewModel: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 163
    }
}

// MARK: Search Results Updating -
extension AirlinesVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(by: searchController.searchBar.text!)
    }
    
    private func filterContent(by searchText: String) {
        struct DelayedSearchTask {
            static var delayedTask: DispatchWorkItem?
        }
        DelayedSearchTask.delayedTask?.cancel()
        
        if !isFiltering {
            self.filteredAirlinesData.removeAll()
            tableView.reloadData()
            return
        }
        
        DelayedSearchTask.delayedTask = DispatchWorkItem {
            self.filteredAirlinesData = self.airlinesData.filter({ (passenger: AirlinesDataModelElement) -> Bool in
                return (passenger.name?.lowercased().contains(searchText.lowercased())) ?? false
            })
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
            }
        }
        
        guard let delayedTask = DelayedSearchTask.delayedTask else { return }
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: delayedTask)
        
    }
}
