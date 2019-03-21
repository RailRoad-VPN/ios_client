//
// Created by beop on 3/10/19.
// Copyright (c) 2019 beop. All rights reserved.
//

import Foundation
import UIKit

class SupportViewController: UIViewController, UINavigationControllerDelegate {

    var textInputView = UITextView()
    var label = UILabel()

    override
    func viewDidLoad() {
        super.viewDidLoad()
        print_f(#file, #function, "init support window")

        let height: CGFloat = getNavBarHeight()
        let statusBarHeight = UIApplication.shared.statusBarFrame.height;
        let navbar = UINavigationBar(frame: CGRect(x: 0, y: statusBarHeight, width: UIScreen.main.bounds.width, height: height))
        navbar.backgroundColor = UIColor.greyRailRoad
        navbar.delegate = self as? UINavigationBarDelegate

        self.view.backgroundColor = UIColor.greyRailRoad

        let navItem = UINavigationItem()
        navItem.title = NSLocalizedString("support", comment: "Support")
        navItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("cancel", comment: "Cancel"), style: .plain, target: self, action: #selector(dismissViewController))
        navItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("send", comment: "Send"), style: .plain, target: self, action: #selector(sendLetter))

        navbar.items = [navItem]

        self.view.addSubview(navbar)

        self.view?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height - height))

        self.label.text = NSLocalizedString("describe_your_problem", comment: "Please, describe your problem. We will answer you at") + " " + UserAPIService.shared.user.getEmail()!
        self.label.backgroundColor = UIColor.greyRailRoad
        self.label.textColor = UIColor.gray
        self.label.frame = CGRect(x: 20, y: height + statusBarHeight + 5, width: UIScreen.main.bounds.width - 40, height: CGFloat.pi)
        self.label.numberOfLines = 0
        self.label.sizeToFit()
        self.view.addSubview(self.label)

        let labelHeight = self.label.frame.height + 5

        self.textInputView.frame = CGRect(x: 10, y: height + statusBarHeight + labelHeight, width: UIScreen.main.bounds.width - 20, height: (UIScreen.main.bounds.height / 3))
        self.textInputView.backgroundColor = UIColor.greyRailRoad
        self.textInputView.textColor = UIColor.white
        self.textInputView.becomeFirstResponder()
        self.textInputView.font = .systemFont(ofSize: CGFloat(16))
        self.view.addSubview(self.textInputView)

    }

    func getNavBarHeight() -> CGFloat {
        let nav = UINavigationController()
        print(nav.navigationBar.frame.size.height)
        return nav.navigationBar.frame.size.height
    }

    @objc
    private func dismissViewController() {
        print_f(#file, #function, "dismiss support window")
        self.dismiss(animated: true)
    }

    @objc
    private func sendLetter() {

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try UserAPIService.shared.createTicket(description: self.textInputView.text)
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            } catch {

            }
        }
    }
}
