//
//  MainMenuViewController.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 30.11.2022.
//

import UIKit

final class MainMenuViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var menuView: MainMenuView? {
        return isViewLoaded ? view as? MainMenuView : nil
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = MainMenuView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuView?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        
        guard let lastScoreResult = Game.shared.scores.first else {
            menuView?.scoreLabelConfigurate()
            return
        }
        
        menuView?.levelSwitchConfigurate(with: Game.shared.isHardcoreLevel)
        menuView?.scoreLabelConfigurate(with: (lastScoreResult.score, lastScoreResult.coins))
    }
}

// MARK: - Extensions

extension MainMenuViewController: MainMenuViewDelegate {
    
    func gameLevelChanged() {
        Game.shared.toggleGameLevel()
    }
    
    func buttonDidTapped(with tag: Int) {
        switch tag {
            case 0:
                navigationController?.pushViewController(GameViewController(), animated: true)
            case 1:
                navigationController?.pushViewController(ScoreTableViewController(), animated: true)
            default:
                break
        }
    }
}
