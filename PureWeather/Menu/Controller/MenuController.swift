//
//  MenuController.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/23.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import Foundation
class MenuController: BaseController,UITableViewDataSource,UITableViewDelegate ,CityWeatherDelegate{
    let TYPE_CITY_WEATHER=1
    let TYPE_DIVIDER=2
    var mItems:[BaseItem]=[]
    @IBOutlet weak var mListView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initData()
    }
    func initData(){
        updateList()
    }
    func initView()  {
        navigationItem.title="管理城市"
        mListView.separatorStyle = .none
        NotificationCenter.default.addObserver(self, selector: #selector(onGotWeather), name: WeatherMgr.KEY_GET_WEATHER, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(finishDelete), name: WeatherMgr.KEY_DELETE_WEATHER, object: nil)
        mListView.register(UINib(nibName: "CityWeatherViewCell", bundle: nil), forCellReuseIdentifier: "CityWeatherViewCell")
        mListView.register(UINib(nibName: "DividerViewCell", bundle: nil), forCellReuseIdentifier: "DividerViewCell")
        mListView.delegate=self
        mListView.dataSource=self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defalutCell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        let baseItem:BaseItem=mItems[indexPath.row]
        switch baseItem.itemType {
        case TYPE_CITY_WEATHER:
            let cell: CityWeatherViewCell = self.mListView.dequeueReusableCell(withIdentifier: "CityWeatherViewCell") as! CityWeatherViewCell
            cell.setInfo(item: baseItem as! CityWeatherItem,delegate:self)
            return cell
        case TYPE_DIVIDER:
            let cell: DividerViewCell = self.mListView.dequeueReusableCell(withIdentifier: "DividerViewCell") as! DividerViewCell
            return cell
        default:
            return defalutCell
        }
    }
    func updateList(){
        let weathers=WeatherMgr.shared.getCityWeatherInCache()
        mItems.removeAll()
        let locatedWeather=WeatherMgr.shared.getLocatedWeatherInCache()
        for weather in weathers{
            var canDelete=false
            if let w=locatedWeather{
                if w.cityid==weather.cityid{
                    canDelete=true
                }else{
                    canDelete=false
                }
            }
            mItems.append(CityWeatherItem(itemType: TYPE_CITY_WEATHER, cityWeather: weather,canDelete:canDelete))
            mItems.append(BaseItem(itemType: TYPE_DIVIDER))
        }
        mListView.reloadData()
    }
    @objc func finishDelete(){
        updateList()
        self.showToast(msg: "删除城市成功")
    }
    func onDelete(cityId: String) {
        let cityName = WeatherMgr.shared.getCityNameById(cityId: cityId)
        addLog(eventType: AnalyticsMgr.TYPE_CLICK, eventId: Event.CITY_ITEM_DELETE, msg1: cityName,msg2: "删除城市管理", packageName: getPackageName())
        WeatherMgr.shared.deleteInCacheById(id: cityId)
    }
    func onCellClick(cityId: String) {
        let cityName = WeatherMgr.shared.getCityNameById(cityId: cityId)
        addLog(eventType: AnalyticsMgr.TYPE_CLICK, eventId: Event.CITY_ITEM_CLICK, msg1: cityName, msg2: "点击城市刷新",packageName: getPackageName())
        WeatherMgr.shared.setMainWeatherById(id: cityId)
        sendMessage(name: MenuMgr.KEY_WEATHER_CLICK, object: nil)
        self.mm_drawerController.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    @IBAction func onSettingClick(_ sender: Any) {
        addLog(eventType: AnalyticsMgr.TYPE_CLICK, eventId: Event.SETTING_CLICK, packageName: getPackageName())
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let settingController = mainStoryboard.instantiateViewController(withIdentifier:"SettingController")
        self.present(settingController, animated: true, completion: nil)
    }
    @objc func onGotWeather(){
        updateList()
    }
}
