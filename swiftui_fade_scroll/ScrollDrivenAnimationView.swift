//
//  ScrollDrivenAnimationView.swift
//  swiftui_fade_scroll
//
//  Created by Viet Nguyen Tran on 18/12/24.
//

import SwiftUI


struct ScrollDrivenAnimationView: View {
    // Parameterized texts and thresholds
    let section1Text: String
    let section2Text: String
    let section3Text: String
    let buttonTitle: String
    
    // Thresholds determine when each element starts fading in
    let threshold1: CGFloat
    let threshold2: CGFloat
    let threshold3: CGFloat
    
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader { outerGeo in
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 0) {
                        contentLayer
                            .padding(.top, outerGeo.size.height * 0.67) // Position at bottom third
                            .background(
                                GeometryReader { geo in
                                    Color.clear
                                        .preference(key: ScrollOffsetKey.self, value: geo.frame(in: .named("scrollArea")).minY)
                                }
                            )
                        
                        Spacer().frame(height: 50) // Reduced from outerGeo.size.height to 50
                    }
                }
                .coordinateSpace(name: "scrollArea")
                .onPreferenceChange(ScrollOffsetKey.self) { value in
                    scrollOffset = -value
                }
                
                // Fixed button at bottom
                Button(buttonTitle) {}
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .opacity(opacityForButton)
                    .padding(.bottom, 32)
            }
        }
    }
    
    private var contentLayer: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(section1Text)
                .font(.title2)
                .opacity(opacityForSection1)
            
            Text(section2Text)
                .opacity(opacityForSection2)
            
            Text(section3Text)
                .opacity(opacityForSection3)
        }
        .padding()
        .offset(y: yOffsetForContent)  // Move offset to entire content block
    }
    
    // Animation calculations
    private var opacityForSection1: Double {
        let startFadeOut = threshold2
        let progress = (scrollOffset - startFadeOut) / 100
        return 1.0 - clamp(progress, lower: 0, upper: 1)
    }
    
    private var yOffsetForContent: CGFloat {
        -min(scrollOffset/3, 100)
    }
    
    private var opacityForSection2: Double {
        let fadeInProgress = (scrollOffset - threshold1) / 100
        let fadeOutProgress = (scrollOffset - threshold3) / 100
        return clamp(fadeInProgress, lower: 0, upper: 1) * (1 - clamp(fadeOutProgress, lower: 0, upper: 1))
    }
    
    private var opacityForSection3: Double {
        let progress = (scrollOffset - threshold2) / 100
        return clamp(progress, lower: 0, upper: 1)
    }
    
    private var opacityForButton: Double {
        let progress = (scrollOffset - threshold2) / 100  // Now using threshold2 instead of threshold3
        return clamp(progress, lower: 0, upper: 1)
    }
    
    private func clamp(_ value: CGFloat, lower: CGFloat, upper: CGFloat) -> CGFloat {
        return min(max(value, lower), upper)
    }
}

// Preference key to read scroll offset
struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    ScrollDrivenAnimationView(
        section1Text: "Lorem ipsum dolor sit amet.",
        section2Text: "Sed consequat purus tortor. Quisque et nisi quis nisl malesuada molestie. Proin lacus eros, tincidunt at ornare eu, consectetur a lectus. Sed volutpat rutrum diam interdum gravida. Proin fringilla ante nibh, at interdum enim ultricies sit amet. Quisque sed eros sem. Nam vitae tellus odio.",
        section3Text: "Curabitur fringilla nec urna sit amet eleifend. Suspendisse sodales vitae tellus sit amet dictum. Vivamus condimentum blandit interdum. Donec ac placerat enim. Pellentesque elementum condimentum massa, id condimentum lorem maximus sit amet. Vivamus accumsan imperdiet urna, eget malesuada felis iaculis quis. Nunc orci neque, blandit nec lorem eu, mattis porta erat. Etiam et imperdiet tellus. Nulla ac gravida tellus. Integer imperdiet lorem sed mattis fermentum. Ut ultricies placerat sapien eu scelerisque. In eget lacus a arcu vulputate tempus. Maecenas eget rhoncus tellus. Donec ac justo tortor. Sed rhoncus, arcu sit amet accumsan mattis, urna ex sodales nunc, a volutpat justo erat nec quam.",
        buttonTitle: "Next",
        threshold1: 100,
        threshold2: 300,
        threshold3: 500
    )
}
