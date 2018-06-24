//  MainViewController.swift
//
//  Created by Julia Nikitina on 11.03.2018.
//  Copyright © 2018 Julia Nikitina. All rights reserved.

import UIKit
import CoreLocation

class MainViewController: UIViewController {

    //MARK: - Properties
    var selectedCity: String = {
        guard let savedCity = Heating.savedCity else { return "Москва" }
        return savedCity
    }()
    
    private lazy var requestHeatingController = RequestHeatingDataController()
    
    //applying MVVC pattern
    private var viewModel: MainViewViewModel? {
        didSet {
            updateUI(with: selectedCity)
        }
    }
    
    //segues' names to avoid string literals
    struct PropertyKeys {
        static let selectCitySegue = "selectCitySegue"
        static let dismissFromCitiesSegue = "dismissFromCitiesSegue"
        static let dismissFromAboutSegue = "dismissFromAboutSegue"
        static let touchDismissFromCitiesSegue = "touchDismissFromCitiesSegue"
    }
    
    //MARK: - Outlets
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var heatingDate: UILabel!
    @IBOutlet weak var daysRemained: UILabel!
    @IBOutlet weak var mainScreenData: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var waitingLabel: UILabel!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI(with: selectedCity)
    }
    
    //MARK: - Helpers
    func fetchHeatingData() {
        requestHeatingController.requestHeatingData(){ response in
                DispatchQueue.main.async { [weak self] in
                    if let response = response {
                        self?.viewModel = MainViewViewModel(heatingInfos: response)
                    } else {
                        self?.setWaitingLabels()
                    }
                }
        }
    }

    //MARK: - User Interface methods
    func updateUI(with selectedCity: String) {
        guard let regionsInRussian = Heating.regionsInRussian,
            let newIndex = regionsInRussian.index(of: selectedCity),
            let viewModel = viewModel
            else { setWaitingLabels(); return }
        
        prepareUI()
        prepareLabels(with: viewModel, for: newIndex)
    }
    
    private func prepareUI() {
        city.font = heatingDate.font
        waitingLabel.isHidden = true
        activityIndicator.stopAnimating()
        mainScreenData.isHidden = false
    }
    
    private func prepareLabels(with viewModel: MainViewViewModel, for index: Int) {
        setCityLabel(with: viewModel, for: index)
        setDateLabel(with: viewModel, for: index)
        setRemainedDaysLabel(with: viewModel, for: index)
    }

    private func setCityLabel(with viewModel: MainViewViewModel, for index: Int) {
        let textForCityLabel = viewModel.textForCityLabel(for: index)
        if textForCityLabel.count > "Петропавл".count {
            city.numberOfLines = 3
            city.adjustsFontSizeToFitWidth = true
        }
        city.text = textForCityLabel
    }
    
    private func setDateLabel(with viewModel: MainViewViewModel, for index: Int) {
        let textForDateLabel = viewModel.dateAsString(for: index)
        if textForDateLabel.count > "20 сентября".count {
            heatingDate.adjustsFontSizeToFitWidth = true
        }
        heatingDate.text = textForDateLabel
    }
    
    private func setRemainedDaysLabel(with viewModel: MainViewViewModel, for index: Int) {
        let textForRemainedDaysLabel = viewModel.daysRemained(for: index)
        if textForRemainedDaysLabel.isEmpty {
            daysRemained.isHidden = true
        } else {
            daysRemained.isHidden = false
            daysRemained.text = textForRemainedDaysLabel
        }
    }
    
    private func setWaitingLabels() {
        mainScreenData.isHidden = true
        waitingLabel.isHidden = false
        activityIndicator.startAnimating()
    }
    
    //MARK: - Navigation
    @IBAction func unwindToMainViewController(_ segue: UIStoryboardSegue) {
        if segue.identifier == PropertyKeys.selectCitySegue {
            guard let citiesTableViewController = segue.source as? CitiesTableViewController,
                let newCity = citiesTableViewController.selectedCity
            else { return }
            
            selectedCity = newCity
            updateUI(with: selectedCity)
        }
    }
    
}
