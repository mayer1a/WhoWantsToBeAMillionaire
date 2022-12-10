//
//  ReusableHeaderFooterView.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 05.12.2022.
//

import UIKit

final class ReusableHeaderFooterView: UITableViewHeaderFooterView {

    // MARK: - Properties

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
