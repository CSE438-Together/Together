//
//  ErrorSectionView.swift
//  Together
//
//  Created by lcx on 2021/11/19.
//

import SwiftUI

struct ErrorSectionView: View {
    @Binding var error: String
    
    var body: some View {
        Section {
            HStack {
                Image(systemName: "exclamationmark.icloud")
                    .foregroundColor(.red)
                    .font(.title)
                Text(error)
                    .foregroundColor(.red)
                    .textCase(.none)
                    .font(.body)
            }
            .listRowBackground(Color(.systemGroupedBackground))
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
    }
}

struct ErrorSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorSectionView(error: .constant("some error"))
    }
}
