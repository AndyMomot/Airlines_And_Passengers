//
//  PassengersVC.swift
//  AirlinesAndPassengers
//
//  Created by Андрей on 14.9.22.
//

import UIKit

class PassengersVC: UIViewController {
    
    // MARK: Constants -
    enum Constants {
        static let heightForSafeAreaLayoutGuide: CGFloat = 60
        static let DarkGrayColor = #colorLiteral(red: 0.1599952579, green: 0.1600029767, blue: 0.1599760652, alpha: 1)
        static let BlackColor = #colorLiteral(red: 0.0500000082, green: 0.0500000082, blue: 0.0500000082, alpha: 1)
    }
    
    // MARK: Properties -
    private let model = PassengerModel()
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
    private var passengersData = [PassengerModelElement]()
    private var filteredPassengersData = [PassengerModelElement]()
    
    private let refreshControl = UIRefreshControl()
    private var paginationOffset = 0
    private var overallPassengersCount = 0
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllPassengersData()
        setBurButtonItems()
        setConstraints()
        tableViewSettings()
        setupSearchController()
    }
    
    override func viewDidLayoutSubviews() {
        setUI()
    }
}

// MARK: Private Extension
private extension PassengersVC {
    // MARK: Get passenger at IndexPath method -
    func getAPassenger(at indexPath: IndexPath) -> PassengerModelElement {
        let passenger: PassengerModelElement
        if isFiltering {
            passenger = filteredPassengersData[indexPath.row]
        } else {
            passenger = passengersData[indexPath.row]
        }
        return passenger
    }
    
    // MARK: Constraints -
    func setConstraints() {
        // table View
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
    
    // MARK: Bur Button Items -
    func setBurButtonItems() {
        let items = ["All", "Some"]
        let segmentedController = UISegmentedControl(items: items)
        segmentedController.selectedSegmentIndex = 0
        segmentedController.addTarget(self, action: #selector(didTabSegment(_:)), for: .valueChanged)
        // Panting text for picker label
        segmentedController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)
        segmentedController.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Constants.BlackColor], for: UIControl.State.selected)
        navigationItem.titleView = segmentedController
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPassenger))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    // MARK: @objc functions for Bur Button Items
    @objc func didTabSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            getAllPassengersData()
        case 1:
            getSomePassengersData()
        default:
            break
        }
    }
    
    @objc func addNewPassenger() {
        let alertController = UIAlertController(title: "Create new Passenger", message: "Enter new values", preferredStyle: .alert)
        
        for _ in 0...2 {
            alertController.addTextField()
        }
        
        let nameTF = alertController.textFields![0]
        nameTF.placeholder = "Enter name..."
        nameTF.keyboardType = .namePhonePad
        nameTF.textContentType = .name
        nameTF.autocapitalizationType = .words
        
        let tripsTF = alertController.textFields![1]
        tripsTF.placeholder = "Enter number of trips"
        tripsTF.keyboardType = .numberPad
        
        let airlineTF = alertController.textFields![2]
        airlineTF.placeholder = "Enter number of airline"
        airlineTF.keyboardType = .numberPad
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            // Post
            if !nameTF.text!.isEmpty && !tripsTF.text!.isEmpty && !airlineTF.text!.isEmpty {
                
                guard
                    let trips = Int(tripsTF.text!),
                    let airline = Int(airlineTF.text!)
                else {
                    self.showWarningAlert()
                    return
                }
                
                self.postPassenger(name: nameTF.text!, trips: trips, airline: airline)
            } else {
                self.showWarningAlert()
            }
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
        self.title = "Passengers"
        
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
            self.getAllPassengersData()
        }
        self.tableView.alpha = 0.3
    }
    
    // MARK: Find passenger in array method
    func find(value searchValue: PassengerModelElement, in array: [PassengerModelElement]) -> Int? {
        for (index, value) in array.enumerated() {
            if value.id == searchValue.id {
                return index
            }
        }
        return nil
    }
    
    // MARK: Detail Alert
    func presentDetailAlert(for indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Detail", message: "Select the required option", preferredStyle: .alert)
        
        let putAction = UIAlertAction(title: "Update the passenger data", style: .default) { _ in
            self.presentUpdateAlert(httpMethod: .put, indexPath: indexPath)
        }
        let patchAction = UIAlertAction(title: "Update the passenger name", style: .default) { _ in
            self.presentUpdateAlert(httpMethod: .patch, indexPath: indexPath)
        }
        let deleteAction = UIAlertAction(title: "Delete the passenger", style: .destructive) { _ in
            self.deletePassenger(at: indexPath)
        }
        
        alertController.addAction(putAction)
        alertController.addAction(patchAction)
        alertController.addAction(deleteAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Update Alert
    func presentUpdateAlert(httpMethod: ConstantsGlobal.HTTPMethod, indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Updating", message: "Enter new values", preferredStyle: .alert)
        for _ in 0...2 {
            alertController.addTextField()
        }
        
        let nameTF = alertController.textFields![0]
        nameTF.placeholder = "Enter name..."
        nameTF.keyboardType = .namePhonePad
        nameTF.textContentType = .name
        nameTF.autocapitalizationType = .words
        
        let tripsTF = alertController.textFields![1]
        tripsTF.placeholder = "Enter number of trips"
        tripsTF.keyboardType = .numberPad
        
        let airlineTF = alertController.textFields![2]
        airlineTF.placeholder = "Enter number of airline"
        airlineTF.keyboardType = .numberPad
        
        if httpMethod == .patch {
            alertController.textFields?[1].removeFromSuperview()
            alertController.textFields?[2].removeFromSuperview()
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            switch httpMethod {
            case .put:
                if !nameTF.text!.isEmpty && !tripsTF.text!.isEmpty && !airlineTF.text!.isEmpty {
                    guard
                        let trips = Int(tripsTF.text!),
                        let airline = Int(airlineTF.text!)
                    else {
                        self.showWarningAlert()
                        return
                    }
                    self.putPassenger(name: nameTF.text!, trips: trips, airline: airline, at: indexPath)
                    
                } else {
                    self.showWarningAlert()
                }
                
            case .patch:
                if !nameTF.text!.isEmpty {
                    self.patchPassengerName(name: nameTF.text!, at: indexPath)
                } else {
                    self.showWarningAlert()
                }
                
            default:
                break
            }
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Worning Alert
    func showWarningAlert() {
        let alertController = UIAlertController(title: "Warning", message: "The fields must not be empty", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: Networking -
extension PassengersVC {
    // MARK: Post passenger method -
    func postPassenger(name: String, trips: Int, airline: Int) {
        DataManager.instance.saveNewPassenger(name: name, trips: trips, airline: airline) {
            DispatchQueue.main.async {
                self.getAllPassengersData()
            }
            print("CREATED NEW PASSENGER")
        }
    }
    
    // MARK: Get some passengers method -
    func getSomePassengersData(completion: VoidClosure? = nil) {
        DispatchQueue.main.async {
            DataManager.instance.requestSomePassengers(completionHandler: {  [weak self] passengers in
                guard let self = self else { return }
                
                self.passengersData = passengers?.sorted(by: {$0.id! < $1.id!}) ?? [PassengerModelElement]()
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.tableView.alpha = 1
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    // MARK: Get all passengers method -
    func getAllPassengersData(completion: VoidClosure? = nil) {
        DispatchQueue.main.async {
            DataManager.instance.requestAllPassengers(completionHandler: {  [weak self] passengers in
                guard let self = self else { return }
                
                self.passengersData = passengers?.sorted(by: {$0.id! < $1.id!}) ?? [PassengerModelElement]()
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.tableView.alpha = 1
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    // MARK: Put passenger method -
    func putPassenger(name: String, trips: Int, airline: Int, at indexPath: IndexPath) {
        print("PUT passenger")
        let passenger = getAPassenger(at: indexPath)
        
        DataManager.instance.updatePassengerData(id: passenger.id, name: name, trips: trips, airline: airline) {
            DispatchQueue.main.async {
                self.getAllPassengersData()
            }
            print("Successfully Updated all passenger's data")
        }
    }
    
    // MARK: Patch passenger method -
    func patchPassengerName(name: String, at indexPath: IndexPath) {
        print("PATCH passenger")
        let passenger = getAPassenger(at: indexPath)
        
        DataManager.instance.updatePassengerName(id: passenger.id, name: name) {
            DispatchQueue.main.async {
                self.getAllPassengersData()
            }
            print("Successfully Updated passenger's name")
        }
    }
    
    // MARK: Delete passenger method -
    func deletePassenger(at indexPath: IndexPath) {
        print("DELETE passenger")
        // delete from server
        let passenger = getAPassenger(at: indexPath)
        DataManager.instance.deletePassenger(id: passenger.id) { [weak self] passengers in
            print("Successfully deleted passenger from server")
            self?.getAllPassengersData()
        }
        // delete from table view
        DispatchQueue.main.async {
            if self.isFiltering {
                self.filteredPassengersData.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                
                guard let index = self.find(value: passenger, in: self.passengersData) else {
                    print("Did not find index")
                    return
                }
                self.passengersData.remove(at: index)
            } else {
                self.passengersData.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

// MARK: Data Source -
extension PassengersVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableViewSettings() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PassengerCell.self)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.addSubview(refreshControl)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPassengersData.count
        } else {
            return passengersData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PassengerCell = tableView.dequeueReusableCell(for: indexPath)
        let passenger = getAPassenger(at: indexPath)
        
        if isFiltering {
            cell.hidePaginationLabel(is: true)
        } else {
            cell.hidePaginationLabel(is: false)
        }
        
        let viewModel = PassengerCellModel(name: passenger.name, trips: passenger.trips, airline: passenger.airline?.first?.name, paginationNumber: indexPath.row + 1)
        
        cell.config(viewModel: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isFiltering {
            return 200
        } else {
            return 230
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deletePassenger(at: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presentDetailAlert(for: indexPath)
    }
}

// MARK: Search Results Updating -
extension PassengersVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(by: searchController.searchBar.text!)
    }
    
    private func filterContent(by searchText: String) {
        struct DelayedSearchTask {
            static var delayedTask: DispatchWorkItem?
        }
        DelayedSearchTask.delayedTask?.cancel()
        
        if !isFiltering {
            self.filteredPassengersData.removeAll()
            tableView.reloadData()
            return
        }
        
        DelayedSearchTask.delayedTask = DispatchWorkItem {
            self.filteredPassengersData = self.passengersData.filter({ (passenger: PassengerModelElement) -> Bool in
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
