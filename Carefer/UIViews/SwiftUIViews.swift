//
//  SwiftUIViews.swift
//  Carefer
//
//  Created by Muhammad Kamal on 09/12/2022.
//

import SwiftUI

struct TextView: View {
    var titleName: String
    var colorCode: Color
    var fontSize: Int
    var fontFamilyName: String
    var body: some View {
        Text(titleName).foregroundColor( colorCode).font(.custom(fontFamilyName, size: CGFloat(fontSize)))
    }
}

struct AlertView: ViewModifier {
    @Binding var showAlert: Bool
    let title: String
    let message: String
    var callback: () -> Void = {}
    func body(content: Content) -> some View {
        content
            .alert(isPresented: $showAlert) { () -> Alert in
                Alert(title: Text(title), message: Text(message),
                    dismissButton: .default(Text("OK")) {
                      self.callback()
                })
        }
    }
}
