//
//  MainMenuView.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 03.12.2022.
//

import UIKit

/// The methods used by an object to pass information about user interaction with interface elements
protocol MainMenuViewDelegate: AnyObject {

    /// Handles button presses on the main menu. Moves to the next view controller depending on the button tapped.
    /// The tapped button is identified by button's tag
    /// - Parameters:
    ///     - tag: Button tapped tag
    func buttonDidTapped(with tag: Int)

    /// Handles button presses on the main menu. Moves to the next view controller depending on the button tapped.
    /// The tapped button is identified by button's tag
    /// - Parameters:
    ///     - tag: Button tapped tag
    func gameLevelChanged()
}

/// An object that is responsible for the visual component of the main menu
final class MainMenuView: UIView {

    // MARK: - Properties

    /// Delegate responsible for calling methods for handling button taps
    weak var delegate: MainMenuViewDelegate?

    // MARK: - Private properties

    /// Returns the configured button template
    private var buttonTemplate: UIButton {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        button.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        button.addTarget(self, action: #selector(buttonDidTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }

    /// Returns the configured label template
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

    /// Returns the button by which the user starts a new game session
    private var playButton: UIButton

    /// Returns the button by which the user goes to the scoretable
    private var scoreButton: UIButton

    /// Returns a label with the results of the last game session
    private var scoreLabel: UILabel

    /// Returns the game level switch
    private var levelSwitch: UISwitch

    // MARK: - Constructions

    required init() {
        scoreLabel = UILabel()
        playButton = UIButton()
        scoreButton = UIButton()
        levelSwitch = UISwitch()

        super.init(frame: .zero)

        configureViewComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        levelSwitch.layer.borderColor = UIColor(named: "SwitchBorderColor")?.cgColor
        levelSwitch.layer.cornerRadius = levelSwitch.frame.height / 2
        levelSwitch.layer.masksToBounds = true
        levelSwitch.layer.borderWidth = 1
    }

    // MARK: - Functions

    /// Configures a label with the results of the last game session
    ///
    /// - Parameters:
    ///     - score: The number of scores earned by the user
    ///     - coins: The number of coins earned by the user
    func scoreLabelConfigurate(with value: (score: Int, coins: Int)) {
        scoreLabel.text = "Последний результат: \(value.score)% | \(value.coins) монет"
    }

    /// Configures a label with empty string
    ///
    /// - Parameters:
    ///     - text: String to set to score label, **default is empty**
    func scoreLabelConfigurate(with text: String = "") {
        scoreLabel.text = text
    }

    /// Configures the game level switch based on restored data
    ///
    /// - Parameters:
    ///     - state: Restored switch level state
    func levelSwitchConfigurate(with state: Bool) {
        levelSwitch.setOn(state, animated: false)
    }

    // MARK: - Private functions

    /// Configuration of all view cell components
    private func configureViewComponents() {
        backgroundColor = UIColor(named: "LaunchBackgroundColor")

        playButton = buttonTemplate
        playButton.setTitle("Играть", for: .normal)
        playButton.setTitleColor(.black, for: .normal)
        playButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
        playButton.tag = 0

        scoreButton = buttonTemplate
        scoreButton.setTitle("Результаты", for: .normal)
        scoreButton.setTitleColor(UIColor(named: "helpTextColor"), for: .normal)
        scoreButton.tag = 1

        if #available(iOS 15.0, *) {
            scoreButton.configuration = UIButton.Configuration.plain()
            scoreButton.setImage(UIImage(named: "scoreTable"), for: .normal)
            scoreButton.configuration?.imagePlacement = .top
        }

        scoreLabel = labelTemplate
        scoreLabel.textAlignment = .center

        levelSwitch.setOn(false, animated: false)
        levelSwitch.onTintColor = UIColor(named: "SwitchTintColor")
        levelSwitch.clipsToBounds = true
        levelSwitch.translatesAutoresizingMaskIntoConstraints = false
        levelSwitch.addTarget(self, action: #selector(gameLevelChanged(_:)), for: .valueChanged)
        
        let easyLabel = labelTemplate
        easyLabel.text = "Хардкорный режим:"

        addSubview(playButton)
        addSubview(scoreButton)
        addSubview(scoreLabel)
        addSubview(levelSwitch)
        addSubview(easyLabel)

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

            levelSwitch.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            levelSwitch.leadingAnchor.constraint(equalTo: easyLabel.trailingAnchor, constant: 50),

            easyLabel.centerYAnchor.constraint(equalTo: levelSwitch.centerYAnchor),
            easyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }

    /// The action that occurs when you tap on the play or scoreboard buttons
    @objc private func buttonDidTapped(_ sender: UIButton) {
        delegate?.buttonDidTapped(with: sender.tag)
    }

    /// The action that occurs when you change switch state and change game difficult level
    @objc private func gameLevelChanged(_ sender: UISwitch) {
        delegate?.gameLevelChanged()
    }
}
