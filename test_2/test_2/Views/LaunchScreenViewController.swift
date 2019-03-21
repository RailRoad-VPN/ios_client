//
// Created by beop on 3/5/19.
// Copyright (c) 2019 beop. All rights reserved.
//

import Foundation
import UIKit

class LaunchScreenViewController: UIViewController {
    var progressBar = UIView()
    var progressBarHeight: CGFloat = 8

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)


    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        imageView.image = UIImage(named: "launchImage")
        imageView.contentMode = .scaleToFill

        self.view.addSubview(imageView)


        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        self.progressBar = UIView(frame: CGRect.init(x: 0, y: screenHeight - self.progressBarHeight, width: 0, height: self.progressBarHeight))
        self.progressBar.backgroundColor = UIColor.yellowRailRoad
        self.view.addSubview(self.progressBar)

        let queue = DispatchQueue.global(qos: .utility)
        queue.async {

            while self.progressBar.frame.size.width < screenWidth {
                DispatchSemaphore.init(value: 0).wait(timeout: DispatchTime.now() + 0.02)

                DispatchQueue.main.async {
                    self.progressBar.frame.size.width = self.progressBar.frame.size.width + CGFloat(arc4random_uniform(40) + 10)
                    print("progress bar update")
                }
            }
            DispatchQueue.main.async {
                let user = UserAPIService.shared.user
                if user.getUserDevice() == nil || user.getUserDevice()?.getToken() == nil {
                    self.present(PinViewController(), animated: true)
                } else {
                    let navigationController = RailRoadNavigationController.init(rootViewController: TabViewController())
                    self.present(navigationController, animated: true)
                }
            }
        }
    }

}
