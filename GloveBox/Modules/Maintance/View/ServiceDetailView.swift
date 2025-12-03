import SwiftUI

struct ServiceDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: MaintanceViewModel
    
    @State var service: Service
    
    var body: some View {
        ZStack {
            Color.baseBlack
                .ignoresSafeArea()
            
            VStack {
                navigation
                
                VStack(spacing: 24) {
                    Text(service.name)
                        .font(.sansita(size: 35))
                    
                    HStack {
                        if let type = service.type {
                            Image(type.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                        }
                        
                        HStack {
                            if service.type == .byDate {
                                let startDate = service.startDate.formatted(.dateTime.year().month(.twoDigits).day())
                                let endDate = service.endDate.formatted(.dateTime.year().month(.twoDigits).day())
                                
                                Text("\(startDate) - \(endDate)")
                                    .font(.sansita(size: 22))
                            } else {
                                HStack(spacing: 0) {
                                    Text(service.milleage)
                                        .font(.sansita(size: 36))
                                        
                                    Text("km")
                                        .frame(maxHeight: .infinity, alignment: .bottom)
                                        .font(.sansita(size: 16))
                                }
                                .frame(height: 30)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                    }
                }
                .padding(.vertical, 24)
                .padding(.horizontal)
                .background(Color(hex: "1E1E1E"))
                .cornerRadius(20)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.5), lineWidth: 1)
                })
                .padding(.top, 24)
                .padding(.horizontal, 30)
                .foregroundStyle(.white)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top)
        }
        .navigationBarBackButtonHidden()
    }
    
    private var navigation: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(.Icons.Buttons.back)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 75)
            }
            
            HStack(spacing: 0) {
                Button {
                    viewModel.navPath.append(.add(service))
                } label: {
                    Image(.Icons.Buttons.edit)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 70)
                }
                
                Button {
                    viewModel.removeService(service)
                } label: {
                    Image(.Icons.Buttons.remove)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 70)
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 35)
    }
}

#Preview {
    ServiceDetailView(service: Service(isPreview: true))
}


