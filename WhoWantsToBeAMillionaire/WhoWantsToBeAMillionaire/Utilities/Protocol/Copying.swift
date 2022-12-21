//
//  Copying.swift
//  WhoWantsToBeAMillionaire
//
//  Created by Artem Mayer on 21.12.2022.
//

import Foundation

protocol Copying {

    // MARK: - Construction

    init(_ prototype: Self)
}

extension Copying {

    // MARK: - Functions

    func getCopy() -> Self {
        return type(of: self).init(self)
    }
}
