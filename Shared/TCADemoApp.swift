//
//  TCADemoApp.swift
//  Shared
//
//  Created by 陳鈺翎 on 2021/12/29.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCADemoApp: App {
    var body: some Scene {
        WindowGroup {
            CounterView(store: Store(initialState: Counter(),
                                     reducer: counterReducer,
                                     environment: /*CounterEnvironment(generateRandom: { Int.random(in: $0) })*/
                                        .live
                                    ))
        }
    }
}
