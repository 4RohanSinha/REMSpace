//
//  SceneDelegate.swift
//  REMSpace
//
//  Created by Rohan Sinha on 3/12/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let dataController = DataController(modelName: "REMSpace")

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        dataController.load()
        
        let tabBarController = (window?.rootViewController as? UINavigationController)?.topViewController as? LandingPageVC
        tabBarController?.dataController = dataController
        ActivityRecommender.initialize(dataController: dataController)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        //(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        try? dataController.viewContext.save()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let urlContexts = Array(URLContexts)
        let urls = urlContexts.map { $0.url }
        for url in urls {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
            if components?.scheme! == "remspace" {//} && components?.path == "authenticate" {
                var path = components?.path
                
                components?.path = "/" + (path?.replacingOccurrences(of: "#", with: "?"))!
                
                let questionIndex = components?.path.firstIndex(of: "?")!
                let pathStr = components?.path.substring(to: questionIndex!)
                let queryStr = components?.path.substring(from: (components?.path.index(after: questionIndex!))!)
                
                components?.path = pathStr!
                components?.query = queryStr!

                
                if let queryItems = components?.queryItems {
                    for queryItem in queryItems {
                        if let queryValue = queryItem.value, let landingPageVC = (window?.rootViewController as? UINavigationController)?.topViewController as? LandingPageVC, queryItem.name == "access_token" {
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            UserDefaults.standard.set(queryValue, forKey: "ouraAccessToken")
                            OuraClient.fetchPersonalInfo( completion: landingPageVC.onPersonalInfoComplete(response:error:))
                            
                            //MARK: only call this method every few times each day + whenever you login or log out + maybe reload button
                            OuraClient.fetchSleepData(completion: landingPageVC.onSleepDataComplete(response:error:))

                        }
                    }
                }
            }
        }
    }


}

