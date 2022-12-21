//
//  MainMenuView.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 03.12.2022.
//

import UIKit

protocol MainMenuViewDelegate: AnyObject {

    func buttonDidTapped(with tag: Int)
}

final class MainMenuView: UIView {

    // MARK: - Properties

    weak var delegate: MainMenuViewDelegate?

    // MARK: - Private properties

    private var labelTemplate: UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        label.textColor = UIColor(named: "helpTextColor")
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }

    private var playButton: CustomCopyingUIButton = {
        let button = CustomCopyingUIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        button.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private var scoreLabel: UILabel
    private lazy var scoreButton = playButton.getCopy()
    private lazy var settingsButton = playButton.getCopy()
    private lazy var addQuestionsButton = playButton.getCopy()

    // MARK: - Constructions

    required init() {
        scoreLabel = UILabel()

        super.init(frame: .zero)

        configureViewComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    func scoreLabelConfigurate(with value: (score: Int, coins: Int)) {
        scoreLabel.text = "Последний результат: \(value.score)% | \(value.coins) монет"
    }

    func scoreLabelConfigurate(with text: String = "") {
        scoreLabel.text = text
    }

    // MARK: - Private functions

    private func configureViewComponents() {
        backgroundColor = UIColor(named: "LaunchBackgroundColor")

        playButton.setTitle("Играть", for: .normal)
        playButton.setTitleColor(.black, for: .normal)
        playButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
        playButton.tag = 0
        playButton.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)

        scoreButton.setTitle("Результаты", for: .normal)
        scoreButton.setTitleColor(UIColor(named: "helpTextColor"), for: .normal)
        scoreButton.tag = 1
        scoreButton.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)

        if #available(iOS 15.0, *) {
            scoreButton.configuration = UIButton.Configuration.plain()
            scoreButton.setImage(UIImage(named: "scoreTable"), for: .normal)
            scoreButton.configuration?.imagePlacement = .top
        }

        scoreLabel = labelTemplate
        scoreLabel.textAlignment = .center

        settingsButton.setBackgroundImage(UIImage(named: "settings"), for: .normal)
        settingsButton.tag = 2
        settingsButton.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)

        addQuestionsButton.setBackgroundImage(UIImage(named: "addQuestion"), for: .normal)
        addQuestionsButton.tag = 3
        addQuestionsButton.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)

        addSubview(playButton)
        addSubview(scoreButton)
        addSubview(scoreLabel)
        addSubview(settingsButton)
        addSubview(addQuestionsButton)

        NSLayoutConstraint.activate([
            playButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 128.0),
            playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor),
            playButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            playButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -87),
            playButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 87),

            scoreButton.centerXAnchor.constraint(equalTo: playButton.centerXAnchor),
            scoreButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 40.0),
            scoreButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 121.0),
            scoreButton.widthAnchor.constraint(equalTo: scoreButton.heightAnchor),

            scoreLabel.topAnchor.constraint(greaterThanOrEqualTo: scoreButton.bottomAnchor, constant: 10),
            scoreLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            scoreLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            scoreLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            settingsButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            settingsButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),

            addQuestionsButton.centerYAnchor.constraint(equalTo: settingsButton.centerYAnchor),
            addQuestionsButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10)
        ])
    }

    @objc private func buttonDidTapped(_ sender: UIButton) {
        delegate?.buttonDidTapped(with: sender.tag)
    }
}
