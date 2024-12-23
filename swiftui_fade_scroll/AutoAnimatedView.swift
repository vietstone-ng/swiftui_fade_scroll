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
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 0) {
                        contentLayer
                            .padding(.top, geo.size.height * 0.5)
                            .background(
                                GeometryReader { contentGeo in
                                    Color.clear.onAppear {
                                        startAnimation()
                                    }
                                }
                            )
                        Spacer().frame(height: 30)
                    }
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
        }
    }
    
    private var contentLayer: some View {
        let s1Opacity = opacityForSection1
        let s2Opacity = opacityForSection2
        let s3Opacity = opacityForSection3
        
        return VStack(alignment: .leading, spacing: 16) {
            Text(section1Text)
                .font(.title2)
                .opacity(s1Opacity)
            
            Text(section2Text)
                .opacity(s2Opacity)
            
            Text(section3Text)
                .opacity(s3Opacity)
        }
        .padding()
        .offset(y: -animationProgress * 300) // Increased scroll amount
    }
    
    private var opacityForSection1: Double {
        if animationProgress < 0.3 {
            return 1.0 // Fully visible initially
        } else {
            return 0.7 // Fade to 70% when section 2 appears
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
            return 0.7 // Fade to 70% when section 3 appears
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
        
        // Animation timer to update progress
        let duration: TimeInterval = 2.5 // Reduced from 10.0 to 2.5 seconds
        let updateInterval: TimeInterval = 0.0083 // ~120fps
        let progressPerStep = updateInterval / duration
        
        animationTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { timer in
            if animationProgress >= 1.0 {
                timer.invalidate()
                animationTimer = nil
            } else {
                withAnimation(.linear(duration: updateInterval)) {
                    animationProgress += progressPerStep
                }
            }
        }
        
        // Separate timer for logging
        logTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            let s1 = opacityForSection1
            let s2 = opacityForSection2
            let s3 = opacityForSection3
            print("Progress: \(String(format: "%.2f", animationProgress)) | Opacities: S1=\(String(format: "%.2f", s1)) S2=\(String(format: "%.2f", s2)) S3=\(String(format: "%.2f", s3))")
        }
        
        // Stop logging timer after animation completes
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            logTimer?.invalidate()
            logTimer = nil
        }
    }
    
    private func clamp(_ value: CGFloat, lower: CGFloat, upper: CGFloat) -> CGFloat {
        min(max(value, lower), upper)
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
