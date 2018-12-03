//
// Created by beop on 12/15/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation

class Server: NSObject, NSCoding {
    var uuid: String?
    var num: Int?
    var bandwidth: Int?
    var condition_version: Int?
    var load: Int?
    var status_id: Int?
    var type_id: Int?
    var version: Int?
    var city_id: Int?
    var city_name: String?
    var country_code: Int?
    var country_name: String?
    var country_str_code: String?
    var latitude: String?
    var longitude: String?
    var region_common: Int?
    var region_dvd: Int?
    var region_nintendo: Int?
    var region_playstation3: Int?
    var region_playstation4: Int?
    var region_xbox360: Int?
    var region_xboxone: Int?
    var state_code: Int?
    var state_name: String?

    init(dictionary: [String: Any]) {
        self.uuid = dictionary["uuid"] as? String
        self.num = dictionary["num"] as? Int
        self.bandwidth = dictionary["bandwidth"] as? Int
        self.condition_version = dictionary["condition_version"] as? Int
        self.load = dictionary["load"] as? Int
        self.status_id = dictionary["status_id"] as? Int
        self.type_id = dictionary["type_id"] as? Int
        self.version = dictionary["version"] as? Int


        let geo = dictionary["geo"] as? [String: Any]

        let cityDict = geo?["city"] as? [String: Any]
        self.city_id = cityDict?["id"] as? Int
        self.city_name = cityDict?["name"] as? String

        let counrtyDict = geo?["country"] as? [String: Any]
        self.country_code = counrtyDict?["code"] as? Int
        self.country_name = counrtyDict?["name"] as? String
        self.country_str_code = counrtyDict?["str_code"] as? String

        self.latitude = geo?["latitude"] as? String
        self.longitude = geo?["longitude"] as? String
        self.region_common = geo?["region_common"] as? Int
        self.region_dvd = geo?["region_dvd"] as? Int
        self.region_nintendo = geo?["region_nintendo"] as? Int
        self.region_playstation3 = geo?["region_playstation3"] as? Int
        self.region_playstation4 = geo?["region_playstation4"] as? Int
        self.region_xbox360 = geo?["region_xbox360"] as? Int
        self.region_xboxone = geo?["region_xboxone"] as? Int

        let state = geo?["state"] as? [String: Any]
        self.state_code = state?["code"] as? Int
        self.state_name = state?["name"] as? String

        super.init()
    }

    required public init(coder aDecoder: NSCoder) {
        self.uuid = aDecoder.decodeObject(forKey: "uuid") as? String
        self.num = aDecoder.decodeObject(forKey: "num") as? Int
        self.bandwidth = aDecoder.decodeObject(forKey: "bandwidth") as? Int
        self.condition_version = aDecoder.decodeObject(forKey: "condition_version") as? Int
        self.load = aDecoder.decodeObject(forKey: "load") as? Int
        self.status_id = aDecoder.decodeObject(forKey: "status_id") as? Int
        self.type_id = aDecoder.decodeObject(forKey: "type_id") as? Int
        self.version = aDecoder.decodeObject(forKey: "version") as? Int
        self.city_id = aDecoder.decodeObject(forKey: "city_id") as? Int
        self.city_name = aDecoder.decodeObject(forKey: "city_name") as? String
        self.country_code = aDecoder.decodeObject(forKey: "country_code") as? Int
        self.country_name = aDecoder.decodeObject(forKey: "country_name") as? String
        self.country_str_code = aDecoder.decodeObject(forKey: "country_str_code") as? String
        self.latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        self.longitude = aDecoder.decodeObject(forKey: "longitude") as? String
        self.region_common = aDecoder.decodeObject(forKey: "region_common") as? Int
        self.region_dvd = aDecoder.decodeObject(forKey: "region_dvd") as? Int
        self.region_nintendo = aDecoder.decodeObject(forKey: "region_nintendo") as? Int
        self.region_playstation3 = aDecoder.decodeObject(forKey: "region_playstation3") as? Int
        self.region_playstation4 = aDecoder.decodeObject(forKey: "region_playstation4") as? Int
        self.region_xbox360 = aDecoder.decodeObject(forKey: "region_xbox360") as? Int
        self.region_xboxone = aDecoder.decodeObject(forKey: "region_xboxone") as? Int
        self.state_code = aDecoder.decodeObject(forKey: "state_code") as? Int
        self.state_name = aDecoder.decodeObject(forKey: "state_name") as? String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(uuid, forKey: "uuid")
        aCoder.encode(num, forKey: "num")
        aCoder.encode(bandwidth, forKey: "bandwidth")
        aCoder.encode(condition_version, forKey: "condition_version")
        aCoder.encode(load, forKey: "load")
        aCoder.encode(status_id, forKey: "status_id")
        aCoder.encode(type_id, forKey: "type_id")
        aCoder.encode(version, forKey: "version")
        aCoder.encode(city_id, forKey: "city_id")
        aCoder.encode(city_name, forKey: "city_name")
        aCoder.encode(country_code, forKey: "country_code")
        aCoder.encode(country_name, forKey: "country_name")
        aCoder.encode(country_str_code, forKey: "country_str_code")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(region_common, forKey: "region_common")
        aCoder.encode(region_dvd, forKey: "region_dvd")
        aCoder.encode(region_nintendo, forKey: "region_nintendo")
        aCoder.encode(region_playstation3, forKey: "region_playstation3")
        aCoder.encode(region_playstation4, forKey: "region_playstation4")
        aCoder.encode(region_xbox360, forKey: "region_xbox360")
        aCoder.encode(region_xboxone, forKey: "region_xboxone")
        aCoder.encode(state_code, forKey: "state_code")
        aCoder.encode(state_code, forKey: "state_name")
    }
}
