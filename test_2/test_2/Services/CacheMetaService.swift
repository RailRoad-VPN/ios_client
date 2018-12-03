//
// Created by beop on 12/15/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let refreshTableView = Notification.Name("refreshTableView")
}

class CacheMetaService: RESTService {

    static let shared = CacheMetaService()

    var dir = FileManager.default.urls(for: .applicationDirectory, in: .userDomainMask).first!
    let fileManager = FileManager.default
    var generalMeta: Meta?




// TODO mess with link here
    let url = GlobalSettings.getServiceURL(serviceName: "vpns/servers/meta")

    override
    private init() {
        let fileManager = FileManager.default
        let dir = fileManager.urls(for: .applicationDirectory, in: .userDomainMask).first!
        super.init()
        self.generalMeta = readMeta(fromFile: FilesEnum.meta.rawValue)
        var isDir : ObjCBool = false
        if !(fileManager.fileExists(atPath: dir.path, isDirectory: &isDir)) {
            do {
                try fileManager.createDirectory(atPath: dir.path, withIntermediateDirectories: false)
            } catch {
                print("CacheMetaService cannot create directory")
            }
        }
    }



    func save(any: Any, toFile: String) {
        print("CacheMetaService save anything to file \(toFile) enter")
        // Path to save array data

        let fileURL = self.dir.appendingPathComponent(toFile)
        let path = URL(fileURLWithPath: fileURL.path)

        print("path is: \(path)")
        // write to file 2
        let data = NSKeyedArchiver.archivedData(withRootObject: any)

        if !(fileManager.fileExists(atPath: path.path)) {
            if !(fileManager.createFile(atPath: path.path, contents: data)){
                print("FILE WASNT CREATED")
            }
        } else {
            try! data.write(to: path, options: .atomic)
        }

        print("CacheMetaService save anything exit")
    }

    func readAny(fromFile: String) -> Any? {
        print("CacheMetaService readAny from file \(fromFile) enter")

        let fileURL = self.dir.appendingPathComponent(fromFile)
        let any = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path) as Any

        print("CacheMetaService readAny from file exit")
        return any
    }

    func readServersArray(fromFile: String) -> [Server]? {
        print("CacheMetaService read servers array from file: \(fromFile) enter")
        let fileURL = self.dir.appendingPathComponent(fromFile)

        let array = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path) as? [Server]

        print("reading servers:")
        print(array)
        print("CacheMetaService read servers array exit")
        return array
    }

    func readMeta(fromFile: String) -> Meta? {
        print("CacheMetaService read meta from file: \(fromFile) enter")
        let fileURL = self.dir.appendingPathComponent(fromFile)

        let meta = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path) as? Meta

        print("reading meta:")
        print(meta?.version)
        print(meta?.condition_version)
        print("CacheMetaService read servers array exit")
        return meta
    }

    func readDictArray(fromFile: String) -> [[String: Any]]? {
        print("CacheMetaService read dict array from file: \(fromFile) enter")
        let fileURL = self.dir.appendingPathComponent(fromFile)

        let dict = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path) as? [[String: Any]]

        print("CacheMetaService read dict array exit")
        return dict
    }

    func readDict(fromFile: String) -> [String: Any]? {
        print("CacheMetaService read dict from file \(fromFile) enter")
        let fileURL = self.dir.appendingPathComponent(fromFile)
        let dict = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path) as? [String: Any]

        print("CacheMetaService read dict exit")
        return dict
    }


    func backgroundUpdateCheckGlobalMeta(once: Bool = false) {
        print("background self.updateRequestVPNServers init")
        DispatchQueue.global(qos: .background).async {

            while true {
                print("background self.updateRequestVPNServers enter")
                var remoteGeneralMeta = Meta(version: 0, condition: 0)
                do {
                    remoteGeneralMeta = try self.getGeneralMeta()
                } catch {
                    print("background updateRequestVPNServers error, i will try next time")
                }

                if self.isGeneralMetaOld(remoteGeneralMeta: remoteGeneralMeta) {

                    do {
                        let us = UserAPIService()
                        try self.save(any: us.getVPNServers(), toFile: FilesEnum.vpnServers.rawValue)
                        self.setGeneralMetaCached(remoteGeneralMeta: remoteGeneralMeta)
                        NotificationCenter.default.post(name: .refreshTableView, object: nil)
                        print("background self.updateRequestVPNServers exit. Meta is old")
                    } catch {
                        print("background updateRequestVPNServers error, i will try next time")
                    }
                } else {
                    print("background self.updateRequestVPNServers exit. Meta is up to date")
                }
                if (once) {
                    return
                }
                DispatchSemaphore(value: 0).wait(timeout: DispatchTime.now() + 20.0)
            }
        }
    }

    func isGeneralMetaOld(remoteGeneralMeta: Meta) -> Bool {

        if generalMeta == nil {
            return true
        } else {
            if (generalMeta?.version != remoteGeneralMeta.version && generalMeta?.condition_version != remoteGeneralMeta.condition_version) {
                return true
            } else {
                return false
            }
        }
    }

    func setGeneralMetaCached(remoteGeneralMeta: Meta) {
        self.generalMeta = remoteGeneralMeta
        self.save(any: self.generalMeta as Any, toFile: FilesEnum.meta.rawValue)
    }

    func getGeneralMeta() throws -> Meta {

        print("getGeneralMeta enter")

        var response = RESTResponse()

        response = get(url: url, headers: nil)

        let dict = response.data
        if response.isSuccess && dict != nil {
            do {
                let meta = try Meta(dictionary: dict!)
                print("getGeneralMeta end")
                return meta
            } catch ErrorsEnum.absentMetaProperty {
                print("throw metaCacheServiceSystemError")
                throw ErrorsEnum.metaCacheServiceSystemError
            }

        } else if (response.statusCode == nil && response.errorMessage != nil) {
            throw ErrorsEnum.metaCacheServiceConnectionProblem
        } else {
            print("throw metaCacheServiceSystemError")
            throw ErrorsEnum.metaCacheServiceSystemError
        }
    }
}
