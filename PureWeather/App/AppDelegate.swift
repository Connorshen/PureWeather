//
//  AppDelegate.swift
//  PureWeather
//
//  Created by 沈正圆 on 2018/7/12.
//  Copyright © 2018年 沈正圆. All rights reserved.
//

import UIKit
import CoreData
import LeanCloud
import MMDrawerController
import Toast_Swift
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawer = MMDrawerController()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        LeanCloud.initialize(applicationID: "zpo69IR1ljR8TPMeztc8w4wK-gzGzoHsz", applicationKey: "EHR4AlTOjE4X1MKW8zsCNzBX")
        AMapServices.shared().enableHTTPS = true
        AMapServices.shared().apiKey = "af34ce953dce323fffd78d62e5439808"
        ToastManager.shared.isQueueEnabled = true//设置Toast按队列显示
        AnalyticsMgr.shared.uploadDevInfo()//上传设备信息，软件版本
        initDrawer()//初始化左侧抽屉
        return true
    }
    func initDrawer(){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let menu = mainStoryboard.instantiateViewController(withIdentifier:"Menu")
        let center=mainStoryboard.instantiateViewController(withIdentifier: "Main")
        drawer = MMDrawerController(center: center, leftDrawerViewController: menu, rightDrawerViewController: nil)
        drawer.openDrawerGestureModeMask = .all
        drawer.closeDrawerGestureModeMask = .all
        drawer.maximumLeftDrawerWidth = ScreenMgr.shared.screenWidth*3/4
        self.window?.rootViewController = drawer
        self.window?.makeKeyAndVisible()
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "PureWeather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

