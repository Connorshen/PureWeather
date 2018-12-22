//
//  VideoController.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/8/9.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class VideoController:BaseController{
    @IBAction func onCloseClick(_ sender: Any) {
        addLog(eventType: AnalyticsMgr.TYPE_CLICK, eventId: Event.CLOSE_CLICK, packageName: getPackageName())
        self.dismiss(animated: true, completion: nil)
    }
}
