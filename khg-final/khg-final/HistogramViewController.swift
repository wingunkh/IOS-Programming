import UIKit
import Firebase
import Charts
import DGCharts

class HistogramViewController: UIViewController {
    @IBOutlet weak var chartView: BarChartView!
    var exerciseCounts: [String: Int] = [:]
    var current: Date!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchExerciseData()
    }
    
    // Firestore에서 운동 데이터를 가져오는 메서드
    func fetchExerciseData() {
        let db = Firestore.firestore()
        let calendar = Calendar.current
        
        // 월 초와 월 말 날짜 계산
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: current)) else { return }
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!

        // Firestore에서 날짜 범위에 해당하는 운동 기록을 가져온다.
        db.collection("records")
            .whereField("date", isGreaterThanOrEqualTo: startOfMonth)
            .whereField("date", isLessThanOrEqualTo: endOfMonth)
            .getDocuments { [weak self] (querySnapshot, err) in
                if let err = err {
                    print("에러 발생: \(err)")
                } else {
                    // 각 문서에서 운동을 추출하고 카운트를 증가
                    for document in querySnapshot!.documents {
                        let dict = document.data()
                        let data = dict["data"] as? [String: Any]
                        let exercise = data?["exercise"]
                        self?.incrementExerciseCount(exercise as! String)
                    }
                    // 차트 설정
                    self?.setupChart()
                }
        }
    }

    // 운동의 카운트를 증가시키는 메서드
    func incrementExerciseCount(_ exercise: String) {
        exerciseCounts[exercise, default: 0] += 1
    }

    // 차트 설정 메서드
    func setupChart() {
        var dataEntries: [BarChartDataEntry] = []

        // 모든 운동을 문자열로 변환
        let categories = Record.Exercise.allCases.map { $0.toString() }

        // 각 카테고리에 대한 데이터 엔트리 생성
        for (index, category) in categories.enumerated() {
            let count = exerciseCounts[category] ?? 0
            let dataEntry = BarChartDataEntry(x: Double(index), y: Double(count))
            dataEntries.append(dataEntry)
        }

        // 데이터셋과 데이터 생성
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "운동")
        let chartData = BarChartData(dataSet: chartDataSet)

        // 차트 색상 설정
        chartDataSet.colors = ChartColorTemplates.joyful()

        // x축 레이블 설정
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: categories)
        chartView.xAxis.granularity = 1
        chartView.xAxis.labelCount = categories.count
        chartView.xAxis.labelPosition = .bottom

        // x축과 y축 레이블 스타일 설정
        chartView.xAxis.labelRotationAngle = -45
        chartView.xAxis.labelTextColor = .purple
        chartView.leftAxis.labelTextColor = .red
        chartView.xAxis.labelFont = .systemFont(ofSize: 12)
        chartView.leftAxis.labelFont = .systemFont(ofSize: 12)
        
        // y축 간격 설정
        chartView.leftAxis.granularity = 1.0
        chartView.rightAxis.granularity = 1.0
        
        // y축 최솟값 설정
        chartView.leftAxis.axisMinimum = 0.0
        chartView.rightAxis.axisMinimum = 0.0

        // 차트에 데이터 할당
        chartView.data = chartData

        // 차트 애니메이션 추가
        chartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
}
