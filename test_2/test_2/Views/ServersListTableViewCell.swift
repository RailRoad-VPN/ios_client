//
// Created by beop on 6/15/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation
import UIKit

class ServersListTableViewCell: UITableViewCell {

    var serverName = UILabel()
    var locationAndLoad = UILabel()
    var flag = UIImageView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //debug
        self.textLabel?.textColor = UIColor.green


        self.flag.frame = CGRect.init(x: 15, y: 7.5, width: 70, height: 35)
        //self.flag.backgroundColor = UIColor.purple
        self.flag.image = UIImage.init(named: "image936")

        self.serverName.frame = CGRect.init(x: 15 + self.flag.frame.width + 7.5, y: 5, width: 100, height: 20)
        self.serverName.textColor = UIColor.blue
        //self.serverName.backgroundColor = UIColor.black
        self.serverName.font = self.serverName.font.withSize(15)

        self.locationAndLoad.frame = CGRect.init(x: 15 + self.flag.frame.width + 7.5, y: 28, width: 250, height: 15)
        self.locationAndLoad.textColor = UIColor.green
        //self.locationAndLoad.backgroundColor = UIColor.purple
        self.locationAndLoad.font = self.locationAndLoad.font.withSize(12)


        self.addSubview(self.serverName)
        self.addSubview(self.locationAndLoad)
        self.addSubview(self.flag)


    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
