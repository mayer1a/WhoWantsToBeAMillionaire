//
//  ScoreTableViewCell.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 05.12.2022.
//

import UIKit

/// An object responsible for displaying scoreboard data in a cell
class ScoreTableViewCell: UITableViewCell {

    // MARK: - Properties

    /// Returns the reusable cell indentifier for scoreboard table view
    static let cellId = "ScoreTableCell"

    /// Returns a label that displays the date the recorded scores
    var dateLabel: UILabel

    /// Returns a label displaying the game results
    var informationLabel: UILabel

    // MARK: - Construction

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.dateLabel = UILabel()
        self.informationLabel = UILabel()

        super.init(style: .value1, reuseIdentifier: reuseIdentifier)

        self.configureViewComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()

        self.dateLabel.text = String()
        self.informationLabel.text = String()
    }

    // MARK: - Functions

    /// Configures labels with the date and results of the user's games
    ///
    /// - Parameters:
    ///     - date: Record date of user scores
    ///     - score: Scores earned by the user per game
    ///     - coins: Coins earned by the user per game
    func labelsConfigure(with value: (date: String, score: Int, coins: Int, hints: Int, level: String)) {
        self.dateLabel.text = value.date
        self.informationLabel.text = """
            Верно отвечено на \(value.score)% вопросов
            Получено \(value.coins) монет
            Подсказок использовано \(value.hints) из 3
            Уровень сложности «\(value.level)»
            """
    }

    // MARK: - Private functions

    /// Configuration of all view cell components
    private func configureViewComponents() {

        // Configure cell style

        self.selectionStyle = .none
        self.contentView.backgroundColor = .systemGray4
        self.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        self.contentMode = .center
        self.selectionStyle = .none
        self.accessoryType = .none
        self.editingAccessoryType = .none

        // Create and configure text labels

        self.dateLabel.backgroundColor = self.contentView.backgroundColor
        self.dateLabel.numberOfLines = 1
        self.dateLabel.textAlignment = .left
        self.dateLabel.lineBreakMode = .byTruncatingTail
        self.dateLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        self.dateLabel.textColor = UIColor(named: "helpTextColor")
        self.dateLabel.translatesAutoresizingMaskIntoConstraints = false

        self.informationLabel.backgroundColor = self.contentView.backgroundColor
        self.informationLabel.numberOfLines = 0
        self.informationLabel.textAlignment = .right
        self.informationLabel.lineBreakMode = .byWordWrapping
        self.informationLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        self.informationLabel.textColor = UIColor(named: "helpTextColor")
        self.informationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.informationLabel.setContentHuggingPriority(UILayoutPriority(249.0), for: .horizontal)
        self.informationLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 749.0),
                                                                      for: .horizontal)

        self.contentView.addSubview(self.dateLabel)
        self.contentView.addSubview(self.informationLabel)

        // Create constraints

        NSLayoutConstraint.activate([
            self.dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.dateLabel.trailingAnchor.constraint(equalTo: self.informationLabel.leadingAnchor, constant: -10),
            self.informationLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.informationLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.informationLabel.centerYAnchor.constraint(equalTo: self.dateLabel.centerYAnchor),
            self.informationLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10)
        ])
    }
}
