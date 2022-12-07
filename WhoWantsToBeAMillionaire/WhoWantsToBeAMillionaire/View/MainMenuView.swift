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
        button.addTarget(self, action: #selector(self.buttonDidTapped), for: .touchUpInside)
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
        self.scoreLabel = UILabel()
        self.playButton = UIButton()
        self.scoreButton = UIButton()
        self.levelSwitch = UISwitch()

        super.init(frame: .zero)

        self.configureViewComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        self.levelSwitch.layer.borderColor = UIColor(named: "SwitchBorderColor")?.cgColor
        self.levelSwitch.layer.cornerRadius = self.levelSwitch.frame.height / 2
        self.levelSwitch.layer.masksToBounds = true
        self.levelSwitch.layer.borderWidth = 1
    }

    // MARK: - Functions

    /// Configures a label with the results of the last game session
    ///
    /// - Parameters:
    ///     - score: The number of scores earned by the user
    ///     - coins: The number of coins earned by the user
    func scoreLabelConfigurate(with value: (score: Int, coins: Int)) {
        self.scoreLabel.text = "Последний результат: \(value.score)% | \(value.coins) монет"
    }

    /// Configures a label with empty string
    ///
    /// - Parameters:
    ///     - text: String to set to score label, **default is empty**
    func scoreLabelConfigurate(with text: String = "") {
        self.scoreLabel.text = text
    }

    /// Configures the game level switch based on restored data
    ///
    /// - Parameters:
    ///     - state: Restored switch level state
    func levelSwitchConfigurate(with state: Bool) {
        self.levelSwitch.setOn(state, animated: false)
    }

    // MARK: - Private functions

    /// Configuration of all view cell components
    private func configureViewComponents() {
        self.backgroundColor = UIColor(named: "LaunchBackgroundColor")

        // Configure play and scoreboard buttons

        self.playButton = self.buttonTemplate
        self.playButton.setTitle("Играть", for: .normal)
        self.playButton.setTitleColor(.black, for: .normal)
        self.playButton.setBackgroundImage(UIImage(named: "play"), for: .normal)
        self.playButton.tag = 0

        self.scoreButton = self.buttonTemplate
        self.scoreButton.setTitle("Результаты", for: .normal)
        self.scoreButton.setTitleColor(UIColor(named: "helpTextColor"), for: .normal)
        self.scoreButton.tag = 1

        if #available(iOS 15.0, *) {
            self.scoreButton.configuration = UIButton.Configuration.plain()
            self.scoreButton.setImage(UIImage(named: "scoreTable"), for: .normal)
            self.scoreButton.configuration?.imagePlacement = .top
        }

        // Configures score label

        self.scoreLabel = self.labelTemplate
        self.scoreLabel.textAlignment = .center

        // Configures game difficult level switch and labels

        self.levelSwitch.setOn(false, animated: false)
        self.levelSwitch.onTintColor = UIColor(named: "SwitchTintColor")
        self.levelSwitch.clipsToBounds = true
        self.levelSwitch.translatesAutoresizingMaskIntoConstraints = false
        self.levelSwitch.addTarget(self, action: #selector(self.gameLevelChanged(_:)), for: .valueChanged)
        
        let easyLabel = self.labelTemplate
        easyLabel.text = "Хардкорный режим:"

        // Add subviews

        self.addSubview(self.playButton)
        self.addSubview(self.scoreButton)
        self.addSubview(self.scoreLabel)
        self.addSubview(self.levelSwitch)
        self.addSubview(easyLabel)

        // Configures constraints

        NSLayoutConstraint.activate([
            self.playButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 128.0),
            self.playButton.widthAnchor.constraint(equalTo: self.playButton.heightAnchor),
            self.playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            self.playButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -87),
            self.playButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 87),

            self.scoreButton.centerXAnchor.constraint(equalTo: self.playButton.centerXAnchor),
            self.scoreButton.topAnchor.constraint(equalTo: self.playButton.bottomAnchor, constant: 40.0),
            self.scoreButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 121.0),
            self.scoreButton.widthAnchor.constraint(equalTo: self.scoreButton.heightAnchor),

            self.scoreLabel.topAnchor.constraint(greaterThanOrEqualTo: self.scoreButton.bottomAnchor, constant: 10),
            self.scoreLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            self.scoreLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            self.scoreLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),

            self.levelSwitch.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.levelSwitch.leadingAnchor.constraint(equalTo: easyLabel.trailingAnchor, constant: 50),

            easyLabel.centerYAnchor.constraint(equalTo: self.levelSwitch.centerYAnchor),
            easyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10)
        ])
    }

    /// The action that occurs when you tap on the play or scoreboard buttons
    @objc private func buttonDidTapped(_ sender: UIButton) {
        self.delegate?.buttonDidTapped(with: sender.tag)
    }

    /// The action that occurs when you change switch state and change game difficult level
    @objc private func gameLevelChanged(_ sender: UISwitch) {
        self.delegate?.gameLevelChanged()
    }
}
