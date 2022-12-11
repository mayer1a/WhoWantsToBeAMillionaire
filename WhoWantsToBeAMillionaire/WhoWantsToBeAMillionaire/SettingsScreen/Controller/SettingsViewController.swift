//
//  SettingsViewController.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 10.12.2022.
//

import UIKit

final class SettingsViewController: UIViewController {

    // MARK: - Private properties

    private var settingsView: SettingsView? {
        return isViewLoaded ? view as? SettingsView : nil
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = SettingsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsView?.delegate = self
        settingsView?.levelControlConfigurate(with: Game.shared.difficultyLevel)
        settingsView?.orderControlConfigurate(with: Game.shared.questionOrder)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.topItem?.backButtonTitle = "Назад"
        navigationController?.isNavigationBarHidden = false
    }

}

// MARK: - Extensions

extension SettingsViewController: SettingsViewDelegate {

    func gameLevelChanged(with selectedIndex: Int) {
        switch selectedIndex {
            case 0:
                Game.shared.setDifficultyStrategy(with: .easy)
            case 1:
                Game.shared.setDifficultyStrategy(with: .medium)
            case 2:
                Game.shared.setDifficultyStrategy(with: .hard)
            default:
                break
        }
    }

    func questionOrderChanged(with selectedIndex: Int) {
        Game.shared.setQuestionOrder(with: selectedIndex)
    }
}
