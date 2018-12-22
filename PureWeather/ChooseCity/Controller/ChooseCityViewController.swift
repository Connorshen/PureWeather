//
//  ChooseCityViewController.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/15.
//  Copyright © 2018年 沈正圆. All rights reserved.
//
import UIKit
import Toast_Swift
class ChooseCityViewController: BaseController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{
    let TYPE_CITY=1;
    @IBOutlet weak var mListView: UITableView!
    @IBOutlet weak var mSearchBar: UISearchBar!
    private var mItems = [[BaseItem]]()
    private var searchResultItems = [[BaseItem]]()
    private var sectionTitles = [String]()
    private var indexedCollation = UILocalizedIndexedCollation.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initData()
        
    }
    func initView() {
        self.navigationItem.title="选择城市"
        self.mListView.separatorStyle = .none
        self.mListView.delegate=self
        self.mListView.dataSource=self
        self.mSearchBar.delegate=self
        self.mListView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.onDrag
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title:"返回", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onBackClick))
    }
    func initData() {
        showWaiting()
        DispatchQueue.global().async {
            self.sectionTitles.removeAll()
            //构造一维mItems
            var cityArr = [BaseItem]()
            for city in CityMgr.shared.getCitys() {
                cityArr.append(CityItem(itemType: self.TYPE_CITY, city: city))
            }
            let indexCount = self.indexedCollation.sectionTitles.count
            //构造空的mItems
            for _ in 0..<indexCount {
                let array = [CityItem]()
                self.mItems.append(array)
            }
            //填入
            for city in cityArr {
                let sectionNumber = self.indexedCollation.section(for: city, collationStringSelector: #selector(getter: CityItem.cityName))
                self.mItems[sectionNumber].append(city)
            }
            //排序
            for i in 0..<indexCount {
                let sortedPersonArray = self.indexedCollation.sortedArray(from: self.mItems[i], collationStringSelector: #selector(getter: CityItem.cityName))
                self.mItems[i] = sortedPersonArray as! [CityItem]
            }
            // 用来保存没有数据的一维数组的下标
            var tempArray = [Int]()
            for (i, array) in self.mItems.enumerated() {
                
                if array.count == 0 {
                    tempArray.append(i)
                } else {
                    self.sectionTitles.append(self.self.indexedCollation.sectionTitles[i])
                }
            }
            // 删除没有数据的数组
            for i in tempArray.reversed() {
                self.self.mItems.remove(at: i)
            }
            self.searchResultItems=self.mItems
            DispatchQueue.main.async {
                self.mListView.reloadData()
                self.mListView.separatorStyle = .singleLine
                self.hideWaiting()
            }
        }
    }
    func initTitle(){
        sectionTitles.removeAll()
        // 用来保存没有数据的一维数组的下标
        var tempArray = [Int]()
        for (i, array) in self.searchResultItems.enumerated() {
            
            if array.count == 0 {
                tempArray.append(i)
            } else {
                self.sectionTitles.append(self.indexedCollation.sectionTitles[i])
            }
        }
        // 删除没有数据的数组
        for i in tempArray.reversed() {
            self.searchResultItems.remove(at: i)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResultItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "cityCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: id)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: id)
        }
        cell?.textLabel?.text = (searchResultItems[indexPath.section][indexPath.row] as! CityItem).cityName
        return cell!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sectionTitles
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityName = (searchResultItems[indexPath.section][indexPath.row] as! CityItem).cityName!
        addLog(eventType: AnalyticsMgr.TYPE_CLICK, eventId: Event.CITY_ITEM_CLICK, msg1: "\(cityName)",msg2: "添加城市管理", packageName: getPackageName())
        WeatherMgr.shared.getWeatherByName(cityName:cityName )
        WeatherMgr.shared.sendMessage(name: WeatherMgr.KEY_FINISH_BEGIN, object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText==""{
            searchResultItems=mItems
            initTitle()
        }else{
            searchResultItems.removeAll()
            //构造一维mItems
            var cityArr = [BaseItem]()
            for items in mItems {
                for item in items{
                    if ((item as! CityItem).cityName?.localizedCaseInsensitiveContains(searchText))!||((item as! CityItem).pinyin?.localizedCaseInsensitiveContains(searchText))!{
                        cityArr.append(item)
                    }
                }
            }
            let indexCount = self.indexedCollation.sectionTitles.count
            //构造空的mItems
            for _ in 0..<indexCount {
                let array = [CityItem]()
                self.searchResultItems.append(array)
            }
            //填入
            for city in cityArr {
                let sectionNumber = self.indexedCollation.section(for: city, collationStringSelector: #selector(getter: CityItem.cityName))
                self.searchResultItems[sectionNumber].append(city)
            }
            //排序
            for i in 0..<indexCount {
                let sortedPersonArray = self.indexedCollation.sortedArray(from: self.searchResultItems[i], collationStringSelector: #selector(getter: CityItem.cityName))
                self.searchResultItems[i] = sortedPersonArray as! [CityItem]
            }
            initTitle()
        }
        mListView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        mSearchBar.setShowsCancelButton(true, animated: true)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        mSearchBar.text=""
        mSearchBar.resignFirstResponder()
        mSearchBar.setShowsCancelButton(false, animated: true)
        searchResultItems=mItems
        initTitle()
        mListView.reloadData()
    }
    @objc func onBackClick(){
        self.navigationController?.popViewController(animated: true)
        addLog(eventType:AnalyticsMgr.TYPE_CLICK, eventId: Event.BACK_CLICK,packageName: getPackageName())
    }
}
