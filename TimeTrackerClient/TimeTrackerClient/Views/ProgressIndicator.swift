//
//  ProgressIndicator.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 24.11.2021.
//

import SwiftUI

struct ProgressIndicator: View {
    @State private var isCircleRotating = true
    @State private var animateStart = false
    @State private var animateEnd = true
    
    var body: some View {
        
        ZStack {
            VisualEffectView(effect: UIBlurEffect(style: .light))
                .opacity(0.9)
            Circle()
                .stroke(lineWidth: 4)
                .fill(Color.init(red: 0.96, green: 0.96, blue: 0.96))
                .frame(width: 35, height: 35)
            
            Circle()
                .trim(from: animateStart ? 1/3 : 1/9, to: animateEnd ? 2/5 : 1)
                .stroke(lineWidth: 4)
                .rotationEffect(.degrees(isCircleRotating ? 360 : 0))
                .frame(width: 35, height: 35)
                .foregroundColor(Color.blue)
                .onAppear() {
                    withAnimation(Animation
                                    .linear(duration: 1)
                                    .repeatForever(autoreverses: false)) {
                        self.isCircleRotating.toggle()
                    }
                    withAnimation(Animation
                                    .linear(duration: 1)
                                    .delay(0.5)
                                    .repeatForever(autoreverses: true)) {
                        self.animateStart.toggle()
                    }
                    withAnimation(Animation
                                    .linear(duration: 1)
                                    .delay(1)
                                    .repeatForever(autoreverses: true)) {
                        self.animateEnd.toggle()
                    }
                }
        }
    }
}

struct ProgressIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ProgressIndicator()
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
