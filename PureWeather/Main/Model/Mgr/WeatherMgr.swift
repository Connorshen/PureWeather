//
//  WeatherMgr.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/24.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
import CoreData
import Alamofire
import HandyJSON
import SwiftyJSON
class WeatherMgr:BaseMgr{
    static let appCode:String = "0044e6b9711b422cb514312239456347"
    static let host:String = "http://jisutqybmf.market.alicloudapi.com"
    static let path:String = "/weather/query"
    static let KEY_GET_WEATHER = NSNotification.Name(rawValue:"key_get_weather")
    static let KEY_DELETE_WEATHER = NSNotification.Name(rawValue:"key_delete_weather")
    static let KEY_INTERENT_ERROR = NSNotification.Name(rawValue:"key_internet_error")
    static let KEY_FINISH_REFRESH = NSNotification.Name(rawValue:"key_finish_refresh")
    static let KEY_FINISH_BEGIN = NSNotification.Name(rawValue:"key_finish_begin")
    static let KEY_RESOLVE_FAILED=NSNotification.Name(rawValue: "key_resolve_failed")//json解析失败
    static let KEY_GET_WEATHER_FAILED=NSNotification.Name(rawValue: "key_get_weather_failed")
    static let shared = WeatherMgr()
    private var mainWeather:Weather?
    private var locatedWeather:Weather?
    private var cityWeather:[Weather]?
}
extension WeatherMgr{
    func deleteInCacheById(id:String?) -> Void {
        if let id=id{
            var index = -1
            for (i,v) in cityWeather!.enumerated(){
                if v.cityid == id{
                    index=i
                    break
                }
            }
            if index>=0{
                cityWeather?.remove(at: index)
                //更新数据库
                let app = UIApplication.shared.delegate as! AppDelegate
                let context = app.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<CityWeather>(entityName:"CityWeather")
                do{
                    let fetchedObjects = try context.fetch(fetchRequest)
                    for object in fetchedObjects{
                        if object.cityId==id{
                            context.delete(object)
                        }
                    }
                    try context.save()
                    sendMessage(name: WeatherMgr.KEY_DELETE_WEATHER, object: nil)
                }
                catch{
                    
                }
                if mainWeather?.cityid == id{
                    mainWeather=getLocatedWeatherInCache()
                    sendMessage(name: WeatherMgr.KEY_GET_WEATHER, object: nil)
                }        
            }
        }
    }
    func getCityNameById(cityId:String?) -> String? {
        if let cityId = cityId{
            if let cityWeather = cityWeather {
                for city in cityWeather{
                    if city.cityid == cityId{
                        return city.city
                    }
                }
            }
        }
        return nil
    }
}
extension WeatherMgr{
    func getCityWeatherInCache() -> [Weather] {
        if let cityWeather = cityWeather{
            return cityWeather
        }else{
            let app = UIApplication.shared.delegate as! AppDelegate
            let context = app.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<CityWeather>(entityName:"CityWeather")
            do{
                let fetchedObjects = try context.fetch(fetchRequest)
                cityWeather=[]
                for object in fetchedObjects{
                    if let weather = JSONDeserializer<Weather>.deserializeFrom(json: object.weatherJson) {
                        cityWeather?.append(weather)
                    }
                }
                return cityWeather!
            }
            catch{
                return []
            }
        }
    }
    func putCityWeatherInCache(weather:Weather?)->Void{
        if let weather = weather{
            //更新内存
            if let cityWeather=cityWeather{
                var isFound = false
                for index in 0..<cityWeather.count{
                    if  cityWeather[index].cityid == weather.cityid{
                        self.cityWeather![index] = weather
                        isFound=true
                    }
                }
                if !isFound{
                    self.cityWeather?.append(weather)
                }
            }else{
                cityWeather=[]
                cityWeather?.append(weather)
            }
            //更新数据库
            let app = UIApplication.shared.delegate as! AppDelegate
            let context = app.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<CityWeather>(entityName:"CityWeather")
            do{
                let fetchedObjects = try context.fetch(fetchRequest)
                for object in fetchedObjects{
                    context.delete(object)
                }
                for w in cityWeather!{
                    let weatherJson = NSEntityDescription.insertNewObject(forEntityName: "CityWeather",into: context) as! CityWeather
                    weatherJson.cityName=w.city
                    weatherJson.updateTime=Date()
                    weatherJson.weatherJson=w.toString()
                    weatherJson.cityId=w.cityid!
                    if(locatedWeather?.cityid==w.cityid){
                        weatherJson.isLocated=true
                    }else{
                        weatherJson.isLocated=false
                    }
                    try context.save()
                }
            }
            catch{
                
            }
        }
    }
    func getMainWeatherInCache() -> Weather? {
        if let mainWeather = mainWeather{
            return mainWeather
        }else{
            let app = UIApplication.shared.delegate as! AppDelegate
            let context = app.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<MainWeather>(entityName:"MainWeather")
            do {
                var fetchedObjects = try context.fetch(fetchRequest)
                fetchedObjects.sort { (a, b) -> Bool in
                    return a.updateTime! as Date>b.updateTime! as Date
                }
                for info in fetchedObjects{
                    if let weather = JSONDeserializer<Weather>.deserializeFrom(json: info.json) {
                        mainWeather=weather
                        return weather
                    }
                }
            }
            catch {
                
            }
            return nil
        }
    }
    func setMainWeatherById(id:String?){
        if let id = id{
            if let cityWeather = cityWeather{
                for weather in cityWeather{
                    if weather.cityid == id{
                        mainWeather=weather
                        return
                    }
                }
            }
        }
    }
    func setMainWeatherInCache(weather:Weather?) {
        if let weather=weather{
            mainWeather=weather
            let app = UIApplication.shared.delegate as! AppDelegate
            let context = app.persistentContainer.viewContext
            let weatherJson = NSEntityDescription.insertNewObject(forEntityName: "MainWeather",into: context) as! MainWeather
            weatherJson.json=weather.toString()
            weatherJson.updateTime=Date()
            do {
                try context.save()
            } catch {
            }
        }
    }
    func getLocatedWeatherInCache() -> Weather? {
        if let locatedWeather = locatedWeather{
            return locatedWeather
        }else {
            let app = UIApplication.shared.delegate as! AppDelegate
            let context = app.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<LocatedWeather>(entityName:"LocatedWeather")
            do {
                var fetchedObjects = try context.fetch(fetchRequest)
                fetchedObjects.sort { (a, b) -> Bool in
                    return a.updateTime! as Date>b.updateTime! as Date
                }
                for info in fetchedObjects{
                    if let weather = JSONDeserializer<Weather>.deserializeFrom(json: info.json) {
                        locatedWeather=weather
                        return weather
                    }
                }
            }
            catch {
                
            }
            return nil
        }
    }
    func setLocatedWeatherInCache(weather:Weather?){
        if let weather=weather{
            locatedWeather=weather
            let app = UIApplication.shared.delegate as! AppDelegate
            let context = app.persistentContainer.viewContext
            let weatherJson = NSEntityDescription.insertNewObject(forEntityName: "LocatedWeather",into: context) as! LocatedWeather
            weatherJson.json=weather.toString()
            weatherJson.updateTime=Date()
            do {
                try context.save()
            } catch {
            }
        }
    }
    
}
extension WeatherMgr{
    //根据城市名获取天气
    func getWeatherByName(cityName:String){
        let headers = ["Authorization":"APPCODE "+WeatherMgr.appCode]
        let params = ["city":cityName]
        Alamofire.request(WeatherMgr.host+WeatherMgr.path,method:.get,parameters:params,headers:headers).responseString {response in
            switch response.result {
            case .success:
                if let json = try? JSON.init(data: response.data!){
                    let status=json["status"].string as String?
                    let msg = json["msg"].string as String?
                    if let status = status{
                        if status == "0"{
                            let dict = json["result"].dictionaryObject as NSDictionary?
                            let weatherData = Weather.deserialize(from: dict) ?? nil
                            if weatherData != nil{
                                self.putCityWeatherInCache(weather: weatherData)
                                self.setMainWeatherInCache(weather: weatherData)
                                self.sendMessage(name: WeatherMgr.KEY_GET_WEATHER, object: nil)
                            }else{
                                self.sendMessage(name: WeatherMgr.KEY_RESOLVE_FAILED, object: nil)
                            }
                        }else{
                            self.sendMessage(name: WeatherMgr.KEY_GET_WEATHER_FAILED, object: msg)
                        }
                    }else{
                        self.sendMessage(name: WeatherMgr.KEY_RESOLVE_FAILED, object: nil)
                    }
                }else{
                    self.sendMessage(name: WeatherMgr.KEY_RESOLVE_FAILED, object: nil)
                }
            case .failure(let error):
                self.sendMessage(name: WeatherMgr.KEY_INTERENT_ERROR, object: nil)
                print(error)
            }
        }
        self.sendMessage(name: WeatherMgr.KEY_FINISH_REFRESH, object: nil)
    }
    //定位后获得天气
    func getWeahterByCoordinate(lat:Double,lon:Double){
        let headers = ["Authorization":"APPCODE "+WeatherMgr.appCode]
        let params = ["location":"\(lat),\(lon)"]
        Alamofire.request(WeatherMgr.host+WeatherMgr.path,method:.get,parameters:params,headers:headers).responseString {response in
            switch response.result {
            case .success:
                if let json = try? JSON.init(data: response.data!){
                    let dict = json["result"].dictionaryObject as NSDictionary?
                    let weatherData = Weather.deserialize(from: dict) ?? nil
                    if weatherData != nil{
                        self.putCityWeatherInCache(weather: weatherData)
                        self.setMainWeatherInCache(weather: weatherData)
                        self.setLocatedWeatherInCache(weather: weatherData)
                        self.sendMessage(name: WeatherMgr.KEY_GET_WEATHER, object: nil)
                    }else{
                        self.sendMessage(name: WeatherMgr.KEY_RESOLVE_FAILED, object: nil)
                    }
                }else{
                    self.sendMessage(name: WeatherMgr.KEY_RESOLVE_FAILED, object: nil)
                }
            case .failure(let error):
                self.sendMessage(name: WeatherMgr.KEY_INTERENT_ERROR, object: nil)
                print(error)
            }
            self.sendMessage(name: WeatherMgr.KEY_FINISH_REFRESH, object: nil)
        }
    }
    //根据cityId查询天气
    func getWeatherByCityId(cityId:String) -> Void {
        let headers = ["Authorization":"APPCODE "+WeatherMgr.appCode]
        let params = ["cityid":"\(cityId)"]
        Alamofire.request(WeatherMgr.host+WeatherMgr.path,method:.get,parameters:params,headers:headers).responseString {response in
            switch response.result {
            case .success:
                if let json = try? JSON.init(data: response.data!){
                    let status=json["status"].string as String?
                    let msg = json["msg"].string as String?
                    if let status = status{
                        if status == "0"{
                            let dict = json["result"].dictionaryObject as NSDictionary?
                            let weatherData = Weather.deserialize(from: dict) ?? nil
                            if weatherData != nil{
                                self.putCityWeatherInCache(weather: weatherData)
                                self.setMainWeatherInCache(weather: weatherData)
                                self.sendMessage(name: WeatherMgr.KEY_GET_WEATHER, object: nil)
                            }else{
                                self.sendMessage(name: WeatherMgr.KEY_RESOLVE_FAILED, object: nil)
                            }
                        }else{
                            self.sendMessage(name: WeatherMgr.KEY_GET_WEATHER_FAILED, object: msg)
                        }
                    }else{
                        self.sendMessage(name: WeatherMgr.KEY_RESOLVE_FAILED, object: nil)
                    }
                }else{
                    self.sendMessage(name: WeatherMgr.KEY_RESOLVE_FAILED, object: nil)
                }
            case .failure(let error):
                self.sendMessage(name: WeatherMgr.KEY_INTERENT_ERROR, object: nil)
                print(error)
            }
            self.sendMessage(name: WeatherMgr.KEY_FINISH_REFRESH, object: nil)
        }
    }
}


