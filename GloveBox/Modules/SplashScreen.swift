import SwiftUI

struct SplashScreen: View {
    
    @Binding var hasStart: Bool
    
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            Image(.Images.Splash.splashScreen)
                .resizeImage()
            
            VStack {
                Image(.Images.Splash.gloveBox)
                    .resizable()
                    .scaledToFit()
                    .padding(.horizontal)
                    .padding(.top, 100)
                    .scaleEffect(isAnimating ? 0.8 : 1)
                    .animation(.smooth.repeatCount(5), value: isAnimating)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isAnimating = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    hasStart = true
                }
            }
        }
    }
}

#Preview {
    SplashScreen(hasStart: .constant(false))
}
