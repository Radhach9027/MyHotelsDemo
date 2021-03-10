import UIKit

struct AlertParameters {
    var title: String?
    var action: ((UIAlertAction) -> Void)?
    var preferredAction: Bool
    var actionStyle: UIAlertAction.Style
    init(title: String, action: ((UIAlertAction) -> Void)? = nil, preferredAction: Bool = false, actionStyle: UIAlertAction.Style = .default) {
        self.title = title
        self.action = action
        self.preferredAction = preferredAction
        self.actionStyle = actionStyle
    }
}

class Alert {
    class func presentAlert(withTitle title: String? = nil, message: String? = nil, controller: UIViewController? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            print("You've pressed OK Button")
        }
        alertController.addAction(okAction)
        let topController = controller == nil ? UIWindow.topViewController : controller
        topController?.present(alertController, animated: true, completion: nil)
    }

    class func presentAlert(withTitle title: String? = nil, message: String? = nil, actionParameters: [AlertParameters], controller: UIViewController? = nil, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        if actionParameters.isEmpty {
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
        } else {
            for parameters in actionParameters {
                let actionStyle: UIAlertAction.Style = parameters.actionStyle
                let action = UIAlertAction(title: parameters.title, style: actionStyle, handler: parameters.action)
                alertController.addAction(action)
                if parameters.preferredAction {
                    alertController.preferredAction = action
                }
            }
        }
        let topController = controller == nil ? UIWindow.topViewController : controller
        topController?.present(alertController, animated: true, completion: nil)
    }
}
