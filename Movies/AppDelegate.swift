//
//  AppDelegate.swift
//  Movies
//
//  Created by Carmen Salvador on 4/8/20.
//  Copyright © 2020 Carmen Salvador. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = provideMovieListViewController()
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        return true
    }
    
    func provideMovieListViewController() -> UIViewController {
        let movieListViewController = MovieListViewController()
        return UINavigationController(rootViewController: movieListViewController)
    }

}

