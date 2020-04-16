import Flutter
import UIKit
import SwiftyTesseract

public class SwiftTesseractOcrPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "tesseract_ocr", binaryMessenger: registrar.messenger())
        let instance = SwiftTesseractOcrPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == "extractText" {

            guard let args = call.arguments else {
                result("iOS could not recognize flutter arguments in method: (sendParams)")
                return
            }

            let params: [String : Any] = args as! [String : Any]
            let language: String? = params["language"] as? String
            let path: String? = params["tessData"] as? String
            let customBundle: Bundle = Bundle.init(path: path!)!
            var swiftyTesseract = SwiftyTesseract(language: .english, bundle: customBundle)
            if(language != nil){
                swiftyTesseract = SwiftyTesseract(language: .custom(language as String!), bundle: customBundle)
            }
            let  imagePath = params["imagePath"] as! String
            guard let image = UIImage(contentsOfFile: imagePath)else { return }

            swiftyTesseract.performOCR(on: image) { recognizedString in

                guard let extractText = recognizedString else { return }
                result(extractText)
            }
        }
    }
}
