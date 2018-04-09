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
    
    // MARK: - Location
    var currentUserLocation: CLLocation?
    var nameOfUserLocation: String?
    
    //location manager is an object that has the device's location
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.distanceFilter = kCLLocationAccuracyKilometer //The default value of this property is none, so you'll be notified of all movements
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer //The default value of this property is kCLLocationAccuracyBest, which can exaust the battery
        locationManager.delegate = self //no retain cycle, because it's declared as unowned
        return locationManager
    }()
    
}

//MARK: - CLLocation delegate methods (didChangeAuthorization, didUpdateLocations and didFailWithError)
extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status == .authorizedWhenInUse else { return }
            manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
            currentUserLocation = location // update current location
            manager.delegate = nil // reset delegate
            manager.stopUpdatingLocation() // stop Location Manager
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        return
    }
    
    func tryToRequestLocation(){
        // remember user settings about location alerts
        let isAlertAllowed: Bool = {
            guard let isAlertAllowed = UserDefaults.standard.object(forKey: "isAlertAllowed") as? Bool else { return true }
            return isAlertAllowed
        }()
        
        if !CLLocationManager.locationServicesEnabled() && isAlertAllowed { //check if GPS is turned on on the device
            present(Alert.alertToGeneralSettings, animated: true, completion: nil)
        } else if CLLocationManager.locationServicesEnabled() && isAlertAllowed {
            checkAuthorizationStatus()
        } else { return }
    }
    
    private func checkAuthorizationStatus() {
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()    //ask for permission
            case .restricted, .denied:
                present(Alert.alertToAppSettings, animated: true, completion: nil)
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.requestLocation() //this method is a quick ask for location only once - without updating. we must implement delegation methods to be able to receive the answer of that method
        }
    }
    
    func updateUIWithPlacemark(placemark: CLPlacemark?) {
        guard let placemark = placemark, let city = placemark.administrativeArea else { return }
            selectedCity = city
            Heating.selectedCity = selectedCity
            Heating.saveDataOnDisk()
            updateUI(with: selectedCity)
        }
    
    //MARK: - Convert coordinates to a name with adress
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        guard let lastLocation = self.locationManager.location else { return }
            reverseGeocode(with: lastLocation, and: completionHandler) // Use the last reported location.
    }
    
    private func reverseGeocode(with location: CLLocation, and completionHandler: @escaping (CLPlacemark?) -> Void) {
        guard #available(iOS 11.0, *) else { return }
            let geocoder = CLGeocoder()
            let locale = Locale(identifier: "ru_RU")
            geocoder.reverseGeocodeLocation(location,
                                            preferredLocale: locale) { placemarks, error in
                guard error == nil else { return }
                DispatchQueue.main.async {
                        let firstLocation = placemarks?[0]
                        completionHandler(firstLocation)
                    }
            }
    }
}
