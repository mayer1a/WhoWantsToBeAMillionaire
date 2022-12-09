//
//  ScoreTableView.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 05.12.2022.
//

import UIKit

protocol ScoreTableViewDelegate: AnyObject {
    
    func clearScoreTableButtonTapped()
}

class ScoreTableView: UITableView {

    // MARK: - Properties

    weak var scoreTableButtonDelegate: ScoreTableViewDelegate?
    var clearScoreTableButton: UIBarButtonItem
    
    // MARK: - Constructions

    init() {
        clearScoreTableButton = UIBarButtonItem()

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

        let coverImageView = UIImageView()
        coverImageView.image = UIImage(named: "cover")
        coverImageView.contentMode = .scaleAspectFit
        coverImageView.translatesAutoresizingMaskIntoConstraints = false

        let tableImageHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 150))
        tableImageHeaderView.backgroundColor = UIColor(red: 0.0156863, green: 0.0156863, blue: 0.266667, alpha: 1)
        tableImageHeaderView.addSubview(coverImageView)

        tableHeaderView = tableImageHeaderView

        clearScoreTableButton.title = "Очистить таблицу"
        clearScoreTableButton.style = .plain
        clearScoreTableButton.target = self
        clearScoreTableButton.action = #selector(clearScoreButtonTapped)
        
        guard let headerView = tableHeaderView else { return }

        NSLayoutConstraint.activate([
            headerView.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            headerView.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            headerView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor)
        ])
    }

    @objc private func clearScoreButtonTapped() {
        scoreTableButtonDelegate?.clearScoreTableButtonTapped()
    }
}
