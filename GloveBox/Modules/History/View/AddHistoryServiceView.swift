import SwiftUI

struct AddHistoryServiceView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var history: History
    
    @EnvironmentObject var viewModel: HistoryViewModel
    
    var body: some View {
        ZStack {
            Color.baseBlack
                .ignoresSafeArea()
            
            VStack {
                navigation
                services
                doneButton
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
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 35)
    }
    
    private var services: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 10) {
                ForEach(viewModel.services) { service in
                    Button {
                        history.service = service
                    } label: {
                        VStack(spacing: 8) {
                            Text(service.name)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.sansita(size: 22))
                            
                            HStack {
                                if let type = service.type {
                                    Image(type.icon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 48, height: 48)
                                    
                                    if type == .byDate {
                                        let startDate = service.startDate.formatted(.dateTime.year().month(.twoDigits).day())
                                        let endDate = service.endDate.formatted(.dateTime.year().month(.twoDigits).day())
                                        
                                        Text("\(startDate) - \(endDate)")
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .font(.sansita(size: 15))
                                    } else {
                                        HStack(spacing: 0) {
                                            Text(service.milleage)
                                                .font(.sansita(size: 24))
                                            
                                            Text("km")
                                                .font(.sansita(size: 15))
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                        }
                        .padding(16)
                        .background(history.service == service ? Color(hex: "616161") : Color(hex: "373737"))
                        .cornerRadius(20)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white.opacity(0.5), lineWidth: 1)
                        }
                    }
                }
                .foregroundStyle(.white)
            }
            .padding(11)
            .background(.baseGray)
            .cornerRadius(20)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white.opacity(0.5), lineWidth: 1)
            }
            .padding(.top, 1)
            .padding(.horizontal, 35)
        }
        .padding(.bottom, 110)
    }
    
    private var doneButton: some View {
        Button {
            viewModel.navPath.append(.add(history))
        } label: {
            Image(.Icons.plate)
                .resizable()
                .scaledToFit()
                .frame(width: 138, height: 96)
                .overlay {
                    Text("Done")
                        .font(.sansita(size: 30))
                        .offset(y: -5)
                        .foregroundStyle(.baseBlack)
                        .opacity(history.service == nil ? 0.3 : 1)
                }
        }
        .disabled(history.service == nil)
    }
}

#Preview {
    AddHistoryServiceView(history: History(isPreview: true))
        .environmentObject(HistoryViewModel())
}
