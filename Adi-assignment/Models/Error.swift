//
//  Error.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import Foundation

protocol UserError {
    var userMessage: String { get }
}

struct HttpError: Error, UserError {
    var userMessage: String
}
