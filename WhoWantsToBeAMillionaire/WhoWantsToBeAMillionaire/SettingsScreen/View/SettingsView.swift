//
//  SettingsView.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 10.12.2022.
//

import UIKit

protocol SettingsViewDelegate: AnyObject {

    func gameLevelChanged(with selectedIndex: Int)
    func questionOrderChanged(with selectedIndex: Int)
}


final class SettingsView: UIView {

    // MARK: - Properties

    weak var delegate: SettingsViewDelegate?

    // MARK: - Private properties

    private let difficultyLevels = ["Низкая", "Средняя", "Высокая"]
    private let questionOrderLevels = ["Оригинальный", "Случайный"]

    private var labelTemplate: UILabel {
        let label = UILabel()
        label.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        label.textColor = UIColor(named: "helpTextColor")
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }

    private var segmentedControlTemplate: UISegmentedControl {
        let selectedTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor(named: "segmentedTextColor") ?? UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0, weight: .medium)
        ]

        let normalTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor(named: "helpTextColor") ?? UIColor.label
        ]

        let control = UISegmentedControl()
        control.selectedSegmentTintColor = UIColor(named: "SwitchTintColor")
        control.contentVerticalAlignment = .center
        control.contentHorizontalAlignment = .center
        control.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        control.setTitleTextAttributes(normalTextAttributes, for: .normal)
        control.translatesAutoresizingMaskIntoConstraints = false

        control.layer.borderColor = UIColor(named: "SwitchBorderColor")?.cgColor
        control.layer.borderWidth = 1

        return control
    }

    private var levelControl: UISegmentedControl
    private var questionOrderControl: UISegmentedControl

    // MARK: - Construction

    required init() {
        levelControl = UISegmentedControl()
        questionOrderControl = UISegmentedControl()

        super.init(frame: .zero)

        configureViewComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Functions

    func levelControlConfigurate(with difficulty: GameDifficulty) {
        levelControl.selectedSegmentIndex = difficulty.rawValue
    }

    func orderControlConfigurate(with selectedIndex: Int) {
        questionOrderControl.selectedSegmentIndex = selectedIndex
    }

    // MARK: - Private functions

    private func configureViewComponents() {
        backgroundColor = UIColor(named: "LaunchBackgroundColor")

        levelControl = segmentedControlTemplate
        questionOrderControl = segmentedControlTemplate

        difficultyLevels.enumerated().forEach {
            levelControl.insertSegment(withTitle: $0.element, at: $0.offset, animated: false)
        }

        questionOrderLevels.enumerated().forEach {
            questionOrderControl.insertSegment(withTitle: $0.element, at: $0.offset, animated: false)
        }

        levelControl.selectedSegmentIndex = 0
        questionOrderControl.selectedSegmentIndex = 0

        let difficultyLabel = labelTemplate
        difficultyLabel.text = "Сложность"

        let questionOrderLabel = labelTemplate
        questionOrderLabel.text = "Порядок вопросов"

        levelControl.addTarget(self, action: #selector(gameLevelChanged(_:)), for: .valueChanged)
        questionOrderControl.addTarget(self, action: #selector(questionOrderChanged(_:)), for: .valueChanged)

        addSubview(difficultyLabel)
        addSubview(levelControl)
        addSubview(questionOrderLabel)
        addSubview(questionOrderControl)

        NSLayoutConstraint.activate([
            difficultyLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            difficultyLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            difficultyLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),

            levelControl.topAnchor.constraint(equalTo: difficultyLabel.bottomAnchor, constant: 10),
            levelControl.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            levelControl.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),

            questionOrderLabel.topAnchor.constraint(equalTo: levelControl.bottomAnchor, constant: 20),
            questionOrderLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            questionOrderLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),

            questionOrderControl.topAnchor.constraint(equalTo: questionOrderLabel.bottomAnchor, constant: 10),
            questionOrderControl.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            questionOrderControl.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }

    @objc private func gameLevelChanged(_ sender: UISegmentedControl) {
        delegate?.gameLevelChanged(with: sender.selectedSegmentIndex)
    }

    @objc private func questionOrderChanged(_ sender: UISegmentedControl) {
        delegate?.questionOrderChanged(with: sender.selectedSegmentIndex)
    }
}
