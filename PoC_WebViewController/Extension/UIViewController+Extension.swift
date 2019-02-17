//
//  ViewController+Extensions.swift
//  PoC_WebViewController
//
//  Created by satorun on 2019/02/16.
//  Copyright © 2019 satorun. All rights reserved.
//

import Foundation
import UIKit

protocol Instantiatable {}

extension Instantiatable where Self: UIViewController {
    static func instantiateFromStoryBoard(name: String = String(describing: Self.self)
        ) -> Self {
        return UIStoryboard(name: name, bundle: nil).instantiateInitialViewController() as! Self
    }
}
