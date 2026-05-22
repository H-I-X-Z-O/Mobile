/// Use case tính toán điểm số cho bài kiểm tra.
/// Chứa logic cốt lõi để quy đổi số câu đúng thành điểm số, 
/// cũng như xác định trạng thái đỗ/trượt dựa trên tỷ lệ phần trăm.
class CalculateScore {
  /// Tính điểm số dựa trên số câu trả lời đúng.
  /// Dựa theo đặc tả: Mỗi câu đúng +10 điểm.
  int call({required int correctAnswers, required int totalQuestions}) {
    if (correctAnswers < 0 || totalQuestions <= 0 || correctAnswers > totalQuestions) {
      return 0;
    }
    return correctAnswers * 10;
  }

  /// Kiểm tra xem người dùng có vượt qua bài kiểm tra hay không.
  /// Dựa theo đặc tả: Hoàn thành >80% câu đúng.
  bool isPassed({required int correctAnswers, required int totalQuestions}) {
    if (totalQuestions <= 0) return false;
    
    final double percentage = (correctAnswers / totalQuestions) * 100;
    return percentage > 80.0;
  }
}