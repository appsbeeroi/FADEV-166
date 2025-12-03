import SwiftUI

struct ContentView: View {
    
    @State private var hasStart = false
    
    var body: some View {
        if hasStart {
            AppTabView()
        } else {
            SplashScreen(hasStart: $hasStart)
        }
    }
}

#Preview {
    ContentView()
}

