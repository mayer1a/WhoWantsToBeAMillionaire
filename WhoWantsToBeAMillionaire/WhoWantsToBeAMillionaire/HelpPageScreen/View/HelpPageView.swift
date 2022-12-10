//
//  HelpPageView.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 06.12.2022.
//

import UIKit

final class HelpPageView: UIView {

    // MARK: - Properties

    var rulesLabel: UILabel

    // MARK: - Constructions

    init() {
        rulesLabel = UILabel()

        super.init(frame: .zero)

        configureViewComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

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

        rulesLabel.text = "\(text)\n\nОБЩИЕ ПРАВИЛА\n\n\(commonRules)\(hintsText)"
        rulesLabel.sizeToFit()
    }

    // MARK: - Private functions

    private func configureViewComponents() {
        backgroundColor = UIColor(named: "LaunchBackgroundColor")

        rulesLabel.textColor = UIColor(named: "helpTextColor")
        rulesLabel.textAlignment = .natural
        rulesLabel.numberOfLines = 0
        rulesLabel.lineBreakMode = .byWordWrapping
        rulesLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        rulesLabel.contentMode = .left
        rulesLabel.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        rulesLabel.translatesAutoresizingMaskIntoConstraints = false

        let contentView = UIView()
        contentView.backgroundColor = backgroundColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rulesLabel)

        let scrollView = UIScrollView()
        scrollView.backgroundColor = backgroundColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        addSubview(scrollView)

        NSLayoutConstraint.activate([
            rulesLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            rulesLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
            rulesLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            rulesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            scrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}

// MARK: - Extensions

extension HelpPageView {

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
