//
//  BaseController.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/24.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import LeanCloud
class BaseController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        AnalyticsMgr.shared.beginLogPageView(pageName:getPackageName())
    }
    override func viewWillDisappear(_ animated: Bool) {
        AnalyticsMgr.shared.endLogPageView(pageName: getPackageName())
    }
    override func didReceiveMemoryWarning() {
        NotificationCenter.default.removeObserver(self)
    }
    func clearToast(){
        self.view.hideToast()
    }
    func showToast(msg:String){
        clearToast()
        self.view.makeToast(msg)
    }
    func showTopToast(msg:String){
        clearToast()
        self.view.makeToast(msg, duration: 2.0, position: .top)
    }
    func showWaiting(){
        clearToast()
        self.view.makeToastActivity(.center)
    }
    func hideWaiting(){
        self.view.hideToastActivity()
    }
    func sendMessage(name: NSNotification.Name, object: Any?) -> Void {
        NotificationCenter.default.post(name: name, object: object)
    }
    func getPackageName() -> String? {
        return NSStringFromClass(type(of: self))
    }
    func addLog(eventType:String?,eventId:String?,msg1:String?,msg2:String?,packageName:String?){
        AnalyticsMgr.shared.uploadEvent(eventType: eventType, eventId: eventId, msg1: msg1, msg2: msg2, packageName: packageName)
    }
    func addLog(eventType:String?,eventId:String?,msg1:String?,packageName:String?){
        AnalyticsMgr.shared.uploadEvent(eventType: eventType, eventId: eventId, msg1: msg1, msg2: nil, packageName: packageName)
    }
    func addLog(eventType:String?,eventId:String?,packageName:String?){
        AnalyticsMgr.shared.uploadEvent(eventType: eventType, eventId: eventId, msg1: nil, msg2: nil, packageName: packageName)
    }
}
