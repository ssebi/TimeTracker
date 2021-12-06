//
//  Utils.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 20.10.2021.
//

import Foundation
import SwiftUI

struct AddButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(width: UIScreen.main.bounds.width - 55, height: 50, alignment: .center)
            .background(LinearGradient.gradientBackground)
            .foregroundColor(.white)
            .cornerRadius(5)
            .font(Font.custom("Avenir-Next", size: 30))
    }
}

struct Path {
    static let clients = "Clients"
    static let timeSlot = "timeSlots"
}

struct CustomTextField: UIViewRepresentable {
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var textInput: String
        var maxLength: Int?
        var onSubmit: (() -> Void)?

        init(
            text: Binding<String>,
            maxLength: Int?,
            onSubmit: (() -> Void)?
        ) {
            _textInput = text
            self.maxLength = maxLength
            self.onSubmit = onSubmit
        }

        func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            guard let maxLength = maxLength else {
                return true
            }

            guard let textFieldText = textField.text,
                let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
            }
            let substringToReplace = textFieldText[rangeOfTextToReplace]
            let count = textFieldText.count - substringToReplace.count + string.count
            return count <= maxLength
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            if textField.markedTextRange == nil {
                textInput = textField.text ?? ""
            }
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {

            if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                  nextField.becomeFirstResponder()
               } else {
                  // Not found, so remove keyboard.
                  textField.resignFirstResponder()
               }

            if let onSubmit = onSubmit {
                onSubmit()
            }
            return true
        }
    }

    @Binding var text: String

    var isSecured: Bool = false
    var keyboard: UIKeyboardType
    var returnKeyType: UIReturnKeyType?

    var maxLength: Int?
    var textColor: UIColor = UIColor(.cBlack)
    var placeholder: String?
    var placeholderColor: UIColor = UIColor(.cGray)
    var onSubmit: (() -> Void)?
    var tag: Int

    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.isSecureTextEntry = isSecured
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = keyboard
        textField.returnKeyType = returnKeyType ?? UIReturnKeyType.default
        textField.textColor = textColor
        textField.delegate = context.coordinator
        textField.placeholder = placeholder
        textField.tag = tag

        if placeholder != nil {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder!,
                attributes: [NSAttributedString.Key.foregroundColor: placeholderColor]
            )
        }

        return textField
    }

    func makeCoordinator() -> CustomTextField.Coordinator {
        Coordinator(
            text: $text,
            maxLength: maxLength,
            onSubmit: onSubmit
        )
    }

    func updateUIView(_ uiView: UITextField, context _: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = text
    }
}



