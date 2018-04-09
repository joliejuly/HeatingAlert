//
//  CitiesTableViewController.swift
//
//  Created by Julia Nikitina on 15.03.2018.
//  Copyright © 2018 Julia Nikitina. All rights reserved.
//

import UIKit

class CitiesTableViewController: UITableViewController {
    
    //a bug of search controller - it's not deinitialized with its view controller
    deinit {
        self.searchController.view.removeFromSuperview()
    }

    struct PropertyKeys {
        static let cityCell = "cityCell"
        static let selectCitySegue = "selectCitySegue"
    }
    
    //MARK: - Properties
    
    var selectedCity: String? {
        didSet {
            Heating.selectedCity = selectedCity
            Heating.saveDataOnDisk()
        }
    }
    
    var searchController: UISearchController = {
        // nil means that searchController will use this view controller to display the search results
        let tmpSearchController = UISearchController(searchResultsController: nil)
        tmpSearchController.dimsBackgroundDuringPresentation = false //important!
        tmpSearchController.searchBar.sizeToFit()
        tmpSearchController.searchBar.searchBarStyle = .minimal //no color, transparent
        tmpSearchController.searchBar.placeholder = "например, Москва"
        return tmpSearchController
    }()
    
    //search
    var filteredData: [String]!
    
    lazy var cities: [String] = {
        guard let newCities = Heating.regionsInRussian else {return [] }
        return newCities
    }()
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filteredData = cities
        searchController.searchResultsUpdater = self
        definesPresentationContext = true// Sets this view controller as presenting view controller for the search interface
        tableView.tableHeaderView = searchController.searchBar
        tableView.backgroundView = UIView()
        tableView.backgroundView?.backgroundColor = UIColor(hex: "FCD16D")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cities = []
        filteredData = []
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.searchBar.resignFirstResponder()
        searchController.searchBar.text = ""
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.cityCell, for: indexPath)
        cell.textLabel?.text = filteredData[indexPath.row]
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = UIColor(hex: "FCC646")
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCity = filteredData[indexPath.row]
        searchController.searchBar.resignFirstResponder()
        performSegue(withIdentifier: PropertyKeys.selectCitySegue, sender: self)
    }
}

// MARK: - Conforming to UISearchResultsUpdating protocol

extension CitiesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredData = searchText.isEmpty ? cities : cities.filter( {(dataString: String) -> Bool in
                return dataString.range(of: searchText, options: [.caseInsensitive, .anchored]) != nil
            })
            tableView.reloadData()
        }
    }
}
