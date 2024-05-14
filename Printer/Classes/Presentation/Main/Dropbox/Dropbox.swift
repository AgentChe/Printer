//
//  Dropbox.swift
//  Printer
//
//  Created by Niiaz Khasanov on 5/14/24.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import PhotosUI
import SwiftyDropbox

extension MainViewController {
    func openDropbox() {
       if DropboxClientsManager.authorizedClient == nil {
           let scopeRequest = ScopeRequest(scopeType: .user, scopes: ["account_info.read"], includeGrantedScopes: false)
           DropboxClientsManager.authorizeFromControllerV2(
               UIApplication.shared,
               controller: self,
               loadingStatusDelegate: nil,
               openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
               scopeRequest: scopeRequest
           )
       } else {
           // The user is already authorized, proceed with API calls
           listDropboxFiles()
       }
   }
    func listDropboxFiles() {
          DropboxClientsManager.authorizedClient?.files.listFolder(path: "").response { response, error in
              if let result = response {
                  for entry in result.entries {
                      print(entry.name)
                  }
              } else if let error = error {
                  print(error)
              }
          }
      }
}
