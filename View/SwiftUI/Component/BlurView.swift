//
//  BlurView.swift
//  Together
//
//  Created by lcx on 2021/11/19.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct BlurView_Previews: PreviewProvider {
    static var previews: some View {
        BlurView(style: .light)
    }
}
