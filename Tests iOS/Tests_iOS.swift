//
//  Tests_iOS.swift
//  Tests iOS
//
//  Created by 陳鈺翎 on 2021/12/29.
//

import XCTest
import ComposableArchitecture

class Tests_iOS: XCTestCase {
    //TestStore<State, LocalState, Action, LocalAction, Environment> 
    var store: TestStore<Counter, Counter, CounterAction, CounterAction, CounterEnvironment>!
    
    override func setUp() {
        store = TestStore(initialState: Counter(count: Int.random(in: -100...100)), reducer: counterReducer, environment: .test)
    }
    
    func testCounterIncrement() throws {
        store.send(.increment) { state in
            state.count += 1
        }
    }

    func testCounterDecrement() throws {
        store.send(.decrement) { state in
            state.count -= 1
        }
    }
    
    func testCounterReset() throws {
        store.send(.reset) { state in
            state.count = 0
        }
    }
    
    func testCounterPlayNext() throws {
        store.send(.playNext) { state in
            state = Counter(count: 0, secret: 5)
        }
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
