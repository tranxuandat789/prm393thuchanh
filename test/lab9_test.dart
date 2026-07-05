
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_tranxuandat/lab9.dart';

/// Hàm main chứa các bài test tự động cho ứng dụng Lab 9
void main() {
  /// Test kiểm tra xem Lab 9 App có khởi tạo bình thường và hiển thị đủ 3 Tab điều hướng hay không
  testWidgets('Lab 9 App khoi tao va hien thi 3 Tab tieu de',
      (WidgetTester tester) async {
    // 1. Build widget Lab9App
    await tester.pumpWidget(const Lab9App());

    // 2. Xác thực tiêu đề AppBar chính hiển thị đúng
    expect(find.text('Lab 9: JSON & Local Storage'), findsOneWidget);

    // 3. Xác thực có hiển thị đầy đủ 3 Tab trên TabBar
    expect(find.text('9.1: Assets JSON'), findsOneWidget);
    expect(find.text('9.2: Local IO'), findsOneWidget);
    expect(find.text('9.3: CRUD Auto-save'), findsOneWidget);
  });
}
