//
//  AppDelegate.swift
//  gdo
//
//  Created by Jerry Yu on 12/4/18.
//  Copyright © 2018 Jerry Yu. All rights reserved.
//

import UIKit

let GDOLog = Logger()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

    enum ShortcutIdentifier: String {
        case toggle
    }

    private let shortcutUserInfoIconKey = "shortcutUserInfoIconKey"
    private let toggleValue = "toggleValue"

    func installShortcutActionsIfNeeded() {
        if let shortcutItems = UIApplication.shared.shortcutItems, shortcutItems.isEmpty {
            let toggleShortcut = UIMutableApplicationShortcutItem(type: ShortcutIdentifier.toggle.rawValue,
                                                                  localizedTitle: "Toggle garage door",
                                                                  localizedSubtitle: "",
                                                                  icon: UIApplicationShortcutIcon(type: .home),
                                                                  userInfo: nil)

            UIApplication.shared.shortcutItems = [toggleShortcut]
        }
    }

    private func toggleDoor() {
        guard let environment = Environment.loadFromDiskIfPossible() else {
            return
        }

        let commandData = CommandWrapper.serialize(type: .toggle, commandDetails: Dictionary<String, String>(), user: environment.user)
        SocketHelper.send(data: commandData, to: environment.remoteHostName, port: environment.remotePort)
    }

    private func handleShortCutItem(_ shortCutItem: UIApplicationShortcutItem) {
        switch shortCutItem.type {
        case ShortcutIdentifier.toggle.rawValue:
            toggleDoor()
        default:
            break
        }
    }

    // Boilerplate

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let shortcutItem = launchOptions?[UIApplication.LaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            handleShortCutItem(shortcutItem)
            return false
        }

        installShortcutActionsIfNeeded()

		return true
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
	}

    /*
     Called when the user activates your application by selecting a shortcut on the home screen, except when
     application(_:,willFinishLaunchingWithOptions:) or application(_:didFinishLaunchingWithOptions) returns `false`.
     You should handle the shortcut in those callbacks and return `false` if possible. In that case, this
     callback is used if your application is already launched in the background.
     */
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        handleShortCutItem(shortcutItem)
        completionHandler(true)
    }
}

