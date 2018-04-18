//
//  Satisfaction.swift
//  Satisfy
//
//  Created by Pierre on 17/04/2018.
//  Copyright © 2018 boudonpierre. All rights reserved.
//

import UIKit
import SwiftyJSON

class Satisfaction: NSObject {
    var id: String
    var idPod: Int
    var namePod: String
    var idButton: Int
    var date: Date
    var version: Int
    
    init(json: JSON) {
        self.id = json["_id"].stringValue
        self.idPod = json["id"].intValue
        self.namePod = "Satisfy Pod - Entrance Hall"
        self.idButton = json["id_button"].intValue
        self.date = json["date"].date!
        self.version = json["__v"].intValue
    }
}
