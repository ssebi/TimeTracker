//
//  Utils.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 20.10.2021.
//

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

struct CustomTextField: UIViewRepresentable {
    @Binding var text: String
    let placeholder: String
    let keyboardType: UIKeyboardType
    let tag: Int
    var isSecure: Bool
    var returnKeyType: UIReturnKeyType
    var commitHandler: (()->Void)?

    init(_ placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType, tag: Int,isSecure: Bool, returnKeyType: UIReturnKeyType, onCommit: (()->Void)?) {
        self._text = text
        self.placeholder = placeholder
        self.tag = tag
        self.commitHandler = onCommit
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.returnKeyType = returnKeyType
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextField {
        // Customise the TextField as you wish
        let textField = UITextField(frame: .zero)
        textField.keyboardType = self.keyboardType
        textField.delegate = context.coordinator
        textField.isUserInteractionEnabled = true
        textField.text = text
        textField.textColor = UIColor.lightGray
        textField.tag = tag
        textField.isSecureTextEntry = isSecure
        textField.placeholder = placeholder
        textField.returnKeyType = returnKeyType

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = self.text
        uiView.setContentHuggingPriority(.init(rawValue: 70), for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    class Coordinator : NSObject, UITextFieldDelegate {
        var parent: CustomTextField

        init(_ uiTextView: CustomTextField) {
            self.parent = uiTextView
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

            if let value = textField.text as NSString? {
                let proposedValue = value.replacingCharacters(in: range, with: string)
                parent.text = proposedValue as String
            }
            return true
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if let nextTextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                nextTextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
				parent.commitHandler?()
            }
            return false
        }
    }
}

struct PullToRefresh: View {

    var coordinateSpaceName: String
    var onRefresh: ()->Void

    @State var needRefresh: Bool = false

    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    ProgressIndicator()
                        .offset(y: -50)
                }
                Spacer()
            }
        }.padding(.top, -50)
    }
}

