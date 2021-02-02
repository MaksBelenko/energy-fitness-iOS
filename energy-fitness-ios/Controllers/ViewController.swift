//
//  ViewController.swift
//  energy-fitness-ios
//
//  Created by Maksim on 09/12/2020.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .red
    }
}



// -------------- PREVIEW HELPER --------------------
struct TestIntegratedController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

struct TestPreviewController: View {
    var body: some View {
        TestIntegratedController().edgesIgnoringSafeArea(.all)
    }
}

struct TestPreviewController_Previews: PreviewProvider {
    static var previews: some View {
        TestPreviewController()//.previewDevice("iPhone 7")
    }
}

