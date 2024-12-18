//
//  ContentView.swift
//  swiftui_fade_scroll
//
//  Created by Viet Nguyen Tran on 18/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
        
        ScrollDrivenAnimationView(
                    section1Text: "Lorem ipsum dolor sit amet.",
                    section2Text: "Consectetur adipiscing elit. Donec vehicula.",
                    section3Text: "Vestibulum ante ipsum primis in faucibus.",
                    buttonTitle: "Next",
                    threshold1: 50,
                    threshold2: 200,
                    threshold3: 350
                )
    }
}

#Preview {
    ContentView()
}
