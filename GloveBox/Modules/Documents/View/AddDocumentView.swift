import SwiftUI

struct AddDocumentView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: DocumentViewModel
    
    @State var document: Document
    
    @State var issueDateSelected: Bool
    @State var expirationDateSelected: Bool
    
    @State private var isIssuetDate = false
    @State private var isShowDatePicker = false
    @State private var isShowImagePicker = false
    
    @FocusState var focusState: Bool
    
    var body: some View {
        ZStack {
            Color.baseBlack
                .ignoresSafeArea()
            
            VStack {
                navigation
                
                VStack {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            imagePicker
                            dates
                            type
                            notes
                        }
                        .padding(.vertical, 24)
                        .padding(.horizontal, 10)
                        .background(Color(hex: "1E1E1E"))
                        .cornerRadius(20)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white.opacity(0.5), lineWidth: 1)
                        }
                        .padding(.top, 1)
                        .padding(.horizontal, 30)
                    }
                }
                
                doneButton
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top)
            .disabled(isShowDatePicker)
            
            if isShowDatePicker {
                datePicker
            }
        }
        .navigationBarBackButtonHidden()
        .animation(.smooth, value: isShowDatePicker)
        .sheet(isPresented: $isShowImagePicker, content: {
            ImagePicker(selectedImage: $document.image)
        })
        .onChange(of: document.issueDate) { _ in
            issueDateSelected = true
        }
        .onChange(of: document.expirationDate) { _ in
            expirationDateSelected = true
        }
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
    
    private var datePicker: some View {
        ZStack {
            Color.baseBlack
                .ignoresSafeArea()
            
            VStack {
                Button("Done") {
                    withAnimation {
                        isShowDatePicker = false
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                DatePicker(
                    "",
                    selection: isIssuetDate ? $document.issueDate : $document.expirationDate,
                    displayedComponents: [.date]
                )
                .labelsHidden()
                .datePickerStyle(.graphical)
            }
            .padding()
            .background(.white)
            .cornerRadius(20)
            .padding(.horizontal, 20)
        }
    }
    
    private var imagePicker: some View {
        Button {
            isShowImagePicker.toggle()
        } label: {
            ZStack {
                if let image = document.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .cornerRadius(20)
                } else {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 150, height: 150)
                        .foregroundStyle(Color(hex: "1E1E1E"))
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white.opacity(0.5), lineWidth: 1)
                        }
                }
                
                Image(systemName: "photo.stack")
                    .font(.system(size: 60, weight: .medium))
                    .foregroundStyle(.white.opacity(0.5))
            }
        }
    }
    
    private var dates: some View {
        HStack(spacing: 8) {
            Button {
                isIssuetDate = true
                isShowDatePicker.toggle()
            } label: {
                HStack {
                    let date = document.issueDate.formatted(.dateTime.year().month(.twoDigits).day())
                    
                    Text(issueDateSelected ? date : "Issue")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.sansita(size: 17))
                        .foregroundStyle(.white.opacity(issueDateSelected ? 1 : 0.5))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    
                    Image(.Images.calendar)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                .frame(height: 72)
                .padding(.horizontal, 12)
                .background(Color(hex: "1E1E1E"))
                .cornerRadius(20)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(.white.opacity(0.5), lineWidth: 1)
                }
                
                Button {
                    isIssuetDate = false
                    isShowDatePicker.toggle()
                } label: {
                    HStack {
                        let date = document.expirationDate.formatted(.dateTime.year().month(.twoDigits).day())
                        
                        Text(expirationDateSelected ? date : "Expitation")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.sansita(size: 17))
                            .foregroundStyle(.white.opacity(issueDateSelected ? 1 : 0.5))
                        
                        Image(.Images.calendar)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    .frame(height: 72)
                    .padding(.horizontal, 12)
                    .background(Color(hex: "1E1E1E"))
                    .cornerRadius(20)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white.opacity(0.5), lineWidth: 1)
                    }
                }
            }
        }
    }
    
    private var type: some View {
        VStack {
            Text("Document Type")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.sansita(size: 19))
                .foregroundStyle(.white)
            
            InputTextField(input: $document.type, focusState: $focusState)
        }
    }
    
    private var notes: some View {
        VStack {
            Text("Notes")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.sansita(size: 19))
                .foregroundStyle(.white)
            
            InputTextField(input: $document.notes, focusState: $focusState)
        }
    }
    
    private var doneButton: some View {
        Button {
            viewModel.saveDocument(document)
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
                        .opacity(document.isLock ? 0.3 : 1)
                }
        }
        .disabled(document.isLock)
    }
}

#Preview {
    AddDocumentView(document: Document(isPreview: false), issueDateSelected: false, expirationDateSelected: false)
}

#Preview {
    AddDocumentView(document: Document(isPreview: true), issueDateSelected: true, expirationDateSelected: true)
}

