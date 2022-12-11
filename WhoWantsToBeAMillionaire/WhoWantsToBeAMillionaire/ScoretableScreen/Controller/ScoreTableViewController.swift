//
//  ScoreTableViewController.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 05.12.2022.
//

import UIKit

final class ScoreTableViewController: UIViewController {

    // MARK: - Private properties

    private var scoreTableView: ScoreTableView? {
        return isViewLoaded ? view as? ScoreTableView : nil
    }

    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"

        return dateFormatter
    }()

    // MARK: - Lifecycle

    override func loadView() {
        view = ScoreTableView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scoreTableView?.delegate = self
        scoreTableView?.scoreTableButtonDelegate = self
        scoreTableView?.dataSource = self
        scoreTableView?.register(ScoreTableViewCell.self, forCellReuseIdentifier: ScoreTableViewCell.cellId)
        scoreTableView?.register(ReusableHeaderFooterView.self,
                                 forHeaderFooterViewReuseIdentifier: ReusableHeaderFooterView.headerFooterId)

        navigationController?.navigationBar.topItem?.backButtonTitle = "Назад"
        navigationController?.isNavigationBarHidden = false

        guard let rightBarButton = scoreTableView?.clearScoreTableButton else { return }
        
        navigationItem.rightBarButtonItem = rightBarButton
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
        let level = record.difficultyLevel == .easy ? "Легко" : "Хардкор"
        cell.labelsConfigure(with: (date, record.score, record.coins, record.usedHintsNumber, level))

        return cell
    }
}

extension ScoreTableViewController: ScoreTableViewDelegate {

    func clearScoreTableButtonTapped() {
        Game.shared.clearScoresTable()
        scoreTableView?.reloadData()
    }
}
