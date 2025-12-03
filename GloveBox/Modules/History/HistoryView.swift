import SwiftUI

struct HistoryView: View {
    
    @StateObject private var viewModel = HistoryViewModel()
    
    @Binding var hasTabbar: Bool
    
    var body: some View {
        NavigationStack(path: $viewModel.navPath) {
            ZStack {
                Color.baseBlack
                    .ignoresSafeArea()
                
                VStack {
                    navigation
                    
                    if viewModel.histories.isEmpty {
                        stumb
                    } else {
                        histories
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top)
            }
            .navigationDestination(for: HistoryScreen.self, destination: { screen in
                switch screen {
                    case .addService(let history):
                        AddHistoryServiceView(history: history)
                    case .add(let history):
                        AddHistoryView(history: history, hasDateSelected: !history.isLock)
                    case .detail(let history):
                        HistoryDetailView(history: history)
                }
            })
            .onAppear {
                hasTabbar = true
                viewModel.loadHistories()
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
                Text("Service\nHistory")
                    .font(.sansita(size: 35))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
            }
    }
    
    private var stumb: some View {
        BaseStumb(
            title: viewModel.services.isEmpty ? "Add services to start tracking history" : "No service records yet",
            subtitle: viewModel.services.isEmpty ? "" : "Log your completed maintenance to track mileage, dates, and work done",
            hasPlus: !viewModel.services.isEmpty) {
                hasTabbar = false
                viewModel.navPath.append(.addService(History(isPreview: false)))
            }
    }
    
    private var histories: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 10) {
                HStack(spacing: 10) {
                    Text("Add")
                        .font(.sansita(size: 28))
                        .foregroundStyle(.white)
                    
                    Button {
                        hasTabbar = false
                        viewModel.navPath.append(.addService(History(isPreview: false)))
                    } label: {
                        Image(.Icons.Buttons.add)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                ForEach(viewModel.histories) { history in
                    Button {
                        hasTabbar = false
                        viewModel.navPath.append(.detail(history))
                    } label: {
                        VStack(spacing: 8) {
                            HStack(spacing: 5) {
                                VStack {
                                    Image(.Images.calendar)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                    
                                    let date = history.date.formatted(.dateTime.year().month(.twoDigits).day())
                                    
                                    Text(date)
                                        .frame(maxWidth: .infinity)
                                        .minimumScaleFactor(0.7)
                                }
                                .padding(16)
                                .frame(height: 93)
                                .background(Color(hex: "373737"))
                                .cornerRadius(20)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.white.opacity(0.5), lineWidth: 1)
                                }
                                
                                VStack {
                                    Image(.Images.milliage)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 40, height: 40)
                                    
                                    Text("\(history.milliage)km")
                                        .frame(maxWidth: .infinity)
                                        .minimumScaleFactor(0.7)
                                }
                                .padding(16)
                                .frame(height: 93)
                                .background(Color(hex: "373737"))
                                .cornerRadius(20)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(.white.opacity(0.5), lineWidth: 1)
                                }
                            }
                            .font(.sansita(size: 20))
                        
                            Text("$\(history.cost)")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .font(.sansita(size: 48))
                        }
                        .padding()
                        .background(Color(hex: "2A2A2A"))
                        .cornerRadius(20)
                    }
                    .foregroundStyle(.white)
                }
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
    HistoryView(hasTabbar: .constant(false))
}



