//
//  CustomCopyingUIButton.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 21.12.2022.
//

import UIKit

final class CustomCopyingUIButton: UIButton {

    // MARK: - Constructions

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(_ prototype: CustomCopyingUIButton) {
        super.init(frame: prototype.frame)

        self.titleLabel?.font = prototype.titleLabel?.font
        self.backgroundColor = prototype.backgroundColor
        self.translatesAutoresizingMaskIntoConstraints = prototype.translatesAutoresizingMaskIntoConstraints
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Extensions

extension CustomCopyingUIButton: Copying { }
