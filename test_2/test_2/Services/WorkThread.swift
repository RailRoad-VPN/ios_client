//
// Created by beop on 3/14/19.
// Copyright (c) 2019 beop. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    static let refreshTableView = Notification.Name("refreshTableView")
    static let VPNServiceWorkInProgress = Notification.Name("VPNWorkIsInProgress")
    static let VPNConnected = Notification.Name("VPNConnected")
    static let VPNDisconnected = Notification.Name("VPNDisconnected")
}

class WorkThread {

    public static let shared = WorkThread()

    let queue1 = DispatchQueue(label: "check_user")
    let queue2 = DispatchQueue(label: "concurrent", attributes: .concurrent)

    private init() {

    }

    func backgroundIskUserValid(once: Bool = false) {
        print_f(#file, #function, "backgroundIskUserValid")
        self.queue1.async {
            while true {
                var isUserOk: Bool = true
                var alertMessage: String?
                var user: User?
                do {
                    user = try UserAPIService.shared.receiveUser(uuid: UserAPIService.shared.user.getUuid()!)
                } catch {
                    print_f(#file, #function, "receiveUser error. I will try next time")
                }
                if ((user?.getIsEnabled() ?? false) == false) {
                    print_f(#file, #function, "backgroundIskUserValid. user is disabled")
                    isUserOk = false
                    UserAPIService.shared.user.setIsEnabled(isEnabled: false)
                    alertMessage = "Your user is disabled"
                } else if ((user?.getIsExpired() ?? false) == true) {
                    print_f(#file, #function, "backgroundIskUserValid. user is expired")
                    isUserOk = false
                    UserAPIService.shared.user.setIsExpired(isExpired: true)
                    alertMessage = "Your subscription is expired"
                } else if ((user?.getIsLocked() ?? false) == true) {
                    print_f(#file, #function, "backgroundIskUserValid. user is locked")
                    UserAPIService.shared.user.setIsLocked(isLocked: true)
                    isUserOk = false
                    alertMessage = "Your user is locked"
                }

                var isUserDeviceOk: Bool = true
                var isUserDeviceDeleted: Bool = false
                var userDevice: UserDevice?
                do {
                    userDevice = try UserAPIService.shared.receiveUserDeviceByUUID()
                } catch ErrorsEnum.userAPIServiceUserDeviceNotFound {
                    isUserDeviceOk = false
                    isUserDeviceDeleted = true
                    alertMessage = "Your device has been deleted"
                } catch {
                    print_f(#file, #function, "receiveUserDeviceByUUID error. I will try next time")
                }

                if (userDevice?.getIsActive() == false) {
                    isUserDeviceOk = false
                    UserAPIService.shared.user.getUserDevice()?.setIsActive(isActive: false)
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

                    if VPNService.shared.getIsVPNOn() {
                        self.disconnectVPN()
                    }

                    DispatchQueue.main.async {

                        let rootViewController = UIApplication.shared.keyWindow?.rootViewController
                        var topMostVC = rootViewController?.presentedViewController
                        while topMostVC?.presentedViewController != nil {
                            topMostVC = topMostVC?.presentedViewController
                        }

                        if topMostVC is PinViewController || topMostVC is UIAlertController {
                            //do nothing
                        } else {
                            if !isUserDeviceOk && isUserDeviceDeleted {
                                do {
                                    try CacheMetaService.shared.clearSettings()
                                } catch {
                                    print_f(#file, #function, "clearSettings() error")
                                }

                                let pv = PinViewController()
                                if topMostVC is UINavigationController {
                                    let nv = topMostVC as? UINavigationController
                                    nv!.present(pv, animated: true)
                                    pv.present(alert, animated: true, completion: nil)
                                } else {
                                    topMostVC!.present(pv, animated: true)
                                    pv.present(alert, animated: true, completion: nil)
                                }
                            } else {
                                topMostVC!.present(alert, animated: true, completion: nil)
                            }
                        }
                    }

                }

                if (once) {
                    return
                }
                DispatchSemaphore(value: 0).wait(timeout: DispatchTime.now() + 15.0)
            }
        }
    }

    func disconnectVPN() {
        self.queue2.async(qos: .userInteractive) {
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
