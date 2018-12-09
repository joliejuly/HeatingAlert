//
//  Coordinator.swift
//  KogdaTeplo
//
//  Created by Julia Nikitina on 28/08/2018.
//  Copyright © 2018 Julia Nikitina. All rights reserved.
//

import UIKit

final class Coordinator {
    
    var selectedCity: String? {
        didSet {
            updateWithSelectedCity()
        }
    }
    var router: UINavigationController
    
    init(router: UINavigationController) {
        self.router = router
    }
    
    func start() {
        let mainScreen = makeMainScreen()
        mainScreen.coordinator = self
        router.setViewControllers([mainScreen],
                                  animated: true)
    }
    
    func showCitiesScreen() {
        let citiesScreen = makeCitiesScreen()
        citiesScreen.coordinator = self
        router.pushViewController(citiesScreen,
                                  animated: true)
    }
    
    func showAboutScreen() {
        let aboutScreen = makeAboutScreen()
        router.pushViewController(aboutScreen,
                                  animated: true)
    }
    
    private var mainStoryboard: UIStoryboard = {
        return UIStoryboard(name: "Main", bundle: nil)
    }()
    
    private func updateWithSelectedCity() {
        for viewController in router.viewControllers {
            if viewController is MainViewController {
                guard let mainVC = viewController
                    as? MainViewController
                    else { return }
                mainVC.viewModel.selectedCity = selectedCity
                mainVC.updateUI(with: selectedCity!)
            }
        }
    }
}

//MARK: - Private interface

extension Coordinator {

    private func makeMainScreen() -> MainViewController {
        guard let mainScreen =
            mainStoryboard
                .instantiateViewController(
                    withIdentifier: "MainScreen")
                as? MainViewController
            else { fatalError("No main vc in storyboard") }
        return mainScreen
    }
    
    private func makeCitiesScreen() -> CitiesTableViewController {
        guard let citiesScreen =
            mainStoryboard
                .instantiateViewController(
                    withIdentifier: "CitiesScreen")
                as? CitiesTableViewController
            else { fatalError("No cities vc in storyboard") }
        return citiesScreen
    }
    
    private func makeAboutScreen() -> AboutViewController {
        guard let aboutScreen = mainStoryboard
            .instantiateViewController(
                withIdentifier: "AboutScreen")
            as? AboutViewController
            else { fatalError("No about vc in storyboard") }
        return aboutScreen
    }
}
