//
//  GameView.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 04.12.2022.
//

import UIKit

protocol GameViewDelegate: AnyObject {

    func answerButtonTapped(with playerAnswer: String)
    func gameExit()
    func helpButtonTapped()
    func hintButtonsTapped(with tag: Int)
}

final class GameView: UIView {
    
    // MARK: - Properties

    weak var delegate: GameViewDelegate?

    var answerButtons: [UIButton]

    var hintButtons: [UIButton]

    var exitButton: UIButton

    var helpButton: UIButton

    var questionLabel: UILabel

    var questionCounterLabel: UILabel

    var percentsAnswersLabel: UILabel

    var percentsLabelView: UIView

    var answerTopStackView: UIStackView

    var answerBottomStackView: UIStackView

    // MARK: - Private properties

    private let hintButtonsImageNames = ["fiftyFiftyHint", "auditoryHelpHint", "friendsCallHint"]
    private let hintButtonsGrayImageNames = ["fiftyFiftyHintGray", "auditoryHelpHintGray", "friendsCallHintGray"]

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

    private var hintButtonTemplate: UIButton {
        let button = UIButton(type: .system)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }

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

    func questionCounterLabelConfigure(with value: (questionNumber: Int, totalQuestion: Int)) {
        questionCounterLabel.text = "Вопрос \(value.questionNumber + 1) из \(value.totalQuestion)"
    }

    func answerButtonCofigure(by index: Int) {
        answerButtons[index].setTitle(" ", for: .normal)
    }

    func percentAnswerLabelCofigure(with text: String) {
        percentsAnswersLabel.text = text
    }

    // MARK: - Private functions

    private func configureViewComponents() {
        backgroundColor = UIColor(named: "LaunchBackgroundColor")

        let hintButtonsStackView = horizontalStackViewTemplate
        answerTopStackView = horizontalStackViewTemplate
        answerBottomStackView = horizontalStackViewTemplate

        exitButton = hintButtonTemplate
        exitButton.setBackgroundImage(UIImage(named: "exit"), for: .normal)
        exitButton.addTarget(self, action: #selector(exitButtonTapped), for: .touchUpInside)

        helpButton = hintButtonTemplate
        helpButton.setBackgroundImage(UIImage(named: "help"), for: .normal)
        helpButton.addTarget(self, action: #selector(helpButtonTapped), for: .touchUpInside)

        hintButtonsImageNames.enumerated().forEach { (index, buttonImage) in
            let hintButton = hintButtonTemplate
            hintButton.setBackgroundImage(UIImage(named: buttonImage), for: .normal)
            hintButton.tag = index
            hintButton.addTarget(self, action: #selector(hintButtonsTapped), for: .touchUpInside)

            hintButtons.append(hintButton)
            hintButtonsStackView.addArrangedSubview(hintButton)
        }

        questionLabel = labelTemplate
        questionLabel.textColor = UIColor(named: "helpTextColor")

        percentsAnswersLabel = labelTemplate
        percentsAnswersLabel.textColor = .label
        percentsAnswersLabel.backgroundColor = UIColor(named: "hintLabelColor")

        percentsLabelView = UIView()
        percentsLabelView.clipsToBounds = true
        percentsLabelView.isHidden = true
        percentsLabelView.backgroundColor = UIColor(named: "hintLabelColor")
        percentsLabelView.translatesAutoresizingMaskIntoConstraints = false
        percentsLabelView.addSubview(percentsAnswersLabel)

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

        questionCounterLabel.textAlignment = .center
        questionCounterLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        questionCounterLabel.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        questionCounterLabel.textColor = UIColor(named: "helpTextColor")
        questionCounterLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(exitButton)
        addSubview(helpButton)
        addSubview(hintButtonsStackView)
        addSubview(questionLabel)
        addSubview(answerTopStackView)
        addSubview(answerBottomStackView)
        addSubview(questionCounterLabel)
        addSubview(percentsLabelView)

        hintButtons.forEach { hintButton in
            hintButton.heightAnchor.constraint(equalToConstant: 50.0).isActive = true
            hintButton.widthAnchor.constraint(equalToConstant: 50.0).isActive = true
        }

        NSLayoutConstraint.activate([

            hintButtonsStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            hintButtonsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),

            helpButton.heightAnchor.constraint(equalToConstant: 32.0),
            helpButton.widthAnchor.constraint(equalToConstant: 32.0),
            helpButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            helpButton.centerYAnchor.constraint(equalTo: hintButtonsStackView.centerYAnchor),

            exitButton.heightAnchor.constraint(equalToConstant: 32.0),
            exitButton.widthAnchor.constraint(equalToConstant: 32.0),
            exitButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            exitButton.centerYAnchor.constraint(equalTo: hintButtonsStackView.centerYAnchor),

            percentsAnswersLabel.leadingAnchor.constraint(equalTo: percentsLabelView.leadingAnchor, constant: 30),
            percentsAnswersLabel.trailingAnchor.constraint(equalTo: percentsLabelView.trailingAnchor, constant: -30),
            percentsAnswersLabel.topAnchor.constraint(equalTo: percentsLabelView.topAnchor, constant: 10),
            percentsAnswersLabel.bottomAnchor.constraint(equalTo: percentsLabelView.bottomAnchor, constant: -10),

            percentsLabelView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            percentsLabelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            percentsLabelView.topAnchor.constraint(equalTo: hintButtonsStackView.bottomAnchor, constant: 20),

            questionLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            questionLabel.topAnchor.constraint(greaterThanOrEqualTo: hintButtonsStackView.bottomAnchor, constant: 50),
            questionLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            questionLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -25),

            answerTopStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            answerTopStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            answerTopStackView.topAnchor.constraint(equalTo: centerYAnchor, constant: 25),

            answerBottomStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -10),
            answerBottomStackView.topAnchor.constraint(equalTo: answerTopStackView.bottomAnchor, constant: 10),
            answerBottomStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),

            questionCounterLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            questionCounterLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

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

    @objc private func answerButtonTapped(_ sender: UIButton) {
        delegate?.answerButtonTapped(with: sender.titleLabel?.text ?? "")
    }

    @objc private func exitButtonTapped() {
        delegate?.gameExit()
    }

    @objc private func helpButtonTapped() {
        delegate?.helpButtonTapped()
    }

    @objc private func hintButtonsTapped(_ sender: UIButton) {
        sender.isEnabled = false
        sender.setBackgroundImage(UIImage(named: hintButtonsGrayImageNames[sender.tag]), for: .normal)

        delegate?.hintButtonsTapped(with: sender.tag)
    }
}
