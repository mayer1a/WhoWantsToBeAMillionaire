//
//  GameView.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 04.12.2022.
//

import UIKit

/// The methods used by an object to pass information about user interaction with interface elements
protocol GameViewDelegate: AnyObject {

    /// Triggered when the player taps any answer button
    func answerButtonTapped(with playerAnswer: String)

    /// Triggered when the player taps the exit button
    func gameExit()

    /// Triggered when the player taps the help button
    func helpButtonTapped()

    /// Triggered when the player taps on the hint buttons
    func hintButtonsTapped(with tag: Int)
}

/// An object that is responsible for the visual component of the game session
final class GameView: UIView {
    
    // MARK: - Properties

    /// Delegate responsible for calling methods for handling button taps
    weak var delegate: GameViewDelegate?

    /// Returns a collection of all answer buttons
    var answerButtons: [UIButton]

    /// Returns a collection of all hint buttons
    var hintButtons: [UIButton]

    /// Returns the exit button
    var exitButton: UIButton

    /// Returns the help button
    var helpButton: UIButton

    /// Returns the question label
    var questionLabel: UILabel

    /// Returns the counter label of the current question from the total number of questions
    var questionCounterLabel: UILabel

    /// Returns the answer label of the current question with percent
    var percentsAnswersLabel: UILabel

    /// Returns the answer label parent view
    var percentsLabelView: UIView

    var answerTopStackView: UIStackView

    var answerBottomStackView: UIStackView

    // MARK: - Private properties

    /// Returns the names of image for hints buttons
    private let hintButtonsImageNames = ["fiftyFiftyHint", "auditoryHelpHint", "friendsCallHint"]
    private let hintButtonsGrayImageNames = ["fiftyFiftyHintGray", "auditoryHelpHintGray", "friendsCallHintGray"]

    /// Returns the configured stack view template
    private var horizontalStackViewTemplate: UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 10.0
        stackView.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }

    /// Returns the configured answer button template
    private var answerButtonTemplate: UIButton {
        let button = UIButton(type: .system)
        button.setTitle(" ", for: .normal)
        button.backgroundColor = .systemBlue
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.numberOfLines = 0
        button.setTitleColor(.systemBackground, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.addTarget(self, action: #selector(self.answerButtonTapped), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }

    /// Returns the configured hint button template
    private var hintButtonTemplate: UIButton {
        let button = UIButton(type: .system)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }

    /// Returns the configured label template
    private var labelTemplate: UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        label.contentMode = .left
        label.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }

    // MARK: - Constructions

    init() {
        self.answerButtons = [UIButton]()
        self.hintButtons = [UIButton]()
        self.exitButton = UIButton()
        self.helpButton = UIButton()
        self.questionLabel = UILabel()
        self.questionCounterLabel = UILabel()
        self.percentsAnswersLabel = UILabel()
        self.percentsLabelView = UIView()
        self.answerTopStackView = UIStackView()
        self.answerBottomStackView = UIStackView()

        super.init(frame: .zero)

        self.configureViewComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        guard self.answerButtons.first?.titleLabel?.text != " " else { return }

        self.percentsLabelView.layer.cornerRadius = self.percentsLabelView.frame.height / 2
        self.percentsLabelView.layer.borderWidth = 1
        self.percentsLabelView.layer.borderColor = UIColor(named: "hintLabelColor")?.cgColor

        self.updateAnswerButtons()
    }

    // MARK: - Functions

    /// Configures label with the current question counter
    ///
    /// - Parameters:
    ///     - questionNumber: Number of the current question
    ///     - totalQuestion: The number of all questions
    func questionCounterLabelConfigure(with value: (questionNumber: Int, totalQuestion: Int)) {
        self.questionCounterLabel.text = "Вопрос \(value.questionNumber + 1) из \(value.totalQuestion)"
    }

    /// Configures the answer button by its index with an empty value
    ///
    /// - Parameters:
    ///     - index: The number of the button to be reset
    func answerButtonCofigure(by index: Int) {
        self.answerButtons[index].setTitle(" ", for: .normal)
    }

    /// Configures the percents answers label
    ///g
    /// - Parameters:
    ///     - text: The text of the answers with percents
    func percentAnswerLabelCofigure(with text: String) {
        self.percentsAnswersLabel.text = text
    }

    // MARK: - Private functions

    /// Configuration of all view cell components
    private func configureViewComponents() {
        self.backgroundColor = UIColor(named: "LaunchBackgroundColor")//.systemBackground

        // Create three stack view from template

        let hintButtonsStackView = self.horizontalStackViewTemplate
        self.answerTopStackView = self.horizontalStackViewTemplate
        self.answerBottomStackView = self.horizontalStackViewTemplate

        // Configure exit and help buttons

        self.exitButton = self.hintButtonTemplate
        self.exitButton.setBackgroundImage(UIImage(named: "exit"), for: .normal)
        self.exitButton.addTarget(self, action: #selector(self.exitButtonTapped), for: .touchUpInside)

        self.helpButton = self.hintButtonTemplate
        self.helpButton.setBackgroundImage(UIImage(named: "help"), for: .normal)
        self.helpButton.addTarget(self, action: #selector(self.helpButtonTapped), for: .touchUpInside)

        // Configure hint buttons and add to stack view

        self.hintButtonsImageNames.enumerated().forEach { (index, buttonImage) in
            let hintButton = self.hintButtonTemplate
            hintButton.setBackgroundImage(UIImage(named: buttonImage), for: .normal)
            hintButton.tag = index
            hintButton.addTarget(self, action: #selector(self.hintButtonsTapped), for: .touchUpInside)

            self.hintButtons.append(hintButton)
            hintButtonsStackView.addArrangedSubview(hintButton)
        }

        // Configure question label

        self.questionLabel = self.labelTemplate
        self.questionLabel.textColor = UIColor(named: "helpTextColor")

        // Configure percent answer label and its view

        self.percentsAnswersLabel = self.labelTemplate
        self.percentsAnswersLabel.textColor = .label
        self.percentsAnswersLabel.backgroundColor = UIColor(named: "hintLabelColor")

        self.percentsLabelView = UIView()
        self.percentsLabelView.clipsToBounds = true
        self.percentsLabelView.isHidden = true
        self.percentsLabelView.backgroundColor = UIColor(named: "hintLabelColor")
        self.percentsLabelView.translatesAutoresizingMaskIntoConstraints = false
        self.percentsLabelView.addSubview(self.percentsAnswersLabel)

        // Create answer buttons

        for step in 0..<4 {
            let answerButton = self.answerButtonTemplate
            answerButton.setTitle(" ", for: .normal)
            self.answerButtons.append(answerButton)

            if step < 2 {
                answerTopStackView.addArrangedSubview(answerButton)
            } else {
                answerBottomStackView.addArrangedSubview(answerButton)
            }
        }

        // Configure question counter label

        self.questionCounterLabel.textAlignment = .center
        self.questionCounterLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        self.questionCounterLabel.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        self.questionCounterLabel.textColor = UIColor(named: "helpTextColor")
        self.questionCounterLabel.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews to game view

        self.addSubview(self.exitButton)
        self.addSubview(self.helpButton)
        self.addSubview(hintButtonsStackView)
        self.addSubview(self.questionLabel)
        self.addSubview(answerTopStackView)
        self.addSubview(answerBottomStackView)
        self.addSubview(self.questionCounterLabel)
        self.addSubview(self.percentsLabelView)

        // Create constraints

        self.hintButtons.forEach { hintButton in
            hintButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
            hintButton.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        }

        NSLayoutConstraint.activate([

            // Hint buttons stack view

            hintButtonsStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            hintButtonsStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),

            // Help button

            self.helpButton.heightAnchor.constraint(equalToConstant: 32.0),
            self.helpButton.widthAnchor.constraint(equalToConstant: 32.0),
            self.helpButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            self.helpButton.centerYAnchor.constraint(equalTo: hintButtonsStackView.centerYAnchor),

            // Exit button

            self.exitButton.heightAnchor.constraint(equalToConstant: 32.0),
            self.exitButton.widthAnchor.constraint(equalToConstant: 32.0),
            self.exitButton.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            self.exitButton.centerYAnchor.constraint(equalTo: hintButtonsStackView.centerYAnchor),

            // Percent answer label

            self.percentsAnswersLabel.leadingAnchor.constraint(equalTo: self.percentsLabelView.leadingAnchor,
                                                               constant: 30),
            self.percentsAnswersLabel.trailingAnchor.constraint(equalTo: self.percentsLabelView.trailingAnchor,
                                                                constant: -30),
            self.percentsAnswersLabel.topAnchor.constraint(equalTo: self.percentsLabelView.topAnchor, constant: 10),
            self.percentsAnswersLabel.bottomAnchor.constraint(equalTo: self.percentsLabelView.bottomAnchor,
                                                              constant: -10),

            self.percentsLabelView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.percentsLabelView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.percentsLabelView.topAnchor.constraint(equalTo: hintButtonsStackView.bottomAnchor, constant: 20),

            // Question label

            self.questionLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            self.questionLabel.topAnchor.constraint(greaterThanOrEqualTo: hintButtonsStackView.bottomAnchor,
                                               constant: 50),
            self.questionLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            self.questionLabel.bottomAnchor.constraint(equalTo: self.centerYAnchor, constant: -25),

            // Answer buttons top stack view

            answerTopStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                         constant: -10),
            answerTopStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            answerTopStackView.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 25),

            // Answer buttons bottom stack view

            answerBottomStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                                                            constant: -10),
            answerBottomStackView.topAnchor.constraint(equalTo: answerTopStackView.bottomAnchor, constant: 10),
            answerBottomStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                                                           constant: 10),

            // Answer buttons

//            self.answerButtons[0].widthAnchor.constraint(equalTo: self.answerButtons[1].widthAnchor),
//            self.answerButtons[2].widthAnchor.constraint(equalTo: self.answerButtons[3].widthAnchor),

            // Question counter label

            self.questionCounterLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            self.questionCounterLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    /// Update size of answer buttons
    private func updateAnswerButtons() {
        let maxHeightButton = self.answerButtons.max {
            $0.titleLabel?.frame.height ?? 0 < $1.titleLabel?.frame.height ?? 0
        }

        guard let maxHeight = maxHeightButton?.titleLabel?.frame.height else { return }

        if maxHeight >= maxHeightButton?.frame.height ?? 0 {

            self.answerButtons.forEach { button in
                let newSize = CGSize(width: button.layer.frame.width, height: maxHeight)

                button.layer.frame = CGRect(origin: button.layer.frame.origin, size: newSize)
                button.layer.cornerRadius = button.layer.frame.height / 2
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.systemBlue.cgColor
            }

            let topSize = CGSize(width: self.answerTopStackView.layer.frame.width, height: maxHeight)
            let topOrigin = self.answerTopStackView.layer.frame.origin
            self.answerTopStackView.layer.frame = CGRect(origin: topOrigin, size: topSize)

            let topFrame = self.answerTopStackView.layer.frame
            let newBottomYPoint = topFrame.origin.y + topFrame.height + 10
            let bottomSize = CGSize(width: self.answerBottomStackView.layer.frame.width, height: maxHeight)
            let bottomOrigin = CGPoint(x: self.answerBottomStackView.layer.frame.origin.x, y: newBottomYPoint)
            self.answerBottomStackView.layer.frame = CGRect(origin: bottomOrigin, size: bottomSize)

        } else {
            self.answerButtons.forEach { button in
                button.layer.cornerRadius = button.layer.frame.height / 2
            }
        }

    }

    /// The action that occurs when you tap on one of the answer buttons
    @objc private func answerButtonTapped(_ sender: UIButton) {
        self.delegate?.answerButtonTapped(with: sender.titleLabel?.text ?? "")
    }

    /// The action that occurs when you tap on the exit button
    @objc private func exitButtonTapped() {
        self.delegate?.gameExit()
    }

    /// The action that occurs when you tap on the help button
    @objc private func helpButtonTapped() {
        self.delegate?.helpButtonTapped()
    }

    /// The action that occurs when you tap on the hint buttons
    @objc private func hintButtonsTapped(_ sender: UIButton) {
        sender.isEnabled = false
        sender.setBackgroundImage(UIImage(named: hintButtonsGrayImageNames[sender.tag]), for: .normal)

        self.delegate?.hintButtonsTapped(with: sender.tag)
    }
}
