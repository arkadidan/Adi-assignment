//
//  Coordinator.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import UIKit

final class Coordinator {

    var navController: UINavigationController
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    init(window: UIWindow) {
        self.navController = window.rootViewController as! UINavigationController
    }

    func start() {
        self.showProductList()
    }

    func showProductList() {
        let viewModel = ProductListVM()
        let vc = self.storyboard.instantiateViewController(type: ProductListVC.self)
        vc.viewModel = viewModel
        vc.onOpenProduct = { [weak self] product in
            self?.showProduct(product)
        }
    }

    func showProduct(_ product: Product) {

    }
}
