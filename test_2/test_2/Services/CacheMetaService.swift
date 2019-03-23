//
// Created by beop on 12/15/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation

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
        var isDir: ObjCBool = false
        if !(fileManager.fileExists(atPath: dir.path, isDirectory: &isDir)) {
            do {
                try fileManager.createDirectory(atPath: dir.path, withIntermediateDirectories: false)
            } catch {
                print_f(#file, #function, "CacheMetaService cannot create directory")
            }
        }
    }


    func save(any: Any, toFile: String) {
        print_f(#file, #function, "CacheMetaService save anything to file \(toFile) enter")
        // Path to save array data

        let fileURL = self.dir.appendingPathComponent(toFile)
        let path = URL(fileURLWithPath: fileURL.path)

        print_f(#file, #function, "path is: \(path)")
        // write to file 2
        let data = NSKeyedArchiver.archivedData(withRootObject: any)

        if !(fileManager.fileExists(atPath: path.path)) {
            if !(fileManager.createFile(atPath: path.path, contents: data)) {
                print_f(#file, #function, "FILE WASNT CREATED. I'm crashing")
                exit(100)
            }
        } else {
            try! data.write(to: path, options: .atomic)
        }

        print_f(#file, #function, "CacheMetaService save anything exit")
    }

    func readAny(fromFile: String) -> Any? {
        print_f(#file, #function, "CacheMetaService readAny from file \(fromFile) enter")

        let fileURL = self.dir.appendingPathComponent(fromFile)
        let any = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path) as Any

        print_f(#file, #function, "CacheMetaService readAny from file exit")
        return any
    }

    func readServersArray(fromFile: String) -> [Server]? {
        print_f(#file, #function, "CacheMetaService read servers array from file: \(fromFile) enter")
        let fileURL = self.dir.appendingPathComponent(fromFile)

        let array = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path) as? [Server]

        print_f(#file, #function, "reading servers:")
        print_f(#file, #function, array)
        print_f(#file, #function, "CacheMetaService read servers array exit")
        return array
    }

    func readMeta(fromFile: String) -> Meta? {
        print_f(#file, #function, "CacheMetaService read meta from file: \(fromFile) enter")
        let fileURL = self.dir.appendingPathComponent(fromFile)

        let meta = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path) as? Meta

        print_f(#file, #function, "reading meta:")
        print_f(#file, #function, meta?.version)
        print_f(#file, #function, meta?.condition_version)
        print_f(#file, #function, "CacheMetaService read servers array exit")
        return meta
    }

    func readDictArray(fromFile: String) -> [[String: Any]]? {
        print_f(#file, #function, "CacheMetaService read dict array from file: \(fromFile) enter")
        let fileURL = self.dir.appendingPathComponent(fromFile)

        let dict = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path) as? [[String: Any]]

        print_f(#file, #function, "CacheMetaService read dict array exit")
        return dict
    }

    func readDict(fromFile: String) -> [String: Any]? {
        print_f(#file, #function, "CacheMetaService read dict from file \(fromFile) enter")
        let fileURL = self.dir.appendingPathComponent(fromFile)
        let dict = NSKeyedUnarchiver.unarchiveObject(withFile: fileURL.path) as? [String: Any]

        print_f(#file, #function, "CacheMetaService read dict exit")
        return dict
    }


    func backgroundUpdateCheckGlobalMeta(once: Bool = false) {
        print_f(#file, #function, "backgroundUpdateCheckGlobalMeta")
        DispatchQueue.global(qos: .background).async {

            while true {
                print_f(#file, #function, "backgroundUpdateCheckGlobalMeta enter")
                var remoteGeneralMeta = Meta(version: 0, condition: 0)
                do {
                    remoteGeneralMeta = try self.getGeneralMeta()
                } catch {
                    print_f(#file, #function, "backgroundUpdateCheckGlobalMeta error, i will try next time")
                }

                if self.isGeneralMetaOld(remoteGeneralMeta: remoteGeneralMeta) {

                    do {
                        let us = UserAPIService.shared
                        try self.save(any: us.getVPNServers(), toFile: FilesEnum.vpnServers.rawValue)
                        self.setGeneralMetaCached(remoteGeneralMeta: remoteGeneralMeta)
                        NotificationCenter.default.post(name: .refreshTableView, object: nil)
                        print_f(#file, #function, "backgroundUpdateCheckGlobalMeta exit. Meta is old")
                    } catch {
                        print_f(#file, #function, "backgroundUpdateCheckGlobalMeta error, i will try next time")
                    }
                } else {
                    print_f(#file, #function, "backgroundUpdateCheckGlobalMeta exit. Meta is up to date")
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

        print_f(#file, #function, "getGeneralMeta enter")

        var response = RESTResponse()

        response = get(url: url, headers: nil)

        let dict = response.data
        if response.isSuccess && dict != nil {
            do {
                let meta = try Meta(dictionary: dict!)
                print_f(#file, #function, "getGeneralMeta end")
                return meta
            } catch ErrorsEnum.absentMetaProperty {
                print_f(#file, #function, "throw metaCacheServiceSystemError")
                throw ErrorsEnum.metaCacheServiceSystemError
            }

        } else if (response.statusCode == nil && response.errorMessage != nil) {
            throw ErrorsEnum.metaCacheServiceConnectionProblem
        } else {
            print_f(#file, #function, "throw metaCacheServiceSystemError")
            throw ErrorsEnum.metaCacheServiceSystemError
        }
    }

    func clearSettings() throws {
        print_f(#file, #function, "CacheMetaService delete everything to hell enter")
        // Path to save array data
        do {
            let directoryContents = try fileManager.contentsOfDirectory(at: self.dir, includingPropertiesForKeys: .none)
            for file in directoryContents {
                try fileManager.removeItem(at: file)
            }
        } catch {
            throw ErrorsEnum.metaCacheSystemError
        }

        print_f(#file, #function, "CacheMetaService delete everything to hell exit")
    }
}
