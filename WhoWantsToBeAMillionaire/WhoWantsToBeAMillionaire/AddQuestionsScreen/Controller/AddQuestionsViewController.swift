//
//  AddQuestionsViewController.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 11.12.2022.
//

import UIKit

final class AddQuestionsViewController: UIViewController {

    // MARK: - Private properties

    private var questionsSectionsNumber: Int = 1

    private var addQuestionsView: AddQuestionsView? {
        return isViewLoaded ? view as? AddQuestionsView : nil
    }

    private var addedQuestions = {
        var questions = [Int : String]()

        questions[0] = ""

        return questions
    }()

    private var addedAnswers = {
        var answers = [Int : [String]]()

        answers[0] = ["", "", "", "", ""]

        return answers
    }()

    // MARK: - Lifecycle

    override func loadView() {
        self.view = AddQuestionsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addQuestionsView?.addQuestionsDelegate = self

        addQuestionsView?.delegate = self
        addQuestionsView?.dataSource = self
        addQuestionsView?.register(AddQuestionTableViewCell.self, forCellReuseIdentifier: AddQuestionTableViewCell.cellId)
        addQuestionsView?.register(ReusableHeaderFooterView.self,
                                   forHeaderFooterViewReuseIdentifier: ReusableHeaderFooterView.headerFooterId)
        
        navigationItem.rightBarButtonItem = addQuestionsView?.addQuestionsBarButton
        navigationController?.navigationBar.topItem?.backButtonTitle = "Назад"
        navigationController?.isNavigationBarHidden = false
    }

    // MARK: - Private functions

    @objc private func textFieldEditingChanged(_ sender: UITextField) {
        if sender.text?.first == " " {
            sender.text = ""
            navigationItem.rightBarButtonItem?.isEnabled = false

            return
        }

        guard let sectionsNumber = addQuestionsView?.numberOfSections else { return }

        for section in 0..<sectionsNumber {
            let indexPath = IndexPath(row: 0, section: section)

            guard
                let cell = addQuestionsView?.cellForRow(at: indexPath) as? AddQuestionTableViewCell,
                cell.questionTextField.text?.isEmpty == false
            else {
                navigationItem.rightBarButtonItem?.isEnabled = false

                return
            }

            if cell.layer.borderColor == UIColor.systemRed.cgColor {
                cell.textFieldDefaultConfigure()
            }

            for textField in cell.answersTextFields {
                if textField.text?.isEmpty == true {
                    navigationItem.rightBarButtonItem?.isEnabled = false

                    return
                }
            }
        }

        navigationItem.rightBarButtonItem?.isEnabled = true
    }

    @objc private func textFieldEditingDidEnd(_ sender: UITextField) {
        guard
            sender.text?.isEmpty == false,
            let originY = sender.superview?.superview?.frame.origin.y
        else {
            return
        }

        let touchPoint = CGPoint(x: sender.center.x, y: sender.center.y + originY)

        guard
            let senderIndexPath = addQuestionsView?.indexPathForRow(at: touchPoint),
            let cell = addQuestionsView?.cellForRow(at: senderIndexPath) as? AddQuestionTableViewCell
        else {
            return
        }

        var answers = [String]()

        for answerTextField in cell.answersTextFields {
            answers.append(answerTextField.text ?? "")
        }

        addedAnswers[senderIndexPath.section] = answers
        addedQuestions[senderIndexPath.section] = cell.questionTextField.text
    }
}

extension AddQuestionsViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return questionsSectionsNumber
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Вопрос №\(section + 1)"
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableHeaderFooterView.headerFooterId)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reusableCell = tableView.dequeueReusableCell(withIdentifier: AddQuestionTableViewCell.cellId, for: indexPath)

        guard let cell = reusableCell as? AddQuestionTableViewCell else { return UITableViewCell() }

        cell.questionTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        cell.questionTextField.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        cell.answersTextFields.forEach {
            $0.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
            $0.addTarget(self, action: #selector(textFieldEditingDidEnd(_:)), for: .editingDidEnd)
        }

        cell.questionTextField.text = addedQuestions[indexPath.section]

        cell.answersTextFields.enumerated().forEach { [weak self] (offset, textField) in
            textField.text = self?.addedAnswers[indexPath.section]?[offset]
        }

        return cell
    }
}

extension AddQuestionsViewController: AddQuestionsTableViewDelegate {

    func addCellButtonTapped() {
        questionsSectionsNumber += 1

        addedQuestions[questionsSectionsNumber - 1] = ""
        addedAnswers[questionsSectionsNumber - 1] = ["", "", "", "", ""]

        let indexSet = IndexSet(integer: questionsSectionsNumber - 1)
        let indexPathToScroll = IndexPath(row: 0, section: questionsSectionsNumber - 1)

        addQuestionsView?.beginUpdates()
        addQuestionsView?.insertSections(indexSet, with: .automatic)
        addQuestionsView?.endUpdates()

        addQuestionsView?.scrollToRow(at: indexPathToScroll, at: .top, animated: true)

        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    func addQuestionsButtonTapped() {
        let cell = addQuestionsView?.cellForRow(at: IndexPath(row: 0, section: 0)) as? AddQuestionTableViewCell

        if cell?.questionTextField.isFirstResponder == false {
            cell?.questionTextField.becomeFirstResponder()
        } else {
            cell?.questionTextField.resignFirstResponder()
        }

        for sectionNumber in 0..<questionsSectionsNumber {
            let question = addedQuestions[sectionNumber]
            var answers = [String : Int]()
            let correctAnswer = addedAnswers[sectionNumber]?.removeLast()
            var percents = 100

            addedAnswers[sectionNumber]?.enumerated().forEach {
                let answerPercent = Int.random(in: 0...percents)

                if $0.offset == 3 {
                    answers[$0.element] = percents
                    return
                }

                answers[$0.element] = answerPercent

                percents -= answerPercent
            }

            if answers.count < 4 {
                cell?.textFieldDuplicateValuesConfigure()

                addedAnswers[sectionNumber] = addedAnswers[sectionNumber]?.compactMap { answer in
                    String()
                }

                return
            }

            if let question = question, let correctAnswer = correctAnswer {
                print(Question(text: question, answers: answers, correctAnswer: correctAnswer))
            }
        }
    }
}
