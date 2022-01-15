//
//  SignUpScreen.swift
//  SwiftUICombineNetworking
//
//  Created by Peter Friese on 06.01.22.
//

import SwiftUI
import Combine

// MARK: - View

struct SignUpScreen: View {
  @StateObject private var viewModel = SignUpScreenViewModel()
  
  var body: some View {
    Form {
      // Username
      Section {
        TextField("Username", text: $viewModel.username)
          .autocapitalization(.none)
          .disableAutocorrection(true)
      } footer: {
        Text(viewModel.usernameMessage)
          .foregroundColor(.red)
      }
      
      // Submit button
      Section {
        Button("Sign up") {
          print("Signing up as \(viewModel.username)")
        }
        .disabled(!viewModel.isValid)
      }
    }
  }
}

struct SignUpScreen_Previews: PreviewProvider {
  static var previews: some View {
    SignUpScreen()
  }
}
