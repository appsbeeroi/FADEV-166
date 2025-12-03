import SwiftUI

struct AddServiceView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var viewModel: MaintanceViewModel
    
    @State var service: Service
    
    @State var startDateSelected: Bool
    @State var endDateSelected: Bool
    
    @State private var isStartDate = false
    @State private var isShowDatePicker = false
    @State private var isShowMilliageInput = false
    
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
                            selectType
                            rangeSelection
                            
                            if service.type == .byDate {
                                startDate
                                endDate
                            }
                        }
                        .padding(.top, 24)
                        .padding(.horizontal, 35)
                        .animation(.default, value: service.type)
                    }
                }
                
                doneButton
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top)
            .disabled(isShowMilliageInput)
            .disabled(isShowDatePicker)
            
            if isShowDatePicker {
                datePicker
            }
            
            if isShowMilliageInput {
                milliageInput
            }
        }
        .navigationBarBackButtonHidden()
        .animation(.smooth, value: isShowMilliageInput)
        .onChange(of: service.startDate) { _ in
            startDateSelected = true
        }
        .onChange(of: service.endDate) { _ in
            endDateSelected = true
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
    
    private var selectType: some View {
        VStack(spacing: 4) {
            Text("Service Type")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.sansita(size: 19))
                .foregroundStyle(.white)
            
            InputTextField(input: $service.name, focusState: $focusState)
        }
    }
    
    private var rangeSelection: some View {
        VStack {
            Text("Range selection")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.sansita(size: 19))
                .foregroundStyle(.white)
            
            HStack {
                ForEach(ServiceRangeType.allCases) { type in
                    Button {
                        service.type = type
                        
                        if type == .byMilleage {
                            isShowMilliageInput.toggle()
                        }
                    } label: {
                        VStack {
                            Image(type.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 75, height: 75)
                            
                            Text(type.title)
                                .font(.sansita(size: 22))
                                .foregroundStyle(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .background(service.type == type ? Color(hex: "616161") : Color(hex: "373737"))
                        .cornerRadius(20)
                        .overlay {
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(.white.opacity(0.5), lineWidth: 1)
                        }
                    }
                }
            }
        }
    }
    
    private var startDate: some View {
        Button {
            isStartDate = true
            
            withAnimation {
                isShowDatePicker.toggle()
            }
        } label: {
            HStack {
                let date = service.startDate.formatted(.dateTime.year().month(.twoDigits).day())
                
                Text(startDateSelected ? date : "Select date")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.sansita(size: 22))
                    .foregroundStyle(.white)
            }
            .frame(height: 70)
            .padding(.horizontal, 12)
            .background(Color(hex: "373737"))
            .opacity(startDateSelected ? 1 : 0.5)
            .cornerRadius(20)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white.opacity(0.5), lineWidth: 1)
            }
        }
    }
    
    private var endDate: some View {
        Button {
            isStartDate = false
            
            withAnimation {
                isShowDatePicker.toggle()
            }
        } label: {
            HStack {
                let date = service.endDate.formatted(.dateTime.year().month(.twoDigits).day())
                
                Text(endDateSelected ? date : "Select date")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.sansita(size: 22))
                    .foregroundStyle(.white)
            }
            .frame(height: 70)
            .padding(.horizontal, 12)
            .background(Color(hex: "373737"))
            .opacity(startDateSelected ? 1 : 0.5)
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
                    selection: isStartDate ? $service.startDate : $service.endDate,
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
    
    private var doneButton: some View {
        Button {
            viewModel.saveService(service)
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
                        .opacity(service.isLock ? 0.3 : 1)
                }
        }
        .disabled(service.isLock)
    }
    
    private var milliageInput: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            
            VStack {
                VStack(spacing: 16) {
                    Button {
                        isShowMilliageInput = false
                    } label: {
                        Image(systemName: "multiply")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    Text("Interval Value")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.sansita(size: 19))
                        .foregroundStyle(.white)
                    
                    InputTextField(input: $service.milleage, focusState: $focusState)
                }
                
                Button {
                    isShowMilliageInput = false
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
                                .opacity(service.milleage == "" ? 0.3 : 1)
                        }
                        .disabled(service.milleage == "")
                }
            }
            .padding(.vertical)
            .padding(.horizontal)
            .padding(.bottom, 24)
            .background(Color(hex: "151515"))
            .cornerRadius(20)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.white.opacity(0.5), lineWidth: 1)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    AddServiceView(
        service: Service(isPreview: true),
        startDateSelected: false,
        endDateSelected: false
    )
}

#Preview {
    AddServiceView(
        service: Service(isPreview: false),
        startDateSelected: false,
        endDateSelected: false
    )
}

