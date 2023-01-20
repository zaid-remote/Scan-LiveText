//
//  ScannerView.swift
//  Scan-PillBottle
//
//  Created by Mohammad Zaid on 20/01/23.
//

import Foundation
import VisionKit
import SwiftUI

struct ScannerView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = DataScannerViewController
    @Binding var startScanning: Bool
    @Binding var scanText: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        
        var scanner: ScannerView
        
        init(_ parent: ScannerView) {
               self.scanner = parent
           }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .text(let text):
                scanner.scanText = text.transcript
            default:
                break
            }
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem], allItems: [RecognizedItem]) {
            for item in allItems {
                switch item {
                case .text(let text):
                    scanner.scanText = text.transcript
                default:
                    break
                }
            }
        }
    }
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let vc = DataScannerViewController(recognizedDataTypes: [.text()],
                                           qualityLevel: .balanced,
                                           recognizesMultipleItems: false,
                                           isHighFrameRateTrackingEnabled: true,
                                           isGuidanceEnabled: true,
                                           isHighlightingEnabled: true
        )
        return vc
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        uiViewController.delegate = context.coordinator
        try? uiViewController.startScanning()
    }
    
    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }

}
