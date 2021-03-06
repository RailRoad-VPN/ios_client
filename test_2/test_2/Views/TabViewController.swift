//
// Created by beop on 12/15/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation
import UIKit

class TabViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.yellowRailRoad], for: .selected)
        self.tabBar.unselectedItemTintColor = UIColor.white
        self.tabBar.selectedImageTintColor = UIColor.yellowRailRoad

        let mainViewController = MainViewController()
        let vpnTab = UIImage(named: "VPNTab")!
        mainViewController.tabBarItem = UITabBarItem(title: nil, image: vpnTab.withRenderingMode(.alwaysOriginal),
                selectedImage: vpnTab
        )

        let serversListViewController = ServersListViewController()
        let serverListTab = UIImage(named: "serversListTab")!
        serversListViewController.tabBarItem = UITabBarItem(title: nil, image: serverListTab.withRenderingMode(.alwaysOriginal),
                selectedImage: serverListTab
        )

        let settingsViewController = SettingsListViewController()
        let settingsTab = UIImage(named: "settingsTab")!
        settingsViewController.tabBarItem = UITabBarItem(title: nil, image: settingsTab.withRenderingMode(.alwaysOriginal),
                selectedImage: settingsTab
        )
        let tabBarList = [mainViewController, serversListViewController, settingsViewController]

        self.tabBar.barTintColor = UIColor.black
        self.viewControllers = tabBarList
        print_f(#file, #function, "tabbar controller wtf?")
    }
}