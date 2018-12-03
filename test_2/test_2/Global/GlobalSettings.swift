//
// Created by beop on 6/26/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation

class GlobalSettings {
    public static let API_URL = "https://api.rroadvpn.net"
    private static let API_VER = "v1";
    public static let DEVICE_PLATFORM_ID = 3;
    public static let VPN_TYPE_ID = 1;


    public static func getServiceURL(serviceName: String) -> String {
        return API_URL + "/api/" + API_VER + "/" + serviceName;
    }
}