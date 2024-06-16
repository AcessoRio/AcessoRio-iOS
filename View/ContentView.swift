import SwiftUI
import MapKit


import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            VStack {
                MapView(annotations: viewModel.images.map {_ in 
                    AccessibilityAnnotation(type: .unevenSidewalk, coordinate: viewModel.locationManager.lastKnownLocation?.coordinate ?? CLLocationCoordinate2D())
                }, region: .constant(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: -22.9068, longitude: -43.1729),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )))
                .ignoresSafeArea(edges: .top)

                Button(action: {
                    viewModel.showingImagePicker = true
                }) {
                    HStack {
                        Image(systemName: "camera")
                        Text("Registrar Problema")
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                }
                .sheet(isPresented: $viewModel.showingImagePicker, onDismiss: viewModel.loadImage) {
                    ImagePicker(image: $viewModel.inputImage, sourceType: .camera)
                }
                .fullScreenCover(isPresented: $viewModel.navigateToReportIssue) {
                    ReportIssueView(viewModel: viewModel)
                }

                List {
                    ForEach(IssueType.allCases, id: \.self) { type in
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(colorForType(type))
                            Text(type.rawValue)
                            Spacer()
                            Text("\(viewModel.images.filter { _ in type == .unevenSidewalk }.count)")
                        }
                    }
                }
            }
            .navigationTitle("Acesso Rio")
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


// The map view implementation in SwiftUI

struct MapView: UIViewRepresentable {
    var annotations: [MKAnnotation]
    @Binding var region: MKCoordinateRegion

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
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

        // Add delegate methods if needed
    }
}



//#Preview {
//    ContentView()
//}
