//
//  ScoreTableView.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 05.12.2022.
//

import UIKit

/// The methods that an object adopts to manage data and clear cells for a table view
protocol ScoreTableViewDelegate: AnyObject {

    /// Clears score records data and updates the table
    func clearScoreTableButtonTapped()
}

/// An object that is responsible for displaying cells with data about user scores
class ScoreTableView: UITableView {

    // MARK: - Properties

    /// Delegate responsible for calling the method to clear score data and reload the table view
    weak var scoreTableButtonDelegate: ScoreTableViewDelegate?

    /// Returns button for clearing score data and reloading the table
    var clearScoreTableButton: UIBarButtonItem
    
    // MARK: - Constructions

    init() {
        self.clearScoreTableButton = UIBarButtonItem()

        super.init(frame: .zero, style: .insetGrouped)

        self.configureViewComponents()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private functions

    /// Configuration of all view cell components
    private func configureViewComponents() {

        // Configure table view

        self.separatorStyle = .none
        self.backgroundColor = UIColor(named: "LaunchBackgroundColor")
        self.sectionIndexBackgroundColor = UIColor(named: "LaunchBackgroundColor")
        self.allowsSelection = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false

        // Configure table header view

        let coverImageView = UIImageView()
        coverImageView.image = UIImage(named: "cover")
        coverImageView.contentMode = .scaleAspectFit
        coverImageView.translatesAutoresizingMaskIntoConstraints = false

        let tableImageHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 150))
        tableImageHeaderView.backgroundColor = UIColor(red: 0.0156863, green: 0.0156863, blue: 0.266667, alpha: 1)
        tableImageHeaderView.addSubview(coverImageView)

        self.tableHeaderView = tableImageHeaderView
        
        // Configure clear scoretable bar button

        self.clearScoreTableButton.title = "Очистить таблицу"
        self.clearScoreTableButton.style = .plain
        self.clearScoreTableButton.target = self
        self.clearScoreTableButton.action = #selector(self.clearScoreButtonTapped)

        // Create constraints
        
        guard let headerView = tableHeaderView else { return }

        NSLayoutConstraint.activate([
            headerView.trailingAnchor.constraint(equalTo: coverImageView.trailingAnchor),
            headerView.leadingAnchor.constraint(equalTo: coverImageView.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: coverImageView.topAnchor),
            headerView.bottomAnchor.constraint(equalTo: coverImageView.bottomAnchor)
        ])
    }

    /// The action that occurs when you click on the button to clear the table from score records
    @objc private func clearScoreButtonTapped() {
        self.scoreTableButtonDelegate?.clearScoreTableButtonTapped()
    }
}
