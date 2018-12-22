//
//  ViewController.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/12.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import UIKit
import LeanCloud
import AMapFoundationKit
import MapKit
import Toast_Swift
class MainViewController: BaseController,UITableViewDelegate,UITableViewDataSource {
    let TYPE_TODAY_WEATHER=1
    let TYPE_DAILY_WEATHER = 2
    let TYPE_AIR_QUALITY = 3
    let TYPE_LIFE_INDEX = 4
    let TYPE_HOURLY_WEATHER=5
    let TYPE_BOTTOM_LINE=6
    let header = MJRefreshNormalHeader()
    @IBOutlet weak var mListView: UITableView!
    var mItems:[BaseItem]=[]
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initData()
    }
    func updateList(weather: Weather?) {
        if let weather = weather {
        navigationItem.title=weather.city
        mItems.removeAll()
        let todayItem=TodayWeatherItem(itemType: TYPE_TODAY_WEATHER, temp: weather.temp,weatherDes: weather.weather,tempMax:weather.temphigh, tempMin: weather.templow,updateTime:weather.updatetime)
        mItems.append(todayItem)
        mItems.append(BaseItem(itemType: TYPE_BOTTOM_LINE))
        let hourlyItem=HourlyWeatherItem(itemType: TYPE_HOURLY_WEATHER, hourWeathers: weather.hourly)
        mItems.append(hourlyItem)
        mItems.append(BaseItem(itemType: TYPE_BOTTOM_LINE))
        if let dailys = weather.daily{
            var count:Int=0
            for daily in dailys{
                if count==0{
                    count=count+1
                    continue
                }
                if count>=6{
                    break
                }
                let night=daily.night
                let day=daily.day
                let dailyItem=DailyWeatherItem(itemType: TYPE_DAILY_WEATHER, date: daily.date, week: daily.week, tempMax: day?.temphigh, tempMin: night?.templow, weatherIcon: day?.img)
                mItems.append(dailyItem)
                mItems.append(BaseItem(itemType: TYPE_BOTTOM_LINE))
                count=count+1
            }
        }
        if let aqi=weather.aqi{
            mItems.append(AirQualityItem(itemType: TYPE_AIR_QUALITY, aqi: aqi))
            mItems.append(BaseItem(itemType: TYPE_BOTTOM_LINE))
        }
        if let indexs=weather.index{
            for index in indexs{
                mItems.append(LifeIndexItem(itemType: TYPE_LIFE_INDEX, name: index.iname, value: index.ivalue, detail: index.detail))
                mItems.append(BaseItem(itemType: TYPE_BOTTOM_LINE))
            }
        }
        }
        self.mListView.reloadData()
    }
    func initView()  {
        navigationItem.title=AppMgr.shared.appDisplayName
        header.setRefreshingTarget(self, refreshingAction: #selector(MainViewController.onRefresh))
        mListView.mj_header = header
        mListView.dataSource=self
        mListView.delegate=self
        mListView.register(UINib(nibName: "TodayWeatherViewCell", bundle: nil), forCellReuseIdentifier: "TodayWeatherViewCell")
        mListView.register(UINib(nibName: "DailyWeatherViewCell", bundle: nil), forCellReuseIdentifier: "DailyWeatherViewCell")
        mListView.register(UINib(nibName: "AirQualityViewCell", bundle: nil), forCellReuseIdentifier: "AirQualityViewCell")
        mListView.register(UINib(nibName: "LifeIndexViewCell", bundle: nil), forCellReuseIdentifier: "LifeIndexViewCell")
        mListView.register(UINib(nibName: "HourlyWeatherViewCell", bundle: nil), forCellReuseIdentifier: "HourlyWeatherViewCell")
        mListView.register(UINib(nibName: "BottomLineViewCell", bundle: nil), forCellReuseIdentifier: "BottomLineViewCell")
        mListView.separatorStyle = .none
    }
    @objc func onRefresh(){
        if let mainCacheWeather=WeatherMgr.shared.getMainWeatherInCache() {
            WeatherMgr.shared.getWeatherByCityId(cityId: mainCacheWeather.cityid!)
        }else{
            if LocationMgr.shared.isLocatedSuccessful() {
                WeatherMgr.shared.getWeahterByCoordinate(lat: LocationMgr.shared.getCurLat(), lon: LocationMgr.shared.getCurLon())
            }else{
                LocationMgr.shared.getLocation()
            }
        }
    }
    @objc func onGotWeather(){
        self.showToast(msg: "获取天气信息成功。")
        updateList(weather: WeatherMgr.shared.getMainWeatherInCache())
    }
    @objc func networkUnavailable(){
        self.showToast(msg: "网络连接错误，将显示缓存。")
    }
    @objc func onLocated(){
        WeatherMgr.shared.getWeahterByCoordinate(lat: LocationMgr.shared.getCurLat(), lon: LocationMgr.shared.getCurLon())
    }
    @objc func onLocatedFailed(){
        self.showToast(msg: "定位发生错误，将请求默认位置。")
        WeatherMgr.shared.getWeahterByCoordinate(lat: LocationMgr.shared.getCurLat(), lon: LocationMgr.shared.getCurLon())
    }
    @objc func onResolveFailed(){
        self.showToast(msg: "天气JSON解析失败，将显示缓存。")
    }
    @objc func onFinishRefresh(){
        self.mListView.mj_header.endRefreshing()
    }
    @objc func onFinishBegin(){
        self.showToast(msg: "开始请求天气")
    }
    @objc func onGetWeatherFailed(notification:NSNotification){
        let msg=notification.object as! String
        self.view.makeToast(msg)
    }
    @objc func onWeatherChange(){
        updateList(weather: WeatherMgr.shared.getMainWeatherInCache())
        self.header.beginRefreshing()
    }
    func initData(){
        NotificationCenter.default.addObserver(self, selector: #selector(onGotWeather), name: WeatherMgr.KEY_GET_WEATHER, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onWeatherChange), name: MenuMgr.KEY_WEATHER_CLICK, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(networkUnavailable), name: WeatherMgr.KEY_INTERENT_ERROR, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLocated), name: LocationMgr.KEY_LCATED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onResolveFailed), name: WeatherMgr.KEY_RESOLVE_FAILED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onLocatedFailed), name: LocationMgr.KEY_LCATED_FAILED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onFinishRefresh), name: WeatherMgr.KEY_FINISH_REFRESH, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onGetWeatherFailed(notification:)), name: WeatherMgr.KEY_GET_WEATHER_FAILED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onFinishBegin), name: WeatherMgr.KEY_FINISH_BEGIN, object: nil)
        updateList(weather: WeatherMgr.shared.getLocatedWeatherInCache())
        LocationMgr.shared.getLocation()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mItems.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defalutCell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        let baseItem:BaseItem=mItems[indexPath.row]
        switch baseItem.itemType {
        case TYPE_TODAY_WEATHER:
            let cell: TodayWeatherViewCell = self.mListView.dequeueReusableCell(withIdentifier: "TodayWeatherViewCell") as! TodayWeatherViewCell
            cell.setInfo(todayItem: baseItem as! TodayWeatherItem)
            return cell
        case TYPE_DAILY_WEATHER:
            let cell: DailyWeatherViewCell = self.mListView.dequeueReusableCell(withIdentifier: "DailyWeatherViewCell") as! DailyWeatherViewCell
            cell.setInfo(dailyWeatherItem: baseItem as! DailyWeatherItem)
            return cell
        case TYPE_AIR_QUALITY:
            let cell: AirQualityViewCell = self.mListView.dequeueReusableCell(withIdentifier: "AirQualityViewCell") as! AirQualityViewCell
            cell.setInfo(airQualityItem: baseItem as! AirQualityItem)
            return cell
        case TYPE_LIFE_INDEX:
            let cell: LifeIndexViewCell = self.mListView.dequeueReusableCell(withIdentifier: "LifeIndexViewCell") as! LifeIndexViewCell
            cell.setInfo(lifeIndexItem: baseItem as! LifeIndexItem)
            return cell
        case TYPE_HOURLY_WEATHER:
            let cell: HourlyWeatherViewCell = self.mListView.dequeueReusableCell(withIdentifier: "HourlyWeatherViewCell") as! HourlyWeatherViewCell
            cell.setInfo(hourlyWeatherItem: baseItem as! HourlyWeatherItem)
            return cell
        case TYPE_BOTTOM_LINE:
            let cell: BottomLineViewCell = self.mListView.dequeueReusableCell(withIdentifier: "BottomLineViewCell") as! BottomLineViewCell
            return cell
        default:
            return defalutCell
        }
    }
    @IBAction func onLeftClick(_ sender: Any) {
        addLog(eventType: AnalyticsMgr.TYPE_CLICK, eventId: Event.MENU_CLICK, packageName: getPackageName())
        self.mm_drawerController.toggle(MMDrawerSide.left, animated: true, completion:nil )
    }
    @IBAction func onRightClick(_ sender: Any) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let chooseCity = mainStoryboard.instantiateViewController(withIdentifier:"ChooseCityViewController")
        self.navigationController?.pushViewController(chooseCity , animated: true)
        addLog(eventType: AnalyticsMgr.TYPE_CLICK, eventId: Event.CHOOSE_CITY_CLICK, packageName: getPackageName())
    }
    func showQuestionController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let questionController = mainStoryboard.instantiateViewController(withIdentifier:"QuestionController")
        self.present(questionController, animated: true, completion: nil)
    }
}

