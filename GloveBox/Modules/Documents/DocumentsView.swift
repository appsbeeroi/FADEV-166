import SwiftUI

struct DocumentsView: View {
    
    @StateObject private var viewModel = DocumentViewModel()
    
    @Binding var hasTabbar: Bool
    
    var body: some View {
        NavigationStack(path: $viewModel.navPath) {
            ZStack {
                Color.baseBlack
                    .ignoresSafeArea()
                
                VStack {
                    navigation
                    
                    if viewModel.documents.isEmpty {
                        BaseStumb(
                            title: "No documents added yet",
                            subtitle: "Upload photos or scans of registration, inspection cards, and other important papers") {
                                hasTabbar = false
                                viewModel.navPath.append(.add(Document(isPreview: false)))
                            }
                    } else {
                        documents
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top)
            }
            .navigationDestination(
                for: DocumentsScreen.self,
                destination: { screen in
                    switch screen {
                        case .add(let document):
                            AddDocumentView(
                                document: document,
                                issueDateSelected: !document.isLock,
                                expirationDateSelected: !document.isLock
                            )
                        case .detail(let document):
                            DocumentDetailView(document: document)
                }
            })
            .onAppear {
                hasTabbar = true 
                viewModel.loadDocuments()
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
                Text("Documents")
                    .font(.sansita(size: 35))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
            }
    }
    
    private var documents: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 10) {
                HStack(spacing: 10) {
                    Text("Add")
                        .font(.sansita(size: 28))
                        .foregroundStyle(.white)
                    
                    Button {
                        hasTabbar = false
                        viewModel.navPath.append(.add(Document(isPreview: false)))
                    } label: {
                        Image(.Icons.Buttons.add)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                ForEach(viewModel.documents) { document in
                    Button {
                        hasTabbar = false
                        viewModel.navPath.append(.detail(document))
                    } label: {
                        VStack(spacing: 8) {
                            Text("Diagnostic Card")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.sansita(size: 22))
                            
                            HStack {
                                Image(.Images.calendar)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 43, height: 49)
                                
                                let startDate = document.issueDate.formatted(.dateTime.year().month(.twoDigits).day())
                                    let endDate = document.expirationDate.formatted(.dateTime.year().month(.twoDigits).day())
                                    
                                    Text("\(startDate) - \(endDate)")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .font(.sansita(size: 15))
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
    DocumentsView(hasTabbar: .constant(false))
}


