import SwiftUI

struct AddHistoryView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: HistoryViewModel
    
    @State var history: History
    
    @State var hasDateSelected: Bool
    
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
                            VStack(spacing: 20) {
                                imagePicker
                                date
                                milliage
                                cost
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
                            
                            doneButton
                        }
                        .toolbar {
                            ToolbarItem(placement: .keyboard) {
                                Button("Done") {
                                    focusState = false
                                }
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                }
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
            ImagePicker(selectedImage: $history.image)
        })
        .onChange(of: history.date) { _ in
            hasDateSelected = true
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
    
    private var imagePicker: some View {
        Button {
            isShowImagePicker.toggle()
        } label: {
            ZStack {
                if let image = history.image {
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
    
    private var date: some View {
        Button {
            isShowDatePicker.toggle()
        } label: {
            HStack {
                let date = history.date.formatted(.dateTime.year().month(.twoDigits).day())
                
                Text(hasDateSelected ? date : "Select date")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.sansita(size: 17))
                    .foregroundStyle(.white.opacity(hasDateSelected ? 1 : 0.5))
                
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
                    selection: $history.date,
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
    
    private var milliage: some View {
        VStack {
            Text("Mileage")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.sansita(size: 19))
                .foregroundStyle(.white)
            
            InputTextField(input: $history.milliage, keyboard: .numberPad, focusState: $focusState)
        }
    }
    
    private var cost: some View {
        VStack {
            Text("Cost")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.sansita(size: 19))
                .foregroundStyle(.white)
            
            InputTextField(input: $history.cost, keyboard: .numberPad,  focusState: $focusState)
        }
    }
    
    private var notes: some View {
        VStack {
            Text("Notes")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.sansita(size: 19))
                .foregroundStyle(.white)
            
            InputTextField(input: $history.notes, focusState: $focusState)
        }
    }
    
    private var doneButton: some View {
        Button {
            viewModel.saveHistory(history)
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
                        .opacity(history.isLock ? 0.3 : 1)
                }
        }
        .disabled(history.isLock)
    }
}

#Preview {
    AddHistoryView(history: History(isPreview: false), hasDateSelected: false)
}

#Preview {
    AddHistoryView(history: History(isPreview: true), hasDateSelected: true)
}
