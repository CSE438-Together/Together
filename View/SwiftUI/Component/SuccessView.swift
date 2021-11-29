//
//  SuccessView.swift
//  Together
//
//  Created by lcx on 2021/11/29.
//

import SwiftUI

struct SuccessView: View {
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle")
                .resizable()
                .scaledToFill()
                .foregroundColor(.green)
                .frame(width: 50, height: 50, alignment: .center)
            Text("Success")
                .foregroundColor(.white)
                .font(.body)
        }
        .padding(20)
        .background(Color("Loading"))
        .cornerRadius(30)
    }
}

struct SuccessView_Previews: PreviewProvider {
    static var previews: some View {
        SuccessView()
    }
}
