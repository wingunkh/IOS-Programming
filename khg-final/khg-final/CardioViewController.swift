import UIKit
import Firebase

class CardioViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopResetButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var inputLabel: UITextField!
    
    var selectedDate: Date?
    private var timer: Timer?
    private var counter = 0
    private var name: String = ""
    private var time: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLabel.text = "00:00:00.000"
        
        deviceLabel.layer.cornerRadius = 8.0
        deviceLabel.layer.masksToBounds = true
        
        startButton.isEnabled = true
        startButton.layer.cornerRadius = 12.0
        startButton.layer.masksToBounds = true
        
        stopResetButton.setTitle("Stop", for: .normal)
        stopResetButton.layer.cornerRadius = 12.0
        stopResetButton.layer.masksToBounds = true
        
        messageLabel.isHidden = true
        
        inputLabel.isHidden = true
        inputLabel.delegate = self
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        name = newText // 입력받은 운동명 저장
        updateSaveButtonState()
        return true
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        startButton.setTitle("Start", for: .normal)
        stopResetButton.setTitle("Stop", for: .normal)
        startButton.isEnabled = false
        messageLabel.isHidden = true
        inputLabel.isHidden = true
        updateSaveButtonState() // 시작 버튼을 눌렀을 때 저장 버튼 상태 업데이트
    }

    @IBAction func stopResetButtonTapped(_ sender: Any) {
        if stopResetButton.currentTitle == "Stop" {
            timer?.invalidate()
            timer = nil
            startButton.setTitle("Resume", for: .normal)
            stopResetButton.setTitle("Reset", for: .normal)
            startButton.isEnabled = true
            messageLabel.isHidden = false
            inputLabel.isHidden = false
            updateSaveButtonState() // 중지 버튼을 눌렀을 때 저장 버튼 상태 업데이트
        } else {
            counter = 0
            timeLabel.text = "00:00:00.000"
            startButton.setTitle("Start", for: .normal)
            stopResetButton.setTitle("Stop", for: .normal)
            startButton.isEnabled = true
            messageLabel.isHidden = true
            inputLabel.isHidden = true
            name = "" // 리셋할 때 운동명 초기화
            updateSaveButtonState() // 리셋 버튼을 눌렀을 때 저장 버튼 상태 업데이트
        }
    }

    @objc func updateTimeLabel() {
        counter += 1
        timeLabel.text = timeString(time: TimeInterval(counter) / 1000)
        time = timeLabel.text ?? "" // 스탑워치 시간 저장
        updateSaveButtonState() // 시간이 업데이트될 때 저장 버튼 상태 업데이트
    }

    func timeString(time: TimeInterval) -> String {
        let hours   = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let milliseconds = Int(time * 1000) % 1000
        return String(format:"%02i:%02i:%02i.%03i", hours, minutes, seconds, milliseconds)
    }
    
    func updateSaveButtonState() {
        if !isTimerRunning() {
            self.navigationItem.leftBarButtonItem?.isEnabled = true // 타이머가 중지되었을 때 뒤로 가기 버튼 활성화
        }
    }
    
    func isTimerRunning() -> Bool {
        return timer != nil
    }
    
    @objc func backButtonTapped() {
        if name.isEmpty {
            self.navigationController?.popViewController(animated: true) // 인풋이 없으면 바로 이전 화면으로 이동
        } else {
            let alertController = UIAlertController(title: nil, message: "운동 기록을 저장하시겠습니까?", preferredStyle: .alert)

            let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_) in
                self.navigationController?.popViewController(animated: true) // 취소 버튼을 클릭하면 이전 화면으로 이동
            }
            alertController.addAction(cancelAction)

            let saveAction = UIAlertAction(title: "저장", style: .default) { (_) in
                self.saveButtonTapped(self) // 저장 버튼 동작 실행
            }
            alertController.addAction(saveAction)

            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func saveButtonTapped(_ sender: Any) {
        let db = Firestore.firestore()

        let exerciseData: [String: Any] = [
            "exercise" : "",
            "content" : name+"&&&"+time,
            "date": selectedDate!,
            "key" : UUID().uuidString,
            "repetitions" : "",
            "sets" : "",
            "weight" : ""
        ]
        
        let finalData: [String: Any] = [
            "data": exerciseData,
            "date": FieldValue.serverTimestamp()
        ]
        
        db.collection("records").document(exerciseData["key"] as! String).setData(finalData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added")
            }
        }
        
        // recordGroup 창으로 이동
        _ = self.navigationController?.popViewController(animated: true)
    }
}
