//
// Created by beop on 12/13/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation

class VPNService {

    private var isVPNOn: Bool
    private var VPNStatus: VPNStatesEnum

    init() {
// todo check if vpn is active
        print("VPNService init enter")
        self.isVPNOn = false
        self.VPNStatus = VPNStatesEnum.OFF
        print("VPNService init exit")
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
        print("VPNService connect by base64 config enter")
        var config = ""
        do {
            config = try UtilityService.decodeBase64(string: base64Config)
        } catch ErrorsEnum.utilityServiceUnableToDecodeBase64 {
            print("cant decode config")
            throw ErrorsEnum.VPNServiceSystemError
        }

        self.connect(config: config)
        print("VPNService connect by base64 config exit")
    }

    func connect(config: String) {
        print("VPNService connect enter")
        print("connecting...")
        DispatchSemaphore.init(value: 0).wait(timeout: .now() + 3)
        self.isVPNOn = true
        self.VPNStatus = VPNStatesEnum.ON
        print("VPNService connect exit")
    }

    func disconnect() {
        print("VPNService disconnect enter")
        print("disconnecting...")
        DispatchSemaphore.init(value: 0).wait(timeout: .now() + 3)
        self.isVPNOn = false
        self.VPNStatus = VPNStatesEnum.OFF
        print("VPNService disconnect exit")
    }

}
