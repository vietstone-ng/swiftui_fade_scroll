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
        
//        ScrollDrivenAnimationView(
//            section1Text: "Lorem ipsum dolor sit amet.",
//            section2Text: "Sed consequat purus tortor. Quisque et nisi quis nisl malesuada molestie. Proin lacus eros, tincidunt at ornare eu, consectetur a lectus. Sed volutpat rutrum diam interdum gravida. Proin fringilla ante nibh, at interdum enim ultricies sit amet.",
//            section3Text: "Curabitur fringilla nec urna sit amet eleifend. Suspendisse sodales vitae tellus sit amet dictum. Vivamus condimentum blandit interdum. Donec ac placerat enim. Pellentesque elementum condimentum massa, id condimentum lorem maximus sit amet. Vivamus accumsan imperdiet urna, eget malesuada felis iaculis quis. Nunc orci neque, blandit nec lorem eu, mattis porta erat. Etiam et imperdiet tellus. Nulla ac gravida tellus. Integer imperdiet lorem sed mattis fermentum.",
//            buttonTitle: "Next",
//            threshold1: 100,
//            threshold2: 300,
//            threshold3: 500
//        )
        
        
        AutoAnimatedView(
            section1Text: "Lorem ipsum dolor sit amet.",
            section2Text: "Sed consequat purus tortor. Quisque et nisi quis nisl malesuada molestie. Proin lacus eros, tincidunt at ornare eu, consectetur a lectus. Sed volutpat rutrum diam interdum gravida. Proin fringilla ante nibh, at interdum enim ultricies sit amet.",
            section3Text: "Curabitur fringilla nec urna sit amet eleifend. Suspendisse sodales vitae tellus sit amet dictum. Vivamus condimentum blandit interdum. Donec ac placerat enim. Pellentesque elementum condimentum massa, id condimentum lorem maximus sit amet. Vivamus accumsan imperdiet urna, eget malesuada felis iaculis quis. Nunc orci neque, blandit nec lorem eu, mattis porta erat. Etiam et imperdiet tellus. Nulla ac gravida tellus. Integer imperdiet lorem sed mattis fermentum.",
            buttonTitle: "Next"
        )
    }
}

#Preview {
    ContentView()
}
