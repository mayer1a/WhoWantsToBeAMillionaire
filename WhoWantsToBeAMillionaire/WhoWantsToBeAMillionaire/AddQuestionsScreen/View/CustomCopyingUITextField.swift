//
//  CustomCopyingUITextField.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 21.12.2022.
//

import UIKit

final class CustomCopyingUITextField: UITextField {

    // MARK: - Constructions

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init(_ prototype: CustomCopyingUITextField) {
        super.init(frame: prototype.frame)

        self.removeConstraints(self.constraints)
        self.textAlignment = prototype.textAlignment
        self.font = prototype.font
        self.textColor = prototype.textColor
        self.backgroundColor = prototype.backgroundColor
        self.borderStyle = prototype.borderStyle
        self.clearButtonMode = prototype.clearButtonMode
        self.minimumFontSize = prototype.minimumFontSize
        self.autocorrectionType = prototype.autocorrectionType
        self.spellCheckingType = prototype.spellCheckingType
        self.translatesAutoresizingMaskIntoConstraints = prototype.translatesAutoresizingMaskIntoConstraints
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Extensions

extension CustomCopyingUITextField: Copying { }
