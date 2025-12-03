import SwiftUI

struct HistoryDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: HistoryViewModel
    
    @State var history: History
    
    var body: some View {
        ZStack {
            Color.baseBlack
                .ignoresSafeArea()
            
            VStack {
                navigation
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        VStack(spacing: 16) {
                            VStack {
                                Text("Service Type")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.sansita(size: 25))
                                
                                
                                if let service = history.service {
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
                        }
                        .padding(.vertical)
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
                    
                    VStack(spacing: 16) {
                        VStack(spacing: 24) {
                            HStack {
                                Image(.Images.calendar)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                
                                Text(history.date.formatted(.dateTime.year().month(.twoDigits).day()))
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .font(.sansita(size: 32))
                            }
                            
                            HStack {
                                Image(.Images.milliage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                
                                Text("\(history.milliage)km")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .font(.sansita(size: 32))
                            }
                        }
                        
                        if let image = history.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 114, height: 114)
                                .clipped()
                                .cornerRadius(20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        VStack {
                            Text("Notes")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.sansita(size: 19))
                                .foregroundStyle(.white.opacity(0.5))
                            
                            Text(history.notes)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.sansita(size: 22))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Text("$\(history.cost)")
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .font(.sansita(size: 48))
                            .foregroundStyle(.white)
                    }
                    .padding(.vertical)
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
                    viewModel.navPath.append(.addService(history))
                } label: {
                    Image(.Icons.Buttons.edit)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 70)
                }
                
                Button {
                    viewModel.removeHistory(history)
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
    HistoryDetailView(history: History(isPreview: true))
}
