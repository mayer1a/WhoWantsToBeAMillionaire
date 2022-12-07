//
//  ScoreTableViewController.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 05.12.2022.
//

import UIKit

/// An object responsible for interacting with the scoretable screen
final class ScoreTableViewController: UIViewController {

    // MARK: - Private properties

    /// Returns cast view to **ScoreTableView** type
    private var scoreTableView: ScoreTableView? {
        return isViewLoaded ? self.view as? ScoreTableView : nil
    }

    /// Returns date formatter for date readability
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"

        return dateFormatter
    }()

    // MARK: - Lifecycle

    override func loadView() {
        self.view = ScoreTableView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scoreTableView?.delegate = self
        self.scoreTableView?.scoreTableButtonDelegate = self
        self.scoreTableView?.dataSource = self
        self.scoreTableView?.register(ScoreTableViewCell.self, forCellReuseIdentifier: ScoreTableViewCell.cellId)
        self.scoreTableView?.register(ReusableHeaderFooterView.self,
                                      forHeaderFooterViewReuseIdentifier: ReusableHeaderFooterView.headerFooterId)


        self.navigationController?.navigationBar.topItem?.backButtonTitle = "Назад"

        guard let rightBarButton = self.scoreTableView?.clearScoreTableButton else { return }
        
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
}

// MARK: - Extensions

extension ScoreTableViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Game.shared.scores.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        10.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableHeaderFooterView.headerFooterId)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableHeaderFooterView.headerFooterId)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: ScoreTableViewCell.cellId,
                                                     for: indexPath) as? ScoreTableViewCell
        else {
            return UITableViewCell()
        }

        let record = Game.shared.scores[indexPath.section]

        let date = dateFormatter.string(from: record.date)
        let level = record.isHardcoreLevel ? "Хардкор" : "Легко"
        cell.labelsConfigure(with: (date, record.score, record.coins, record.usedHintsNumber, level))

        return cell
    }
}

extension ScoreTableViewController: ScoreTableViewDelegate {

    func clearScoreTableButtonTapped() {
        Game.shared.clearScoresTable()
        self.scoreTableView?.reloadData()
    }
}
