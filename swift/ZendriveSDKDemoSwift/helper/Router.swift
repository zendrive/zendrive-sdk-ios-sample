//
//  Router.swift
//  ZendriveSDKDemoSwift
//
//  Created by amrit on 16/07/19.
//  Copyright © 2019 zendrive. All rights reserved.
//
//class to support changing viewController
import Foundation
import UIKit

final class Router {

    func present(storyBoardName: String, viewControllerId: String, presenter: UIViewController, navigation: Bool) {
        var navigationController : UINavigationController?
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: viewControllerId)
        if navigation {
            navigationController = UINavigationController(rootViewController: controller)
        }
        presenter.present(navigationController ?? controller, animated: true, completion: nil)
    }
}
