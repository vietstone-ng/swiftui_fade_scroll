import SwiftUI

struct AutoAnimatedView: View {
    let section1Text: String
    let section2Text: String
    let section3Text: String
    let buttonTitle: String
    
    @State private var animationProgress: CGFloat = 0
    @State private var isAnimating = false
    @State private var animationTimer: Timer?
    @State private var logTimer: Timer?
    @State private var contentHeight: CGFloat = 0
    @State private var scrollEnabled: Bool = false
    @State private var finalOffset: CGFloat = 0
    @State private var animationCompleted: Bool = false
    @State private var pauseRemaining: Double = 0
    
    private enum AnimationPhase {
        case section1
        case pauseForSection2
        case section2
        case pauseForSection3
        case section3
        case completed
    }
    
    private func currentPhase(for progress: CGFloat) -> AnimationPhase {
        if progress >= 1.0 { return .completed }
        if progress >= 0.8 { return .section3 }
        if progress >= 0.7 { return .pauseForSection3 }
        if progress >= 0.35 { return .section2 }
        if progress >= 0.3 { return .pauseForSection2 }
        return .section1
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                if animationCompleted {
                    // After animation: ScrollView if needed
                    ScrollView {
                        contentBlock(in: geo)
                    }
                } else {
                    // During animation: Direct view with offset
                    contentBlock(in: geo)
                }
                
                Button(buttonTitle) {}
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(Color.blue.opacity(0.8))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .opacity(opacityForButton)
                    .padding(.bottom, 32)
            }
            .onAppear {
                startAnimation()
            }
        }
    }
    
    private func contentBlock(in geo: GeometryProxy) -> some View {
        VStack(spacing: 0) {
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
            .background(
                GeometryReader { contentGeo in
                    Color.clear
                        .preference(key: ContentHeightKey.self, value: contentGeo.size.height)
                }
            )
        }
        .padding(.top, animationCompleted ? 0 : geo.size.height * 0.5)
        .offset(y: animationCompleted ? 0 : -animationProgress * geo.size.height * 0.5)
        .onPreferenceChange(ContentHeightKey.self) { height in
            contentHeight = height
        }
        .modifier(
            LoggingModifier(
                animationProgress: animationProgress,
                s1: opacityForSection1,
                s2: opacityForSection2,
                s3: opacityForSection3
            )
        )
    }
    
    private var opacityForSection1: Double {
        if animationProgress < 0.3 {
            return 1.0 // Fully visible initially
        } else {
            return 0.5 // Fade to 50% when section 2 appears
        }
    }
    
    private var opacityForSection2: Double {
        if animationProgress < 0.2 {
            return 0 // Hidden initially
        } else if animationProgress < 0.35 {
            return (animationProgress - 0.2) / 0.15 // Fade in faster
        } else if animationProgress < 0.7 {
            return 1.0 // Stay fully visible longer
        } else {
            return 0.5 // Fade to 50% when section 3 appears
        }
    }
    
    private var opacityForSection3: Double {
//        return 0
        if animationProgress < 0.8 {  // Start later, after section 2 is visible
            return 0
        } else {
            return min((animationProgress - 0.8) / 0.1, 1)
        }
    }
    
    private var opacityForButton: Double {
        opacityForSection3
    }
    
    private func startAnimation() {
        guard !isAnimating else { return }
        isAnimating = true
        animationProgress = 0
        
        let totalDuration: Double = 1.0  // Total animation duration
        let stepCount = 120  // More steps for smoother animation
        let stepDuration = totalDuration / Double(stepCount)  // Will be about 0.017s (roughly 60fps)
        var stepIndex = 0
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: stepDuration, repeats: true) { timer in
            let currentPhase = currentPhase(for: animationProgress)
            
            // Handle pauses at transition points
            if currentPhase == .pauseForSection2 || currentPhase == .pauseForSection3 {
                if pauseRemaining == 0 {
                    pauseRemaining = 0.3 // Shorter pause (300ms) to keep things flowing
                }
                
                pauseRemaining -= stepDuration
                if pauseRemaining > 0 {
                    return
                }
            }
            
            stepIndex += 1
            let rawFraction = CGFloat(stepIndex) / CGFloat(stepCount)
            let fraction = clamp(rawFraction, lower: 0, upper: 1)
            
            withAnimation(.easeInOut(duration: stepDuration)) { // Changed to easeInOut for smoother transitions
                animationProgress = fraction
            }
            
            if fraction >= 1.0 {
                timer.invalidate()
                animationCompleted = true
            }
        }
    }
    
    private func clamp(_ value: CGFloat, lower: CGFloat, upper: CGFloat) -> CGFloat {
        min(max(value, lower), upper)
    }
}

// Add preference key for content height
struct ContentHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// Add the logging modifier
struct LoggingModifier: AnimatableModifier {
    var animationProgress: CGFloat
    var s1: Double
    var s2: Double
    var s3: Double

    var animatableData: CGFloat {
        get { animationProgress }
        set {
            animationProgress = newValue
            print(
                "animationProgress: \(String(format: "%.2f", animationProgress)),",
                "Section1: \(String(format: "%.2f", s1))",
                "Section2: \(String(format: "%.2f", s2))",
                "Section3: \(String(format: "%.2f", s3))"
            )
        }
    }

    func body(content: Content) -> some View {
        content
    }
}

#Preview {
    AutoAnimatedView(
        section1Text: "First section appears centered.",
        section2Text: "Second section fades in as we scroll.",
        section3Text: "Third section appears last with the button.",
        buttonTitle: "Next"
    )
}
