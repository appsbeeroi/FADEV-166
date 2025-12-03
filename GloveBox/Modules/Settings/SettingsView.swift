import SwiftUI

struct SettingsView: View {
    
    @AppStorage("hasPush") var hasPush = false
    
    @Binding var hasTabbar: Bool
    
    @State private var isToggleOn = false
    @State private var isShowWeb = false
    @State private var isShowRemoveAlert = false
    @State private var showPushAccessDeniedAlert = false
    
    var body: some View {
        ZStack {
            Color.baseBlack
                .ignoresSafeArea()
            
            VStack {
                navigation
                
                VStack(spacing: 10) {
                    ForEach(HistoryCellType.allCases) { type in
                        Button {
                            switch type {
                                case .about:
                                    hasTabbar = false 
                                    isShowWeb.toggle()
                                case .notification:
                                    return
                                case .history:
                                    isShowRemoveAlert.toggle()
                            }
                        } label: {
                            HStack {
                                Text(type.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.sansita(size: 22))
                                    .foregroundStyle(.white)
                                
                                switch type {
                                    case .about:
                                        Image(.Icons.Buttons.forward)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 40)
                                    case .history:
                                        Image(.Icons.Buttons.remove)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 40)
                                    case .notification:
                                        Toggle(isOn: $isToggleOn) {}
                                            .labelsHidden()
                                }
                            }
                            .frame(height: 78)
                            .padding(.horizontal, 12)
                            .background(Color(hex: "373737"))
                            .cornerRadius(20)
                            .overlay {
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(.white.opacity(0.5), lineWidth: 1)
                            }
                        }
                    }
                }
                .padding()
                .background(Color(hex: "1E1E1E"))
                .cornerRadius(20)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.5), lineWidth: 1)
                })
                .padding(.top)
                .padding(.horizontal, 35)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top)
            .disabled(isShowRemoveAlert)
            
            #warning("link")
            if isShowWeb,
            let url = URL(string: "apple.com") {
                BrowserView(url: url) {
                    isShowWeb = false
                    hasTabbar = true
                }
                .ignoresSafeArea(edges: [.bottom])
            }
            
            if isShowRemoveAlert {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 16) {
                        Text("Clear history")
                            .frame(maxWidth: .infinity)
                            .font(.sansita(size: 35))
                        
                        Text("Are you sure you want to delete the entire history? This action cannot be undone")
                            .font(.sansita(size: 22))
                        
                        HStack {
                            Button {
                                isShowRemoveAlert = false
                            } label: {
                                Text("Cancel")
                                    .frame(width: 103, height: 62)
                                    .background(.blue)
                                    .font(.sansita(size: 22))
                                    .cornerRadius(20)
                            }
                            
                            Button {
                                Task {
                                    await Storage.instance.clear(.document)
                                    await Storage.instance.clear(.history)
                                    await Storage.instance.clear(.service)
                                    
                                    isShowRemoveAlert = false
                                }
                            } label: {
                                Text("Clear")
                                    .frame(width: 103, height: 62)
                                    .background(.red)
                                    .font(.sansita(size: 22))
                                    .cornerRadius(20)
                            }
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal)
                    .background(Color(hex: "1E1E1E"))
                    .foregroundStyle(.white)
                    .cornerRadius(20)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.5), lineWidth: 1)
                    })
                    .padding()
                }
            }
        }
        .animation(.smooth, value: isShowRemoveAlert)
        .onAppear {
            isToggleOn = hasPush
        }
        .onChange(of: isToggleOn) { isOn in
            switch isOn {
                case true:
                    Task {
                        switch await NotificationPermissionService.shared.status {
                            case .granted:
                                hasPush = true
                            case .denied:
                                showPushAccessDeniedAlert.toggle()
                            case .undecided:
                                await NotificationPermissionService.shared.requestPermission()
                        }
                    }
                case false:
                    hasPush = false
            }
        }
        .alert("The push permission denied.", isPresented: $showPushAccessDeniedAlert) {
            Button("Open", role: .destructive) {
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsURL) {
                    UIApplication.shared.open(settingsURL)
                }
            }
        } message: {
            Text("Open settings?")
        }
    }
    
    private var navigation: some View {
        Image(.Icons.narrowPlate)
            .resizable()
            .scaledToFit()
            .frame(width: 260, height: 130)
            .overlay {
                Text("Settings")
                    .font(.sansita(size: 35))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
            }
    }
}


#Preview {
    SettingsView(hasTabbar: .constant(false))
}

