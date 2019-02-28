//
// Created by beop on 12/25/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation

class Connection: NSObject, NSCoding {
    var uuid: String?
    var serverUUID: String?

    override init() {
        print_f(#file, #function, "init connection from file start")
        super.init()
        let connection = CacheMetaService.shared.readAny(fromFile: FilesEnum.currentConnection.rawValue) as? Connection
        self.uuid = connection?.uuid
        self.serverUUID = connection?.serverUUID
        print_f(#file, #function, "init connection from file end")

    }

    init(uuid: String, serverUUID: String) {
        self.uuid = uuid
        self.serverUUID = serverUUID
    }

    required public init(coder aDecoder: NSCoder) {
        uuid = aDecoder.decodeObject(forKey: "uuid") as? String
        serverUUID = aDecoder.decodeObject(forKey: "serverUUID") as? String
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(uuid, forKey: "uuid")
        aCoder.encode(serverUUID, forKey: "serverUUID")
    }
}
