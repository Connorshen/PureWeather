//
//  DevInfo.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/8/4.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import LeanCloud
class DevInfo: LCObject {
    @objc dynamic var appDisplayName:LCString?
    @objc dynamic var minorVersion:LCString?
    @objc dynamic var appVersion:LCString?
    @objc dynamic var iosVersion:LCString?
    @objc dynamic var identifierNumber:LCString?
    @objc dynamic var systemName:LCString?
    @objc dynamic var model:LCString?
    @objc dynamic var modelName:LCString?
    @objc dynamic var localizedModel:LCString?
    override static func objectClassName() -> String {
        return "DevInfo"
    }
    required init() {
        appDisplayName=LCString(AppMgr.shared.appDisplayName)
        minorVersion=LCString(AppMgr.shared.minorVersion)
        appVersion=LCString(AppMgr.shared.appVersion)
        iosVersion=LCString(AppMgr.shared.iosVersion)
        identifierNumber=LCString(AppMgr.shared.identifierNumber)
        systemName=LCString(AppMgr.shared.systemName)
        model=LCString(AppMgr.shared.model)
        modelName=LCString(AppMgr.shared.modelName)
        localizedModel=LCString(AppMgr.shared.localizedModel)
    }
}
