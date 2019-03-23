//
// Created by beop on 12/13/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation

class VPNService {

    public static let shared = VPNService()

    private var isVPNOn: Bool
    private var VPNStatus: VPNStatesEnum

    private init() {
// todo check if vpn is active
        print_f(#file, #function, "VPNService init enter")
        self.isVPNOn = false
        self.VPNStatus = VPNStatesEnum.OFF
        print_f(#file, #function, "VPNService init exit")
    }

    func setIsVPNOn(isVPNOn: Bool) {
        self.isVPNOn = isVPNOn
    }

    func setVPNStatus(VPNStatus: VPNStatesEnum) {
        self.VPNStatus = VPNStatus
    }

    func getIsVPNOn() -> Bool {
        return self.isVPNOn
    }

    func getVPNStatus() -> VPNStatesEnum {
        return self.VPNStatus
    }

    func connect(base64Config: String) throws {
        print_f(#file, #function, "VPNService connect by base64 config enter")
        var config = ""
        do {
            config = try UtilityService.decodeBase64(string: base64Config)
        } catch ErrorsEnum.utilityServiceUnableToDecodeBase64 {
            print_f(#file, #function, "cant decode config")
            throw ErrorsEnum.VPNServiceSystemError
        }

        self.connect(config: config)
        print_f(#file, #function, "VPNService connect by base64 config exit")
    }

    func connect(config: String) {
        print_f(#file, #function, "VPNService connect enter")
        print_f(#file, #function, "connecting...")
        NotificationCenter.default.post(name: .VPNServiceWorkInProgress, object: nil)
        DispatchSemaphore.init(value: 0).wait(timeout: .now() + 3)
        NotificationCenter.default.post(name: Notification.Name.VPNConnected, object: nil)
        self.isVPNOn = true
        self.VPNStatus = VPNStatesEnum.ON
        print_f(#file, #function, "VPNService connect exit")
    }

    func disconnect() {
        print_f(#file, #function, "VPNService disconnect enter")
        print_f(#file, #function, "disconnecting...")
        NotificationCenter.default.post(name: Notification.Name.VPNServiceWorkInProgress, object: nil)
        DispatchSemaphore.init(value: 0).wait(timeout: .now() + 3)
        self.isVPNOn = false
        self.VPNStatus = VPNStatesEnum.OFF
        NotificationCenter.default.post(name: Notification.Name.VPNDisconnected, object: nil)
        print_f(#file, #function, "VPNService disconnect exit")
    }

}
