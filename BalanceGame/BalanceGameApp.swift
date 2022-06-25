//
//  BalanceGameApp.swift
//  BalanceGame
//
//  Created by Gustavo da Silva Braghin on 22/06/22.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var isOn: Bool
    
    init(isOn: Bool) {
        self.isOn = isOn
    }
}


@main
struct BalanceGameApp: App {
    var body: some Scene {
        WindowGroup {
            AccelerometerView()
                .environmentObject(AppState(isOn: false))
        }
    }
}
