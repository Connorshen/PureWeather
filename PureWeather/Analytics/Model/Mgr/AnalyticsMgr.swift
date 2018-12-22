//
//  UploadManager.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/22.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import LeanCloud
class AnalyticsMgr {
    static let TYPE_CLICK = "type_click"
    var pageLogs:[String:PageLog]=[:]
    static var shared=AnalyticsMgr()
    func uploadLoation(){
        let singleLocation=SingleLocation()
        if let location=LocationMgr.shared.getCurLocation(){
            singleLocation.setLocation(location: location)
        }else {
            singleLocation.setFailed()
        }
        if let reGeocode=LocationMgr.shared.getCurReGeocode(){
            singleLocation.setReGeocode(reGeocode: reGeocode)
        }
        singleLocation.save { (result) in
            switch result {
            case .success:
                break
            case .failure(let error):
                print(error)
            }
        }
        
    }
    func uploadDevInfo(){
        let devInfo=DevInfo()
        let query = LCQuery(className: "DevInfo")
        query.whereKey("identifierNumber", .equalTo(AppMgr.shared.identifierNumber))
        query.find { result in
            switch result {
            case .success(let objects):
                if objects.count>0{
                    for object in objects{
                        object.delete({ (result) in
                        })
                    }
                }
                devInfo.save({ (result) in
                    switch result{
                    case .success:
                        break
                    case .failure:
                        break
                    }
                })
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    func uploadEvent(eventType:String?,eventId:String?,msg1:String?,msg2:String?,packageName:String?){
        let event = MainEvent()
        event.eventTime=LCDate(Date())
        event.eventType=LCString(eventType != nil ? eventType!:"")
        event.eventId=LCString(eventId != nil ? eventId!:"")
        event.pageName = LCString(packageName != nil ? packageName!:"")
        event.msg1 = LCString(msg1 != nil ? msg1!:"")
        event.msg2 = LCString(msg2 != nil ? msg2!:"")
        event.save { (result) in
            switch result{
            case .success:
                break
            case.failure:
                break
            }
        }
    }
    func uploadPageLog(pageName:String?){
        if let pageName = pageName{
            let pageLog = pageLogs[pageName]
            if pageLog != nil && pageLog?.endTime != nil && pageLog?.startTime != nil{
                let pageEvent = PageEvent()
                let dur = (pageLog?.endTime?.timeIntervalSince1970)!-(pageLog?.startTime?.timeIntervalSince1970)!
                pageEvent.startTime=LCDate((pageLog?.startTime)!)
                pageEvent.endTime=LCDate((pageLog?.endTime)!)
                pageEvent.dur = LCString(String(format:"%.2f",dur))
                pageEvent.pageName=LCString(pageName)
                pageEvent.save { (result) in
                    switch result{
                    case .success:
                        break
                    case.failure:
                        break
                    }
                }
            }
        }
    }
    func beginLogPageView(pageName:String?){
        if let pageName = pageName{
            let pageLog=PageLog()
            pageLog.startTime=Date()
            pageLogs[pageName]=pageLog
        }
    }
    func endLogPageView(pageName:String?){
        if let pageName = pageName{
            let pageLog = pageLogs[pageName]
            if pageLog != nil{
                pageLog!.endTime=Date()
                pageLogs[pageName]=pageLog
                uploadPageLog(pageName: pageName)
            }
        }
    }
}
