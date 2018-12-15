//
//  CitiesTableViewController.swift
//
//  Created by Julia Nikitina on 15.03.2018.
//  Copyright © 2018 Julia Nikitina. All rights reserved.
//

import UIKit

struct PropertyKeys {
    static let cityCell = "cityCell"
    static let selectCitySegue = "selectCitySegue"
}

final class CitiesTableViewController: UITableViewController {

    var coordinator: Coordinator?
    var didSelectCity: ((String?) -> Void)?
    var filteredData = [String]()
    var selectedCity: String? {
        didSet {
            HeatingInfo.selectedCity = selectedCity
            HeatingInfo.saveDataOnDisk()
        }
    }
    var cities: [String] = {
        guard let newCities =
            DataSource.shared
                .regionsInRussian
            else { return [] }
        return newCities
    }()
    
    lazy var searchController: UISearchController = {
        // nil means that searchController will use
        // this view controller to display the search results
        let tmpSearchController =
            UISearchController(searchResultsController: nil)
        tmpSearchController
            .dimsBackgroundDuringPresentation = false
        tmpSearchController
            .hidesNavigationBarDuringPresentation = false
        tmpSearchController
            .searchBar.sizeToFit()
        tmpSearchController
            .searchBar.searchBarStyle = .prominent //transparent
        tmpSearchController
            .searchBar.placeholder = "например, Москва"
        return tmpSearchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        searchController.searchResultsUpdater = self
        filteredData = cities
    }
    
    private func setUpViews() {
        navigationController?.navigationBar.isHidden = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        navigationItem.searchController?
            .searchBar.barTintColor = .white
        navigationItem.searchController?
            .searchBar.isTranslucent = false
    }
    
    @IBAction func swipeGestureOccured(_ sender: UISwipeGestureRecognizer) {
        dismissWithAnimation()
    }
    
    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(
                withIdentifier: PropertyKeys.cityCell,
                for: indexPath
        )
        guard indexPath.row < filteredData.count
            else { return }
        cell.textLabel?.text = filteredData[indexPath.row]
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.textLabel?.highlightedTextColor = .white
        cell.selectedBackgroundView = UIView()
        cell.selectedBackgroundView?.backgroundColor = .mainBlue
        return cell
    }

    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < filteredData.count
            else { return }
        selectedCity = filteredData[indexPath.row]
        navigationItem.searchController?.isActive = false
        dismissWithAnimation()
        coordinator?.selectedCity = selectedCity
    }
    
    private func dismissWithAnimation() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionMoveIn
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.popViewController(animated: false)
    }
}

extension CitiesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(
        for searchController: UISearchController) {
        if let searchText = searchController
            .searchBar.text {
            filteredData =
                searchText.isEmpty ? cities :
                cities.filter {(dataString: String) -> Bool in
                return dataString.range(of: searchText, options: [.caseInsensitive, .anchored]) != nil
            }
            tableView.reloadData()
        }
    }
}
