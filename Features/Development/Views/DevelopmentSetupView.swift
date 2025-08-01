import SwiftUI
import CoreData

struct DevelopmentSetupView: View {
    @StateObject private var viewModel = DevelopmentSetupViewModel()
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                DevelopmentParametersView(viewModel: viewModel)
                
                if let calculatedTime = viewModel.calculatedTime {
                    CalculatedTimeSection(
                        time: calculatedTime,
                        temperature: viewModel.temperature,
                        filmName: viewModel.selectedFilm?.name ?? "",
                        developerName: viewModel.selectedDeveloper?.name ?? "",
                        onCalculatorTap: {
                            viewModel.navigateToCalculator = true
                        },
                        onTimerTap: {
                            viewModel.navigateToTimer = true
                        }
                    )
                }
                
//                #if DEBUG
//                Button("Force Reload Data") {
//                    viewModel.reloadData()
//                }
//                .foregroundColor(.blue)
//                .padding()
//                #endif
                
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.showFilmPicker) {
            FilmPickerView(
                films: viewModel.films,
                selectedFilm: $viewModel.selectedFilm,
                iso: $viewModel.iso,
                onDismiss: { viewModel.showFilmPicker = false },
                onFilmSelected: { film in
                    viewModel.selectFilm(film)
                }
            )
        }
        .sheet(isPresented: $viewModel.showDeveloperPicker) {
            DeveloperPickerView(
                developers: viewModel.developers,
                selectedDeveloper: $viewModel.selectedDeveloper,
                selectedDilution: $viewModel.selectedDilution,
                onDismiss: { viewModel.showDeveloperPicker = false },
                onDeveloperSelected: { developer in
                    viewModel.selectDeveloper(developer)
                }
            )
        }
        .sheet(isPresented: $viewModel.showDilutionPicker) {
            DilutionPickerView(
                dilutions: viewModel.getAvailableDilutions(),
                selectedDilution: $viewModel.selectedDilution,
                onDismiss: { viewModel.showDilutionPicker = false },
                isDisabled: viewModel.selectedFilm == nil || viewModel.selectedDeveloper == nil,
                onDilutionSelected: { dilution in
                    viewModel.selectDilution(dilution)
                }
            )
        }
        .sheet(isPresented: $viewModel.showISOPicker) {
            ISOPickerView(
                iso: $viewModel.iso,
                onDismiss: { viewModel.showISOPicker = false },
                availableISOs: viewModel.getAvailableISOs()
            )
        }
        .sheet(isPresented: $viewModel.showTemperaturePicker) {
            TemperaturePickerView(
                temperature: $viewModel.temperature,
                onDismiss: { viewModel.showTemperaturePicker = false }
            )
        }
        .navigationDestination(isPresented: $viewModel.navigateToCalculator) {
            if let calculatedTime = viewModel.calculatedTime {
                CalculatorView(initialTime: calculatedTime, initialTemperature: viewModel.temperature)
            }
        }
        .navigationDestination(isPresented: $viewModel.navigateToTimer) {
            if let calculatedTime = viewModel.calculatedTime {
                let minutes = calculatedTime / 60
                let seconds = calculatedTime % 60
                let timerLabel = "\(viewModel.selectedFilm?.name ?? "") / \(viewModel.selectedDeveloper?.name ?? "")"
                
                TimerView(
                    timerLabel: timerLabel,
                    totalMinutes: minutes,
                    totalSeconds: seconds
                )
            }
        }
        .onChange(of: viewModel.iso) { _ in
            viewModel.updateISO(viewModel.iso)
        }
        .onChange(of: viewModel.temperature) { _ in
            viewModel.updateTemperature(viewModel.temperature)
        }
        .navigationTitle(LocalizedStringKey("presets"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
struct DevelopmentSetupView_Previews: PreviewProvider {
    static var previews: some View {
        DevelopmentSetupView()
            .previewDisplayName("Development setup")
    }
}
