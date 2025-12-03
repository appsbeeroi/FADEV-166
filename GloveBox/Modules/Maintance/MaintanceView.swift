import SwiftUI

struct MaintanceView: View {
    
    @StateObject private var viewModel = MaintanceViewModel()
    
    @Binding var hasTabbar: Bool
    
    var body: some View {
        NavigationStack(path: $viewModel.navPath) {
            ZStack {
                Color.baseBlack
                    .ignoresSafeArea()
                
                VStack {
                    navigation
                    
                    if viewModel.services.isEmpty {
                        BaseStumb(
                            title: "No reminders set\nyet",
                            subtitle: "Are you sure you want to delete the entire history? This action cannot be undone") {
                                hasTabbar = false
                                viewModel.navPath.append(.add(Service(isPreview: false)))
                            }
                    } else {
                        services
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top)
            }
            .navigationDestination(for: MaintanceScreen.self) { screen in
                switch screen {
                    case .add(let service):
                        AddServiceView(
                            service: service,
                            startDateSelected: !service.isLock,
                            endDateSelected: !service.isLock
                        )
                    case .detail(let service):
                        ServiceDetailView(service: service)
                }
            }
            .onAppear {
                viewModel.loadServices()
                hasTabbar = true 
            }
        }
        .environmentObject(viewModel)
    }
    
    private var navigation: some View {
        Image(.Icons.narrowPlate)
            .resizable()
            .scaledToFit()
            .frame(width: 260, height: 130)
            .overlay {
                Text("Maintenance\nReminders")
                    .font(.sansita(size: 35))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
            }
    }
    
    private var services: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 10) {
                HStack(spacing: 10) {
                    Text("Add")
                        .font(.sansita(size: 28))
                        .foregroundStyle(.white)
                    
                    Button {
                        hasTabbar = false
                        viewModel.navPath.append(.add(Service(isPreview: false)))
                    } label: {
                        Image(.Icons.Buttons.add)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                ForEach(viewModel.services) { service in
                    Button {
                        hasTabbar = false 
                        viewModel.navPath.append(.detail(service))
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
                        .background(Color(hex: "373737"))
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
}


#Preview {
    MaintanceView(hasTabbar: .constant(false))
}


