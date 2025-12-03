import SwiftUI

struct InputTextField: View {
    
    @Binding var input: String
    
    let keyboard: UIKeyboardType
    
    @FocusState.Binding var focusState: Bool
    
    init(
        input: Binding<String>,
        keyboard: UIKeyboardType = .default,
        focusState: FocusState<Bool>.Binding
    ) {
        self._input = input
        self.keyboard = keyboard
        self._focusState = focusState
    }
    
    var body: some View {
        HStack {
            TextField("", text: $input, prompt: Text("Write here")
                .font(.sansita(size: 22))
                .foregroundColor(.white.opacity(0.5))
            )
            .font(.sansita(size: 22))
            .focused($focusState)
            .keyboardType(keyboard)
            .foregroundStyle(.white)
            
            if input != "" {
                Button {
                    input = ""
                    focusState = false
                } label: {
                    Image(systemName: "multiply.circle.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
        }
        .frame(height: 70)
        .padding(.horizontal, 12)
        .background(Color(hex: "373737"))
        .cornerRadius(20)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.white.opacity(0.5), lineWidth: 1)
        }
    }
}
