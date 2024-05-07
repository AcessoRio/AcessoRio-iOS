import SwiftUI
import MapKit


struct ContentView: View {
    @ObservedObject var viewModel = AccessibilityIssuesViewModel()


    // Map Information
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -22.9068, longitude: -43.1729),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    @State private var showingBottomSheet = true

    var body: some View {
        VStack{
            MapView(annotations: viewModel.issues.map {
                AccessibilityAnnotation(type: $0.type, coordinate: $0.location)
            }, region: $region)
            .ignoresSafeArea(edges: .top)
            .sheet(isPresented: $showingBottomSheet) {
                ScrollView {
                    issueList
                }
                // You may comment out below modifiers for testing
                .interactiveDismissDisabled()
                .presentationDetents([.height(50), .medium, .large])
                .presentationBackgroundInteraction(.enabled(upThrough: .large))
            }
            .frame(maxWidth: .infinity)
            .background(Color.white.cornerRadius(0))
        }


    }

    var issueList: some View {
        VStack{
            Button(action: {
                // Action for the button
            }) {
                Text("Registrar Problema")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .bold()
            }
            .padding()

            HStack{
                Text("Alertas na Região")
                Spacer()
            }.padding()

            List {
                ForEach(IssueType.allCases, id: \.self) { type in
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(colorForType(type))
                        Text(type.rawValue).fontWeight(.medium)
                        Spacer()
                        Text("\(viewModel.issues.filter { $0.type == type }.count)")
                    }
                    .listRowBackground(Color.white)
                    .listRowSpacing(50)
                }
            }
            .frame(height: 300) // Set an explicit height for the list
            .background(Color.white)
            .listStyle(PlainListStyle())

        }
    }




    func colorForType(_ type: IssueType) -> Color {
        switch type {
        case .unevenSidewalk:
            return .red
        case .noAccessRamp:
            return .orange
        case .noTactileSignage:
            return .blue
        case .fixedObstacles:
            return .purple
        }
    }
}

struct MapView: UIViewRepresentable {
    var annotations: [AccessibilityAnnotation]
    @Binding var region: MKCoordinateRegion

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true  // Mostra a localização do usuário
        mapView.userTrackingMode = .follow  // Segue a localização do usuário
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }

        // Implemente métodos delegate conforme necessário
    }
}




#Preview {
    ContentView()
}
