//
//  launchpadxApp.swift
//  launchpadx
//
//  Created by xxnuo on 2025/6/10.
//

import SwiftUI
import AppKit

@main
struct launchpadxApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 1024, minHeight: 768)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}
