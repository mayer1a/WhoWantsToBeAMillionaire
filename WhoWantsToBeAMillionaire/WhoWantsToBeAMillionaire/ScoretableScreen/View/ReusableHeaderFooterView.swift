//
//  ReusableHeaderFooterView.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 05.12.2022.
//

import UIKit

// An object-stub to control the height of the section header and footer
final class ReusableHeaderFooterView: UITableViewHeaderFooterView {

    // MARK: - Properties

    /// Returns the reusable header footer indentifier for scoreboard table view
    static let headerFooterId: String = "HeaderFooterView"

    // MARK: - Constructions

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        contentView.addSubview(UIView())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
