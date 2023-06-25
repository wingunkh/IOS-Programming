import UIKit

class RecordDetailViewController: UIViewController {
    @IBOutlet weak var dateDatePicker: UIDatePicker!
    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var contentPicker: UIPickerView!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repetitionsTextField: UITextField!
    @IBOutlet weak var setsTextField: UITextField!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    var record: Record?
    var saveChangeDelegate: ((Record)->Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        typePicker.layer.borderColor = UIColor.lightGray.cgColor
        typePicker.layer.borderWidth = 8
        typePicker.dataSource = self
        typePicker.delegate = self
        
        contentPicker.layer.borderColor = UIColor.lightGray.cgColor
        contentPicker.layer.borderWidth = 8
        contentPicker.dataSource = self
        contentPicker.delegate = self
        
        weightTextField.delegate = self
        repetitionsTextField.delegate = self
        setsTextField.delegate = self
        dateDatePicker.isHidden = true

        // 네비게이션의 뒤로가기 버튼을 숨기고 새로운 버튼을 생성하여 설정
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // 만약 record가 없다면, 현재 날짜와 함께 새로운 Record를 생성
        record = record ?? Record(date: Date(), withData: true)
        dateDatePicker.date = record?.date ?? Date()

        // 만약 record가 있다면, record의 정보를 화면에 표시
        if let record = record {
            typePicker.selectRow(record.exercise.rawValue, inComponent: 0, animated: false)
            
            let selectedExercise = Record.Exercise(rawValue: typePicker.selectedRow(inComponent: 0)) ?? .e1
            
            let exerciseIndex: Int
            
            // record의 운동 유형에 따라 적절한 exerciseIndex를 탐색
            switch selectedExercise {
            case .e1:
                exerciseIndex = Record.Back.allCases.firstIndex { $0.toString() == record.content } ?? 0
            case .e2:
                exerciseIndex = Record.Biceps.allCases.firstIndex { $0.toString() == record.content } ?? 0
            case .e3:
                exerciseIndex = Record.Triceps.allCases.firstIndex { $0.toString() == record.content } ?? 0
            case .e4:
                exerciseIndex = Record.Chest.allCases.firstIndex { $0.toString() == record.content } ?? 0
            case .e5:
                exerciseIndex = Record.Leg.allCases.firstIndex { $0.toString() == record.content } ?? 0
            }
            
            // 컨텐츠 피커를 업데이트
            contentPicker.reloadAllComponents()
            contentPicker.selectRow(exerciseIndex, inComponent: 0, animated: false)
            
            // record의 정보를 각 텍스트 필드에 표시
            weightTextField.text = record.weight
            repetitionsTextField.text = record.repetitions
            setsTextField.text = record.sets
        }
    }


    // 백 버튼 메서드
    @objc func back(sender: UIBarButtonItem) {
        // Alert을 표시하여 사용자에게 운동 기록을 저장할 것인지 질문
        let alertController = UIAlertController(title: nil, message: "운동 기록을 저장하시겠습니까?", preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "저장", style: .default) { (_) in
            // 저장 버튼이 눌렸을 경우, 변경사항을 저장하고 이전 화면으로 복귀
            self.saveChanges()
            _ = self.navigationController?.popViewController(animated: true)
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (_) in
            // 취소 버튼이 눌렸을 경우, 변경사항을 저장하지 않고 이전 화면으로 복귀
            _ = self.navigationController?.popViewController(animated: true)
        }

        // 각 Action을 Alert에 추가
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        // Alert를 표시
        self.present(alertController, animated: true, completion: nil)
    }

    // 운동 기록의 변경사항을 저장하는 메서드
    func saveChanges() {
        // 운동 기록의 정보를 갱신
        record!.date = dateDatePicker.date
        record!.exercise = Record.Exercise(rawValue: typePicker.selectedRow(inComponent: 0))!

        let selectedExercise = Record.Exercise(rawValue: typePicker.selectedRow(inComponent: 0)) ?? .e1
        let selectedContentRow = contentPicker.selectedRow(inComponent: 0)

        // 선택된 운동 유형에 따라 적절한 운동 내용을 찾아서 저장
        switch selectedExercise {
        case .e1:
            let backExercise = Record.Back(rawValue: selectedContentRow)
            record!.content = backExercise?.toString() ?? ""
        case .e2:
            let bicepsExercise = Record.Biceps(rawValue: selectedContentRow)
            record!.content = bicepsExercise?.toString() ?? ""
        case .e3:
            let tricepsExercise = Record.Triceps(rawValue: selectedContentRow)
            record!.content = tricepsExercise?.toString() ?? ""
        case .e4:
            let chestExercise = Record.Chest(rawValue: selectedContentRow)
            record!.content = chestExercise?.toString() ?? ""
        case .e5:
            let legExercise = Record.Leg(rawValue: selectedContentRow)
            record!.content = legExercise?.toString() ?? ""
        }

        // 각 텍스트 필드의 값을 저장
        record!.weight = weightTextField.text ?? ""
        record!.repetitions = repetitionsTextField.text ?? ""
        record!.sets = setsTextField.text ?? ""

        // 변경사항을 저장하는 Delegate를 호출
        saveChangeDelegate?(record!)
    }
}

extension RecordDetailViewController: UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 피커뷰의 각 컴포넌트에는 선택할 수 있는 row의 개수를 반환하는 메서드
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == typePicker {
            // 운동 유형 피커뷰의 경우, 가능한 운동 유형의 개수를 반환
            return Record.Exercise.count
        } else if pickerView == contentPicker {
            // 운동 내용 피커뷰의 경우, 선택된 운동 유형에 따라 가능한 운동 내용의 개수를 반환
            let selectedExercise = Record.Exercise(rawValue: typePicker.selectedRow(inComponent: 0)) ?? .e1
            
            switch selectedExercise {
            case .e1: return Record.Back.count
            case .e2: return Record.Biceps.count
            case .e3: return Record.Triceps.count
            case .e4: return Record.Chest.count
            case .e5: return Record.Leg.count
            }
        }
        
        return 0
    }
    
    // 피커뷰의 각 row의 제목을 반환하는 메서드
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == typePicker {
            // 운동 유형 피커뷰의 경우, 운동 유형의 이름을 반환
            let type = Record.Exercise(rawValue: row)
            return type?.toString()
        } else if pickerView == contentPicker {
            // 운동 내용 피커뷰의 경우, 선택된 운동 유형에 따라 운동 내용의 이름을 반환
            let selectedExercise = Record.Exercise(rawValue: typePicker.selectedRow(inComponent: 0)) ?? .e1
            
            switch selectedExercise {
            case .e1:
                let backExercise = Record.Back(rawValue: row)
                return backExercise?.toString()
            case .e2:
                let bicepsExercise = Record.Biceps(rawValue: row)
                return bicepsExercise?.toString()
            case .e3:
                let tricepsExercise = Record.Triceps(rawValue: row)
                return tricepsExercise?.toString()
            case .e4:
                let chestExercise = Record.Chest(rawValue: row)
                return chestExercise?.toString()
            case .e5:
                let legExercise = Record.Leg(rawValue: row)
                return legExercise?.toString()
            }
        }
        
        return nil
    }

    // 사용자가 피커뷰에서 선택을 변경하면 호출되는 메서드
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == typePicker {
            // 운동 유형 피커뷰에서 선택이 변경되면, 운동 내용 피커뷰를 갱신
            contentPicker.reloadAllComponents()
        }
    }
    
    // 사용자가 Return 키를 눌렀을 때 키보드를 숨기는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
