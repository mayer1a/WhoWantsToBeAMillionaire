//
//  ScoreTableViewCell.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 05.12.2022.
//

import UIKit

class ScoreTableViewCell: UITableViewCell {

    // MARK: - Properties

    static let cellId = "ScoreTableCell"

    var dateLabel: UILabel
    var informationLabel: UILabel

    // MARK: - Construction

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        dateLabel = UILabel()
        informationLabel = UILabel()

        super.init(style: .value1, reuseIdentifier: reuseIdentifier)

        configureViewComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()

        dateLabel.text = String()
        informationLabel.text = String()
    }

    // MARK: - Functions

    func labelsConfigure(with value: (date: String, score: Int, coins: Int, hints: Int, level: String)) {
        dateLabel.text = value.date
        informationLabel.text = """
            Верно отвечено на \(value.score)% вопросов
            Получено \(value.coins) монет
            Подсказок использовано \(value.hints) из 3
            Уровень сложности «\(value.level)»
            """
    }

    // MARK: - Private functions

    private func configureViewComponents() {
        selectionStyle = .none
        contentView.backgroundColor = .systemGray4
        backgroundColor = UIColor(named: "LaunchBackgroundColor")
        contentMode = .center
        selectionStyle = .none
        accessoryType = .none
        editingAccessoryType = .none

        dateLabel.backgroundColor = contentView.backgroundColor
        dateLabel.numberOfLines = 1
        dateLabel.textAlignment = .left
        dateLabel.lineBreakMode = .byTruncatingTail
        dateLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        dateLabel.textColor = UIColor(named: "helpTextColor")
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        informationLabel.backgroundColor = contentView.backgroundColor
        informationLabel.numberOfLines = 0
        informationLabel.textAlignment = .right
        informationLabel.lineBreakMode = .byWordWrapping
        informationLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .medium)
        informationLabel.textColor = UIColor(named: "helpTextColor")
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        informationLabel.setContentHuggingPriority(UILayoutPriority(249.0), for: .horizontal)
        informationLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 749.0), for: .horizontal)

        contentView.addSubview(dateLabel)
        contentView.addSubview(informationLabel)

        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: informationLabel.leadingAnchor, constant: -10),
            informationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            informationLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            informationLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            informationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
}
