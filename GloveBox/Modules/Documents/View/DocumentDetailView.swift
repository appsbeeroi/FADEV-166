import SwiftUI

struct DocumentDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: DocumentViewModel
    
    @State var document: Document
    
    var body: some View {
        ZStack {
            Color.baseBlack
                .ignoresSafeArea()
            
            VStack {
                navigation
                
                VStack(spacing: 16) {
                    if let image = document.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipped()
                            .cornerRadius(20)
                    }
                    
                    Text("Diagnostic Card")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.sansita(size: 35))
                        .foregroundStyle(.white)
                    
                    HStack {
                        Image(.Images.calendar)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        
                        VStack(spacing: 0) {
                            let issueDate = document.issueDate.formatted(.dateTime.year().month(.twoDigits).day())
                            let expirationDate = document.expirationDate.formatted(.dateTime.year().month(.twoDigits).day())
                            
                            Text("\(issueDate) -")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(expirationDate)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .font(.sansita(size: 25))
                        .foregroundStyle(.white)
                    }
                    
                    VStack {
                        Text("Notes")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.sansita(size: 19))
                            .foregroundStyle(.white.opacity(0.5))
                        
                        Text(document.notes)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.sansita(size: 22))
                            .foregroundStyle(.white)
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
                    viewModel.navPath.append(.add(document))
                } label: {
                    Image(.Icons.Buttons.edit)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 70)
                }
                
                Button {
                    viewModel.removeDocument(document)
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
    DocumentDetailView(document: Document(isPreview: true))
}
