//
//  ContentView.swift
//  Shared
//
//  Created by 陳鈺翎 on 2021/12/29.
//

import SwiftUI
import ComposableArchitecture

struct Counter: Equatable {
    var count: Int = 0
    var secret = Int.random(in: -100...100)
}

extension Counter {
    var countString: String {
        get { String(count) }
        set { count = Int(newValue) ?? count}
    }
    
    enum CheckResult {
        case lower, equal, higher
    }
    
    var checkResult: CheckResult {
        if count > secret { return .higher }
        else if count < secret { return .lower }
        return .equal
    }
}

enum CounterAction {
    case increment
    case decrement
    case setCount(String)
    case reset
    case playNext
}

struct CounterEnvironment {
    var generateRandom: (ClosedRange<Int>) -> Int
    
    static let live = CounterEnvironment(generateRandom: Int.random)
}

extension CounterEnvironment {
    static let test = CounterEnvironment(generateRandom: { _ in 5 })
}

// 2
let counterReducer = Reducer<Counter, CounterAction, CounterEnvironment> {
    state, action, enviroment in
    switch action {
    case .increment:
        // 3
        state.count += 1
        print("state count +")
        return .none
    case .decrement:
        // 3
        state.count -= 1
        print("state count -")
        return .none
    case .setCount(let text):
        state.countString = text
        return .none
    case .reset:
        state.count = 0
        print("state reset 0")
        return .none
    case .playNext:
        state.count = 0
        //state.secret = Int.random(in: -100...100)
        state.secret = enviroment.generateRandom(-100...100)
        return .none
    }
}.debug()

struct CounterView: View {
    let store: Store<Counter, CounterAction>
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                
                checkLabel(with: viewStore.checkResult)
                HStack {
                    // 1
                    Button("-") { viewStore.send(.decrement) }
                    /*
                    Text("\(viewStore.count)")
                        .foregroundColor(colorCount(value: viewStore.count))
                     */
                    TextField(String(viewStore.count),
                              text: viewStore.binding(get: { state in
                        state.countString
                    }, send: { text in
                            .setCount(text)
                    }))
                        .frame(width: 40)
                        .multilineTextAlignment(.center)
                        .foregroundColor(colorCount(value: viewStore.count))
                    Button("+") { viewStore.send(.increment) }
                }
                
                Button("New Game") {
                    //viewStore.send(.reset)
                    viewStore.send(.playNext)
                }
            }
        }
    }
    
    func colorCount(value: Int) -> Color? {
        if value == 0 { return nil}
        return value < 0 ? .red: .green
    }
    
    func checkLabel(with checkResult: Counter.CheckResult) -> some View {
        switch checkResult {
        case .lower:
            return Label("Lower", systemImage: "lessthan.circle")
                .foregroundColor(.red)
        case .equal:
            return Label("Correct", systemImage: "checkmark.circle")
                .foregroundColor(.green)
        case .higher:
            return Label("Higher", systemImage: "greaterthan.circle")
                .foregroundColor(.red)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CounterView(store: Store(initialState: Counter(),
                                 reducer: counterReducer,
                                 environment: /*CounterEnvironment(generateRandom: { Int.random(in: $0) })*/
                                    .live
                                ))
    }
}
