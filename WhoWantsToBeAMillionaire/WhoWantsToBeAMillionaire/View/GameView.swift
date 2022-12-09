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
        answerButtons = [UIButton]()
        hintButtons = [UIButton]()
        exitButton = UIButton()
        helpButton = UIButton()
        questionLabel = UILabel()
        questionCounterLabel = UILabel()
        percentsAnswersLabel = UILabel()
        percentsLabelView = UIView()
        answerTopStackView = UIStackView()
        answerBottomStackView = UIStackView()

        super.init(frame: .zero)

        configureViewComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        guard answerButtons.first?.titleLabel?.text != " " else { return }

        percentsLabelView.layer.cornerRadius = percentsLabelView.frame.height / 2
        percentsLabelView.layer.borderWidth = 1
        percentsLabelView.layer.borderColor = UIColor(named: "hintLabelColor")?.cgColor

        updateAnswerButtons()
    }

    // MARK: - Functions

    /// Configures label with the current question counter
    ///
    /// - Parameters:
    ///     - questionNumber: Number of the current question
    ///     - totalQuestion: The number of all questions
    func questionCounterLabelConfigure(with value: (questionNumber: Int, totalQuestion: Int)) {
        questionCounterLabel.text = "Вопрос \(value.questionNumber + 1) из \(value.totalQuestion)"
    }

    /// Configures the answer button by its index with an empty value
    ///
    /// - Parameters:
    ///     - index: The number of the button to be reset
    func answerButtonCofigure(by index: Int) {
        answerButtons[index].setTitle(" ", for: .normal)
    }

    /// Configures the percents answers label
    ///
    /// - Parameters:
    ///     - text: The text of the answers with percents
    func percentAnswerLabelCofigure(with text: String) {
        percentsAnswersLabel.text = text
    }

    // MARK: - Private functions

    /// Configuration of all view cell components
    private func configureViewComponents() {
        backgroundColor = UIColor(named: "LaunchBackgroundColor")//.systemBackground

        // Create three stack view from template

        let hintButtonsStackView = horizontalStackViewTemplate
        answerTopStackView = horizontalStackViewTemplate
        answerBottomStackView = horizontalStackViewTemplate

        // Configure exit and help buttons

        exitButton = hintButtonTemplate
        exitButton.setBackgroundImage(UIImage(named: "exit"), for: .normal)
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)

        helpButton = hintButtonTemplate
        helpButton.setBackgroundImage(UIImage(named: "help"), for: .normal)
        helpButton.addTarget(self, action: #selector(helpButtonTapped), for: .touchUpInside)

        // Configure hint buttons and add to stack view

        hintButtonsImageNames.enumerated().forEach { (index, buttonImage) in
            let hintButton = hintButtonTemplate
            hintButton.setBackgroundImage(UIImage(named: buttonImage), for: .normal)
            hintButton.tag = index
            hintButton.addTarget(self, action: #selector(hintButtonsTapped), for: .touchUpInside)

            hintButtons.append(hintButton)
            hintButtonsStackView.addArrangedSubview(hintButton)
        }

        // Configure question label

        questionLabel = labelTemplate
        questionLabel.textColor = UIColor(named: "helpTextColor")

        // Configure percent answer label and its view

        percentsAnswersLabel = labelTemplate
        percentsAnswersLabel.textColor = .label
        percentsAnswersLabel.backgroundColor = UIColor(named: "hintLabelColor")

        percentsLabelView = UIView()
        percentsLabelView.clipsToBounds = true
        percentsLabelView.isHidden = true
        percentsLabelView.backgroundColor = UIColor(named: "hintLabelColor")
        percentsLabelView.translatesAutoresizingMaskIntoConstraints = false
        percentsLabelView.addSubview(percentsAnswersLabel)

        // Create answer buttons

        for step in 0..<4 {
            let answerButton = answerButtonTemplate
            answerButton.setTitle(" ", for: .normal)
            answerButtons.append(answerButton)

            if step < 2 {
                answerTopStackView.addArrangedSubview(answerButton)
            } else {
                answerBottomStackView.addArrangedSubview(answerButton)
            }
        }

        // Configure question counter label

        questionCounterLabel.textAlignment = .center
        questionCounterLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        questionCounterLabel.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        questionCounterLabel.textColor = UIColor(named: "helpTextColor")
        questionCounterLabel.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews to game view

        addSubview(exitButton)
        addSubview(helpButton)
        addSubview(hintButtonsStackView)
        addSubview(questionLabel)
        addSubview(answerTopStackView)
        addSubview(answerBottomStackView)
        addSubview(questionCounterLabel)
        addSubview(percentsLabelView)

        // Create constraints

        hintButtons.forEach { hintButton in
            hintButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
            hintButton.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        }

        NSLayoutConstraint.activate([

            // Hint buttons stack view

            hintButtonsStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            hintButtonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),

            // Help button

            helpButton.heightAnchor.constraint(equalToConstant: 32.0),
            helpButton.widthAnchor.constraint(equalToConstant: 32.0),
            helpButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            helpButton.centerYAnchor.constraint(equalTo: hintButtonsStackView.centerYAnchor),

            // Exit button

            exitButton.heightAnchor.constraint(equalToConstant: 32.0),
            exitButton.widthAnchor.constraint(equalToConstant: 32.0),
            exitButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            exitButton.centerYAnchor.constraint(equalTo: hintButtonsStackView.centerYAnchor),

            // Percent answer label

            percentsAnswersLabel.leadingAnchor.constraint(equalTo: percentsLabelView.leadingAnchor,
                                                               constant: 30),
            percentsAnswersLabel.trailingAnchor.constraint(equalTo: percentsLabelView.trailingAnchor,
                                                                constant: -30),
            percentsAnswersLabel.topAnchor.constraint(equalTo: percentsLabelView.topAnchor, constant: 10),
            percentsAnswersLabel.bottomAnchor.constraint(equalTo: percentsLabelView.bottomAnchor,
                                                              constant: -10),

            percentsLabelView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            percentsLabelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            percentsLabelView.topAnchor.constraint(equalTo: hintButtonsStackView.bottomAnchor, constant: 20),

            // Question label

            questionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            questionLabel.topAnchor.constraint(greaterThanOrEqualTo: hintButtonsStackView.bottomAnchor,
                                               constant: 50),
            questionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            questionLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -25),

            // Answer buttons top stack view

            answerTopStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                         constant: -10),
            answerTopStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            answerTopStackView.topAnchor.constraint(equalTo: centerYAnchor, constant: 25),

            // Answer buttons bottom stack view

            answerBottomStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor,
                                                            constant: -10),
            answerBottomStackView.topAnchor.constraint(equalTo: answerTopStackView.bottomAnchor, constant: 10),
            answerBottomStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor,
                                                           constant: 10),

            // Answer buttons

//            self.answerButtons[0].widthAnchor.constraint(equalTo: self.answerButtons[1].widthAnchor),
//            self.answerButtons[2].widthAnchor.constraint(equalTo: self.answerButtons[3].widthAnchor),

            // Question counter label

            questionCounterLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            questionCounterLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    /// Update size of answer buttons
    private func updateAnswerButtons() {
        let maxHeightButton = answerButtons.max {
            $0.titleLabel?.frame.height ?? 0 < $1.titleLabel?.frame.height ?? 0
        }

        guard let maxHeight = maxHeightButton?.titleLabel?.frame.height else { return }

        if maxHeight >= maxHeightButton?.frame.height ?? 0 {

            answerButtons.forEach { button in
                let newSize = CGSize(width: button.layer.frame.width, height: maxHeight)

                button.layer.frame = CGRect(origin: button.layer.frame.origin, size: newSize)
                button.layer.cornerRadius = button.layer.frame.height / 2
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.systemBlue.cgColor
            }

            let topSize = CGSize(width: answerTopStackView.layer.frame.width, height: maxHeight)
            let topOrigin = answerTopStackView.layer.frame.origin
            answerTopStackView.layer.frame = CGRect(origin: topOrigin, size: topSize)

            let topFrame = answerTopStackView.layer.frame
            let newBottomYPoint = topFrame.origin.y + topFrame.height + 10
            let bottomSize = CGSize(width: answerBottomStackView.layer.frame.width, height: maxHeight)
            let bottomOrigin = CGPoint(x: answerBottomStackView.layer.frame.origin.x, y: newBottomYPoint)
            answerBottomStackView.layer.frame = CGRect(origin: bottomOrigin, size: bottomSize)

        } else {
            answerButtons.forEach { button in
                button.layer.cornerRadius = button.layer.frame.height / 2
            }
        }

    }

    /// The action that occurs when you tap on one of the answer buttons
    @objc private func answerButtonTapped(_ sender: UIButton) {
        delegate?.answerButtonTapped(with: sender.titleLabel?.text ?? "")
    }

    /// The action that occurs when you tap on the exit button
    @objc private func exitButtonTapped() {
        delegate?.gameExit()
    }

    /// The action that occurs when you tap on the help button
    @objc private func helpButtonTapped() {
        delegate?.helpButtonTapped()
    }

    /// The action that occurs when you tap on the hint buttons
    @objc private func hintButtonsTapped(_ sender: UIButton) {
        sender.isEnabled = false
        sender.setBackgroundImage(UIImage(named: hintButtonsGrayImageNames[sender.tag]), for: .normal)

        delegate?.hintButtonsTapped(with: sender.tag)
    }
}
