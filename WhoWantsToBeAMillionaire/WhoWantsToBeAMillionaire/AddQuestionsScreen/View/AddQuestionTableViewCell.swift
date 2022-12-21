//
//  AddQuestionTableViewCell.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 11.12.2022.
//

import UIKit

final class AddQuestionTableViewCell: UITableViewCell {

    // MARK: - Properties

    static let cellId = "QuestionsTableCell"

    var questionTextField: CustomCopyingUITextField = {
        let textField = CustomCopyingUITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 44))
        textField.textAlignment = .left
        textField.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        textField.textColor = UIColor(named: "helpTextColor")
        textField.backgroundColor = .tertiaryLabel
        textField.borderStyle = .roundedRect
        textField.clearButtonMode = .whileEditing
        textField.minimumFontSize = 20.0
        textField.autocorrectionType = .yes
        textField.spellCheckingType = .yes
        textField.translatesAutoresizingMaskIntoConstraints = false

        return textField
    }()

    var answersTextFields: [CustomCopyingUITextField]

    // MARK: - Construction

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        answersTextFields = [CustomCopyingUITextField]()

        super.init(style: .value1, reuseIdentifier: reuseIdentifier)

        configureViewComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()

        questionTextField.text = String()
        answersTextFields.forEach({ $0.text = String() })
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor(named: "hintLabelColor")?.cgColor
    }

    // MARK: - Function

    func textFieldDuplicateValuesConfigure() {
        answersTextFields.forEach { textField in
            textField.text = ""
            textField.placeholder = "Ответы не могут повторяться"
        }

        layer.borderColor = UIColor.systemRed.cgColor
    }

    func textFieldDefaultConfigure() {
        answersTextFields.enumerated().forEach { (offset, textField) in
            textField.placeholder = "Вариант ответа №\(offset + 1) ..."
        }

        layer.borderColor = UIColor(named: "hintLabelColor")?.cgColor
    }

    // MARK: - Private functions

    private func configureViewComponents() {
        selectionStyle = .gray
        contentView.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        backgroundColor = UIColor(named: "LaunchBackgroundColor")
        contentMode = .center
        accessoryType = .none
        editingAccessoryType = .none

        contentView.addSubview(questionTextField)

        for buttonNumber in 0..<5 {
            let answerTextField = questionTextField.getCopy()

            contentView.addSubview(answerTextField)

            answersTextFields.append(answerTextField)

            switch buttonNumber {
                case 4:
                    answerTextField.placeholder = "Введите правильный ответ ..."

                    createButtonConstraints(with: buttonNumber)
                default:
                    answerTextField.placeholder = "Вариант ответа №\(buttonNumber + 1) ..."

                    createButtonConstraints(with: buttonNumber)
            }
        }

        let attributes = [NSAttributedString.Key.foregroundColor : UIColor(named: "helpTextColor") ?? UIColor.black]
        let attributedString = NSAttributedString(string: "Введите вопрос ...", attributes: attributes)

        questionTextField.attributedPlaceholder = attributedString

        NSLayoutConstraint.activate([
            questionTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            questionTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            questionTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
    }

    private func createButtonConstraints(with index: Int) {
        let currentButton = answersTextFields[index]

        if index == 0 {
            NSLayoutConstraint.activate([
                currentButton.topAnchor.constraint(equalTo: questionTextField.bottomAnchor, constant: 0),
                currentButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                currentButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])

            return
        }

        if index == 4 {
            NSLayoutConstraint.activate([
                currentButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
            ])
        }

        let previousButton = answersTextFields[index - 1]

        NSLayoutConstraint.activate([
            currentButton.topAnchor.constraint(equalTo: previousButton.bottomAnchor, constant: 0),
            currentButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            currentButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
