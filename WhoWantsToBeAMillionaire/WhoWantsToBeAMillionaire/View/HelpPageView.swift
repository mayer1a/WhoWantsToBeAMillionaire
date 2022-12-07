//
//  HelpPageView.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 06.12.2022.
//

import UIKit

/// An object that is responsible for the visual component of the help page view
final class HelpPageView: UIView {

    // MARK: - Properties

    /// Returns a label of common rules and available hints
    var rulesLabel: UILabel

    // MARK: - Constructions

    init() {
        self.rulesLabel = UILabel()

        super.init(frame: .zero)

        self.configureViewComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    /// Configures a label with the results of common rules and available hints description
    ///
    /// - Parameters:
    ///     - gameInfo: The game session for available hints
    ///     - hints: Array of hint descriptions
    func rulesLabelConfugure(with gameInfo: GameSession, _ hints: [String]?) {
        guard var hints = hints else { return }

        var text = "Следующие ниже подсказки доступны в текущей игровой сессии\n\n"
        let hintsText = "• \(hints.removeFirst())\n\n• \(hints.removeFirst())\n\n• \(hints.removeFirst())"

        gameInfo.hintsAvailable.enumerated().forEach { (index, hint) in
            text.append("\t• ")

            switch hint {
                case .fiftyFifty:
                    text.append("«50 на 50»\n")
                case .auditoryHelp:
                    text.append("«Помощь зала»\n")
                case .callFriend:
                    text.append("«Звонок другу»\n")
            }
        }

        self.rulesLabel.text = "\(text)\n\nОБЩИЕ ПРАВИЛА\n\n\(self.commonRules)\(hintsText)"
        self.rulesLabel.sizeToFit()
    }

    // MARK: - Private functions

    /// Configuration of all view cell components
    private func configureViewComponents() {
        self.backgroundColor = UIColor(named: "LaunchBackgroundColor")

        // Configures common rules label

        self.rulesLabel.textColor = UIColor(named: "helpTextColor")
        self.rulesLabel.textAlignment = .natural
        self.rulesLabel.numberOfLines = 0
        self.rulesLabel.lineBreakMode = .byWordWrapping
        self.rulesLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        self.rulesLabel.contentMode = .left
        self.rulesLabel.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        self.rulesLabel.translatesAutoresizingMaskIntoConstraints = false

        // Configures the scroll view to correctly display a large amount of text

        let contentView = UIView()
        contentView.backgroundColor = self.backgroundColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(self.rulesLabel)

        let scrollView = UIScrollView()
        scrollView.backgroundColor = self.backgroundColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        self.addSubview(scrollView)

        // Configures constraints

        NSLayoutConstraint.activate([
            self.rulesLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            self.rulesLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
            self.rulesLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            self.rulesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            scrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: self.widthAnchor),
            scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),

            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}

// MARK: - Extensions

extension HelpPageView {

    /// Returns the large text of common rules and available hints description
    var commonRules: String {
        """
        Игра «Кто хочет стать миллионером?» - это конкурс викторина, в котором участник должен правильно ответить на ряд вопросов с несколькими вариантами ответов, чтобы перейти на следующий уровень. Всего 10 вопросов, каждый вопрос стоит определенной суммы денег, участник не имеит никаких временных ограничений для предоставления ответа. Участники также получают три вида подсказок, чтобы помочь себе, если они застряли на конкретном вопросе.

        

        ВОПРОСЫ

        Вопросы «Кто хочет стать миллионером?» структурированы в соответствии с тремя различными уровнями, причем уровень сложности постепенно увеличивается. Каждый уровень содержит три-четыре вопроса. Вопросы, сгруппированные на одном уровне, будут иметь одинаковую сложность.

        Если участник неправильно отвечает на вопрос с первой несгораемой суммой, то он уходит ни с чем. Если на этот вопрос дан правильный ответ, участнику гарантируется первая несгораемая сумма в 8000 рублей, даже если даст неверный ответ до достижения следующей несгораемой суммы в седьмом вопросе.

        Если участник неправильно отвечает на вопрос со второй несгораемой суммой, то он уходит с первой несгораемой суммой.

        Участникам разрешается применить три подсказки, которые они могут использовать в любой момент викторины. Каждая из подсказок может быть использована только один раз.


        ПОДСКАЗКИ


        """
    }
}
