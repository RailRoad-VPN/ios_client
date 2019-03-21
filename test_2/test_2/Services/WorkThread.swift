//
// Created by beop on 3/14/19.
// Copyright (c) 2019 beop. All rights reserved.
//

import Foundation
import UIKit

class WorkThread {

    public static let shared = WorkThread()

    let queue1 = DispatchQueue(label: "check_user")

    private init() {

    }

    func backgroundIskUserValid(once: Bool = false) {
        print_f(#file, #function, "backgroundIskUserValid")
        self.queue1.async {
            while true {
                var isUserOk: Bool = true
                var alertMessage: String?
                do {
                    try UserAPIService.shared.receiveUser(uuid: UserAPIService.shared.user.getUuid()!)
                } catch {
                    print_f(#file, #function, "receiveUser error. I will try next time")
                }
                if ((UserAPIService.shared.user.getIsEnabled() ?? false) == false) {
                    print_f(#file, #function, "backgroundIskUserValid. user is disabled")
                    isUserOk = false
                    alertMessage = "Your user is disabled"
                } else if ((UserAPIService.shared.user.getIsExpired() ?? false) == true) {
                    print_f(#file, #function, "backgroundIskUserValid. user is expired")
                    isUserOk = false
                    alertMessage = "Your subscription is expired"
                } else if ((UserAPIService.shared.user.getIsLocked() ?? false) == true) {
                    print_f(#file, #function, "backgroundIskUserValid. user is locked")
                    isUserOk = false
                    alertMessage = "Your user is locked"
                }

                var isUserDeviceOk: Bool = true
                do {
                    try UserAPIService.shared.receiveUserDeviceByUUID()
                } catch ErrorsEnum.userAPIServiceUserDeviceNotFound {
                    isUserDeviceOk = false
                    alertMessage = "Your device has been deleted"
                } catch {
                    print_f(#file, #function, "receiveUserDeviceByUUID error. I will try next time")
                }

                if (UserAPIService.shared.user.getUserDevice()?.getIsActive() == false) {
                    isUserDeviceOk = false
                    alertMessage = "Your user device has been deactivated"
                }


                if !isUserOk || !isUserDeviceOk {

                    let alert = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style {
                        case .default:
                            print("default")

                        case .cancel:
                            print("cancel")

                        case .destructive:
                            print("destructive")


                        }
                    }))

                    self.disconnectVPN()

                    DispatchQueue.main.async {

                        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
                        let topMostVC: UIViewController? = rootViewController?.presentedViewController
                        topMostVC!.present(alert, animated: true, completion: nil)
                        if !isUserDeviceOk {
                            do {
                                try CacheMetaService.shared.clearSettings()
                            } catch {
                                print_f(#file, #function, "clearSettings() error")
                            }
                            topMostVC!.navigationController!.setViewControllers([PinViewController()], animated: true)
                        }
                    }

                }

                if (once) {
                    return
                }
                DispatchSemaphore(value: 0).wait(timeout: DispatchTime.now() + 5.0)
            }
        }
    }

    func disconnectVPN() {
        self.queue1.async(qos: .userInteractive) {
            VPNService.shared.disconnect()
            let connection = Connection.init()
            if connection.uuid != nil {
                do {
                    try UserAPIService.shared.updateConnection(connectionUUID: connection.uuid!, serverUuid: connection.serverUUID!, bytes_i: 0, bytes_o: 0, isConnected: false)
                } catch ErrorsEnum.VPNServiceSystemError {

                } catch {

                }
            }
        }
    }
}
