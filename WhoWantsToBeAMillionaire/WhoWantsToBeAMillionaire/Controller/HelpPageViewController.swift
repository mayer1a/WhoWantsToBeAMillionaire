//
//  HelpPageViewController.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 06.12.2022.
//

import UIKit

/// The methods and properties used by the object to pass information about available hints in the current game session.
protocol GameViewControllerDelegate: AnyObject {

    /// Returns an array of descriptions of available hints
    var hints: [String] { get }
}

/// An object responsible for interacting and content on the help screen
final class HelpPageViewController: UIViewController {

    // MARK: - Properties

    /// The delegate responsible for passing of available hints descriptions within the current game session
    weak var delegate: GameViewControllerDelegate?

    // MARK: - Private properties

    /// Returns cast view to **HelpPageView** type
    private var helpPageView: HelpPageView? {
        return isViewLoaded ? self.view as? HelpPageView : nil
    }

    // MARK: - Lifecycle

    override func loadView() {
        self.view = HelpPageView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let gameInfo = Game.shared.gameSession else { return }

        self.navigationController?.navigationBar.topItem?.backButtonTitle = "Назад"
        self.helpPageView?.rulesLabelConfugure(with: gameInfo, delegate?.hints)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}
