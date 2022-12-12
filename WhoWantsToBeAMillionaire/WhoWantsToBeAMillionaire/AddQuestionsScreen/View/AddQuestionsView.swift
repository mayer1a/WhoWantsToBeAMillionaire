//
//  AddQuestionsView.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 11.12.2022.
//

import UIKit

protocol AddQuestionsTableViewDelegate: AnyObject {

    func addCellButtonTapped()
    func addQuestionsButtonTapped()
}

final class AddQuestionsView: UITableView {

    // MARK: - Properties

    weak var addQuestionsDelegate: AddQuestionsTableViewDelegate?
    var addQuestionsBarButton: UIBarButtonItem

    // MARK: - Private properties

    private var addButton: UIButton

    // MARK: - Constructions

    init() {
        addButton = UIButton(type: .system)
        addQuestionsBarButton = UIBarButtonItem()
        
        super.init(frame: .zero, style: .insetGrouped)

        configureViewComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private functions

    private func configureViewComponents() {
        separatorStyle = .none
        backgroundColor = UIColor(named: "LaunchBackgroundColor")
        sectionIndexBackgroundColor = UIColor(named: "LaunchBackgroundColor")
        allowsSelection = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false

        addQuestionsBarButton.title = "Добавить вопросы"
        addQuestionsBarButton.style = .plain
        addQuestionsBarButton.target = self
        addQuestionsBarButton.action = #selector(addQuestionsButtonTapped(_:))
        addQuestionsBarButton.isEnabled = false

        addButton.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        addButton.setBackgroundImage(UIImage(named: "addCell"), for: .normal)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.addTarget(self, action: #selector(addCellButtonTapped), for: .touchUpInside)

        let tableButtonFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 60))
        tableButtonFooterView.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        tableButtonFooterView.addSubview(addButton)

        tableFooterView = tableButtonFooterView

        addSubview(tableButtonFooterView)

        guard let footerView = tableFooterView else { return }

        NSLayoutConstraint.activate([
            footerView.topAnchor.constraint(equalTo: addButton.topAnchor),
            footerView.bottomAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 10),
            footerView.centerXAnchor.constraint(equalTo: addButton.centerXAnchor)
        ])
    }

    @objc func addQuestionsButtonTapped(_ sender: UIButton) {
        addQuestionsDelegate?.addQuestionsButtonTapped()
    }

    @objc func addCellButtonTapped(_ sender: UIBarButtonItem) {
        addQuestionsDelegate?.addCellButtonTapped()
    }

}
