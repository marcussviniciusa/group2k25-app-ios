//
//  group2k25App.swift
//  group2k25
//
//  Created by Marcus Vinicius Araujo Mendonca Trindade on 08/02/26.
//

import SwiftUI

@main
struct group2k25App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
