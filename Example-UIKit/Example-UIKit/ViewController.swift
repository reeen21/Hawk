import UIKit
import Hawk

final class ViewController: UIViewController {
    override func viewWillAppear(_ animated: Bool) {
        showForceUpdateDialogIfNeeded()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
    }
}
