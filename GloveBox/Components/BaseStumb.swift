import SwiftUI

struct BaseStumb: View {
    
    let title: String
    let subtitle: String
    let hasPlus: Bool
    let action: () -> Void
    
    init(title: String, subtitle: String, hasPlus: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.hasPlus = hasPlus
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 34) {
            VStack(spacing: 16) {
                Text(title)
                    .font(.sansita(size: 35))
                    .fixedSize(horizontal: false, vertical: true)
                    
                Text(subtitle)
                    .font(.sansita(size: 22))
            }
            .padding(.horizontal)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            
            if hasPlus {
                Button {
                    action()
                } label: {
                    Image(.Icons.Buttons.add)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 30)
        .background(.baseGray)
        .cornerRadius(20)
        .padding(.horizontal, 35)
        .frame(maxHeight: .infinity)
        .padding(.bottom, 100)
    }
}







