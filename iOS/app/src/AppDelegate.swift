//
//  AppDelegate.swift
//  BigMoneyShot
//
//  Created by Brian Ogden on 12/9/18.
//  Copyright © 2018 Big Money Shot. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import GoogleSignIn
import FacebookCore
import Stripe

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        //Facebook
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Stripe
        STPPaymentConfiguration.shared().publishableKey = Environment.configuration(.stripePublishableKey)
        STPPaymentConfiguration.shared().appleMerchantIdentifier = Environment.configuration(.appleMerchantIdentifier)
        UIUtility.setStripeTheme()
        
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
        if !AuthUtility.accountCreated {
            AuthUtility.logout()
        }
    }

    @available(iOS 9.0, *)
    private func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            let handled: Bool = SDKApplicationDelegate.shared.application(application, open: url, options: options)
            
            if handled { return handled }
            
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    //deprecated method iOS 8 and older
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        let handled: Bool =  SDKApplicationDelegate.shared.application(application,
                                                                       open: url,
                                                                       sourceApplication: sourceApplication,
                                                                       annotation: annotation)
        
        if handled { return handled }
        
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    // Mark: - GIDSignInDeletgate
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if error != nil {
            // ...
            return
        }

        guard let authentication = user.authentication else { return }
        _ = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    // Mark: - FacebookSDK
}

