import SwiftUI

struct AuthView: View {
    
    @EnvironmentObject private var authVM: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var isRegister = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("WordSnap")
                .font(.largeTitle).bold()
            
            Text(isRegister ? "Create account" : "Sign in")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .textFieldStyle(.roundedBorder)
            
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            
            if let err = authVM.errorMessage {
                Text(err)
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
            
            Button {
                Task {
                    if isRegister {
                        await authVM.signUp(email: email, password: password)
                    } else {
                        await authVM.signIn(email: email, password: password)
                    }
                }
            } label: {
                HStack {
                    if authVM.isLoading { ProgressView() }
                    Text(isRegister ? "Sign Up" : "Sign In")
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            }
            .buttonStyle(.borderedProminent)
            .disabled(email.isEmpty || password.isEmpty || authVM.isLoading)
            
            Button {
                isRegister.toggle()
                authVM.errorMessage = nil
            } label: {
                Text(isRegister ? "Already have an account? Sign In" : "No account? Sign Up")
                    .font(.footnote)
            }
            .padding(.top, 4)
        }
        .padding()
    }
}

