//
//  Extensions.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import UIKit

extension UIViewController {

    func presentErrorAlert(error: Error) {
        let message: String
        if let userError = error as? UserError {
            message = userError.userMessage
        } else {
            message = error.localizedDescription
        }
        self.presentErrorAlert(message: message)
    }

    func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }

    static var storyboardId: String {
        return String(describing: self)
    }
}

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(type: T.Type) -> T {
        return self.instantiateViewController(withIdentifier: type.storyboardId) as! T
    }
}

extension UITableView {
    func dequeue<T: UITableViewCell>(_ cellType: T.Type) -> T {
        return self.dequeueReusableCell(withIdentifier: cellType.identifier) as! T
    }
}

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
