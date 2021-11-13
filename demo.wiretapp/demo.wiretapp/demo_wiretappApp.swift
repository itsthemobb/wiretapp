//
//  demo_wiretappApp.swift
//  demo.wiretapp
//
//  Created by Muhammad Usman Ali (LCL) on 2021-11-13.
//

import SwiftUI

@main
struct demo_wiretappApp: App {
    var body: some Scene {
        setup()
        return WindowGroup {
            ContentView(networkService: NetworkService(baseURL: "https://google.com"))
        }
    }

    func setup() {
        MockURLProtocol.configureMock()
    }
}
