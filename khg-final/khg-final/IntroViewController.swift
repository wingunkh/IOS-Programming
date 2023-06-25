import UIKit

class IntroViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showIntroImage()
    }
    
    // 인트로 이미지를 생성, 일정 시간 후에 인트로 화면을 제거
    func showIntroImage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.dismiss(animated: false, completion: nil) // 인트로 화면을 제거
        }
    }
}

