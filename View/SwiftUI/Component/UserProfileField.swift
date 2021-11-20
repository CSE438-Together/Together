//
//  UserProfileField.swift
//  Together
//
//  Created by lcx on 2021/11/19.
//

import SwiftUI

struct UserProfileField: View {
    let placeholder: String
    @Binding var text: String
    var leftItem: Text? = nil
    var rightItem: Text? = nil
    
    var body: some View {
        HStack {
            leftItem
            TextField(placeholder, text: $text)
                .autocapitalization(.none)
            rightItem
            if !text.isEmpty {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green)
            }
        }
    }
}

struct UserProfileField_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileField(placeholder: "Placeholder", text: .constant("Text"))
            .previewLayout(.sizeThatFits)
    }
}
