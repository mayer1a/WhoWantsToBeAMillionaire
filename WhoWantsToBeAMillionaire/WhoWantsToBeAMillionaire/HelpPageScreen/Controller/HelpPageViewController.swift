//
//  HelpPageViewController.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 06.12.2022.
//

import UIKit

protocol GameViewControllerDelegate: AnyObject {

    var hints: [String] { get }
}

final class HelpPageViewController: UIViewController {

    // MARK: - Properties

    weak var delegate: GameViewControllerDelegate?

    // MARK: - Private properties

    private var helpPageView: HelpPageView? {
        return isViewLoaded ? view as? HelpPageView : nil
    }

    // MARK: - Lifecycle

    override func loadView() {
        view = HelpPageView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let gameInfo = Game.shared.gameSession else { return }

        navigationController?.navigationBar.topItem?.backButtonTitle = "Назад"
        helpPageView?.rulesLabelConfugure(with: gameInfo, delegate?.hints)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}
