//
//  SheetView.swift
//  AcessoRio
//
//  Created by Alexandre César Brandão de Andrade on 10/04/24.
//

import SwiftUI

import SwiftUI

struct SheetView: View {
    //MARK: - Properties
    @State private var startingOffset: CGFloat = UIScreen.main.bounds.height * 0.6
    @State private var currentOffset:CGFloat = 0
    @State private var endOffset:CGFloat = 0


    //MARK: - Body
    var body: some View {
        ZStack{

            DraggableView()
                .offset(y:startingOffset)
                .offset(y:currentOffset)
                .offset(y:endOffset)
                .gesture(
                    DragGesture()
                        .onChanged{ value in
                            withAnimation(.spring()){
                                currentOffset = value.translation.height
                            }
                        }

                        .onEnded{ value in
                            withAnimation(.spring()){
                                if currentOffset < -150{
                                    endOffset = -startingOffset
                                }else if endOffset != 0 && currentOffset > 150 {
                                    endOffset = .zero
                                }
                                currentOffset = 0
                            }
                        }
                )
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
}

struct DraggableView: View {
    @ObservedObject var viewModel = AccessibilityIssuesViewModel()

    var body: some View {
        VStack(spacing: 20){
            Button(action: {
                // Action to report a new issue
            }) {
                Text("Registrar Problema")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }

            List {
                ForEach(IssueType.allCases, id: \.self) { type in
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .foregroundColor(colorForType(type))
                        Text(type.rawValue)
                        Spacer()
                        Text("\(viewModel.issues.filter { $0.type == type }.count)")
                    }
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white.cornerRadius(0))
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
#Preview {
    SheetView()
}
