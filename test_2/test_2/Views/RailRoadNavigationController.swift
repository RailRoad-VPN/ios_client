//
// Created by beop on 6/10/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import UIKit
import Foundation

class RailRoadNavigationController: UINavigationController {

    override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }

    override public init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        self.navigationBar.topItem!.title = NSLocalizedString("railroad_vpn", comment: "RailRoad VPN")
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.isTranslucent = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
