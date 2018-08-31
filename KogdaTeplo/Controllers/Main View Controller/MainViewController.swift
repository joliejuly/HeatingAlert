//
//  MainViewController.swift
//
//  Created by Julia Nikitina on 11.03.2018.
//  Copyright © 2018 Julia Nikitina. All rights reserved.
//
import UIKit


final class MainViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var heatingDate: UILabel!
    @IBOutlet weak var daysRemained: UILabel!
    @IBOutlet weak var mainScreenData: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var waitingLabel: UILabel!
    @IBOutlet weak var otherCityButton: UIButton!
    
    @IBOutlet weak var radiator: UIButton!
    
    //MARK: - Properties
    lazy var viewModel: MainViewViewModel = {
        return MainViewViewModel()
    }()
    
    var coordinator: Coordinator?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchHeatingData()
        
        setUpViews()
        setUpBindings()
        
        updateUI(with: viewModel.savedCity)
        setWaitingLabels()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateRadiator()
    }
    
    
    private func animateRadiator() {
        
        let rotate = CGAffineTransform(rotationAngle: 360)
        let translate = CGAffineTransform(translationX: -120, y: -120)
        let scale = CGAffineTransform(scaleX: 2, y: 2)
        radiator.transform = rotate.concatenating(translate).concatenating(scale)
        
        UIView.animate(withDuration: 3, delay: 2, usingSpringWithDamping: 0.8,initialSpringVelocity: 0.5, options: [.autoreverse,.curveEaseInOut], animations: {
            self.radiator.transform = .identity
        }, completion: nil)
    }

    
    @IBAction func chooseCityTapped(_ sender: UIButton) {
        coordinator?.showCitiesScreen()
    }
    
    
    @IBAction func aboutAreaTapped(_ sender: UIButton) {
        coordinator?.showAboutScreen()
    }
    
    
    @IBAction func swipeGestureOccured(_ sender: UISwipeGestureRecognizer) {
        
        switch sender.direction {
        case .up: coordinator?.showAboutScreen()
        case .left: coordinator?.showCitiesScreen()
        default: break
        }
        
    }
    
    
    private func setUpViews() {
        otherCityButton.layer.cornerRadius = 9
    }
    
    private func setUpBindings() {
        viewModel.didFinishDataRequest = { [weak self] requestResult in
            
            DispatchQueue.main.async {
                switch requestResult {
                case .success:
                    
                    if let city = self?.viewModel.selectedCity {
                        self?.updateUI(with: city)
                    } else if let city = self?.viewModel.savedCity {
                        self?.updateUI(with: city)
                    } else {
                        return
                    }
                    
                case .error:
                    self?.setWaitingLabels()
                }
            }
        }
    }
    
    //MARK: - Helpers
   
    public func updateUI(with selectedCity: String) {
    
        hideWaitingLabels()
        
        city.font = heatingDate.font
        
        let textForCityLabel = viewModel.textForCityLabel(for: selectedCity)
        let textForDateLabel = viewModel.dateAsString()
        let textForRemainedDaysLabel = viewModel.daysRemained()
        
        setDateLabel(with: textForDateLabel)
        setCityLabel(with: textForCityLabel)
        setRemainedDaysLabel(with: textForRemainedDaysLabel)
    }
    
    private func hideWaitingLabels() {
        waitingLabel.isHidden = true
        activityIndicator.stopAnimating()
        mainScreenData.isHidden = false
    }
    
    private func setCityLabel(with text: String) {
        if text.count > "Петропавл".count {
            city.numberOfLines = 4
            city.adjustsFontSizeToFitWidth = true
        }
        city.text = text
    }
    
    private func setDateLabel(with text: String) {
        if text.count > "20 сентября".count {
            heatingDate.adjustsFontSizeToFitWidth = true
        }
        heatingDate.text = text
    }
    
    private func setRemainedDaysLabel(with text: String) {
        if text.isEmpty {
            daysRemained.isHidden = true
        } else {
            daysRemained.isHidden = false
            daysRemained.text = text
        }
    }

    private func setWaitingLabels() {
        mainScreenData.isHidden = true
        waitingLabel.isHidden = false
        waitingLabel.text = "Ожидаем данные"
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    //MARK: - Navigation
    @IBAction func unwindToMainViewController(_ segue: UIStoryboardSegue) {
        if segue.identifier == PropertyKeys.selectCitySegue
        {
            guard let citiesTableViewController = segue.source as? CitiesTableViewController,
                let newCity = citiesTableViewController.selectedCity else { return }
            viewModel.selectedCity = newCity
            guard let selCity = viewModel.selectedCity else { return }
            updateUI(with: selCity)
            
        }
    }
    
    struct PropertyKeys {
        static let selectCitySegue = "selectCitySegue"
        static let dismissFromCitiesSegue = "dismissFromCitiesSegue"
        static let dismissFromAboutSegue = "dismissFromAboutSegue"
        static let touchDismissFromCitiesSegue = "touchDismissFromCitiesSegue"
    }
}
