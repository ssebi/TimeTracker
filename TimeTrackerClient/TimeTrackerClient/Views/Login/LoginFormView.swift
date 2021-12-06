//
//  LoginFormView.swift
//  TimeTrackerClient
//
//  Created by Bocanu Mihai on 02.12.2021.
//

import SwiftUI

struct LoginFormView: View {
    @ObservedObject private(set) var viewModel: LoginViewModel
    @State private var isSecured: Bool = true
    @State var focused: [Bool] = [true, false]

    var body: some View {
        VStack{
            VStack{
                Text("Login with your")
                HStack{
                    Group{Text("TIME") + Text("TRACKER").bold()}
                    Text("account")
                }
            }
            .foregroundColor(Color.cBlack)
            .font(Font.custom("Avenir-Light", size: 20.0))

            Group {
                Text("\(viewModel.errrorMessage)")
                    .foregroundColor(.red)
                    .font(Font.custom("Avenir-Light", size: 20))
                    .padding()

                HStack {
                    Image(systemName: "person.fill")
                    CustomTextField(
                        keyboardType: UIKeyboardType.default,
                        returnVal: UIReturnKeyType.next,
                        tag: 0,
                        text: $viewModel.username,
                        isfocusAble: self.$focused,
                        placeholder: "E-mail"
                    )
                        .cornerRadius(10)
                        .foregroundColor(.cBlack)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .frame(height: 30, alignment: .center)
                        .textContentType(.some(.emailAddress))
                        .keyboardType(.emailAddress)

                        .onTapGesture {
                            viewModel.errrorMessage = ""
                        }
                }
                .underlineTextField()
                .frame(height: 50, alignment: .center)

                HStack {
                    Image(systemName: "lock.fill")

                    ZStack(alignment: .trailing) {
                                    CustomTextField(
                                        keyboardType: UIKeyboardType.default,
                                        returnVal: UIReturnKeyType.done,
                                        tag: 1,
                                        text: $viewModel.password,
                                        isfocusAble: self.$focused,
                                        isSecured: true,
                                        placeholder: "Password"
                                    )
                                        .foregroundColor(.cBlack)
                                        .cornerRadius(10)
                                        .frame(height: 30, alignment: .center)
                                        .textContentType(.some(.password))
                                        .onTapGesture {
                                            viewModel.errrorMessage = ""
                                        }
//                                Button(action: {
//                                    isSecured.toggle()
//                                }) {
//                                    Image(systemName: self.isSecured ? "eye.slash" : "eye")
//                                        .accentColor(.cGray)
//                                }
                            }
                }
                .underlineTextField()
                .frame(height: 50, alignment: .center)
            }
            .padding(EdgeInsets(top: 10, leading: 45, bottom: 10, trailing: 45))

            Section {
                Button(action: {
                    viewModel.signIn()
                }) {
                    Text("Login")
                        .font(Font.custom("Avenir-Light", size: 25))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(width: UIScreen.main.bounds.width - 95, height: 50, alignment: .center)
                .foregroundColor(.white)
                .background(LinearGradient.gradientBackground)
                .cornerRadius(30)
                .padding(EdgeInsets(top: 50, leading: 45, bottom: 1, trailing: 45))
            }
        }
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        .frame(width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.height / 2) - 10, alignment: .center)
    }
}

struct LoginFormView_Previews: PreviewProvider {
    static var previews: some View {
        LoginFormView(viewModel: LoginViewModel(session: SessionStore(authProvider: FirebaseAuthProvider())))
    }
}

struct CustomTextField: UIViewRepresentable {
    let keyboardType: UIKeyboardType
    let returnVal: UIReturnKeyType
    let tag: Int
    @Binding var text: String
    @Binding var isfocusAble: [Bool]
    var isSecured: Bool = false
    var placeholder: String

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.keyboardType = self.keyboardType
        textField.returnKeyType = self.returnVal
        textField.tag = self.tag
        textField.delegate = context.coordinator
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = isSecured
        textField.placeholder = placeholder

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if isfocusAble[tag] {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField

        init(_ textField: CustomTextField) {
            self.parent = textField
        }

        func updatefocus(textfield: UITextField) {
            textfield.becomeFirstResponder()
        }

func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if parent.tag == 0 {
                parent.isfocusAble = [false, true]
                parent.text = textField.text ?? ""
            } else if parent.tag == 1 {
                parent.isfocusAble = [false, false]
                parent.text = textField.text ?? ""
         }
        return true
        }
    }
}
