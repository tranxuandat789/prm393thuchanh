
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_tranxuandat/lab7/lab7.dart';

/// Hàm main chứa các bài test tự động cho ứng dụng Lab 7
void main() {
  /// Test kiểm tra xem Lab 7 App có khởi tạo bình thường và hiển thị Signup Form đầy đủ các trường nhập hay không
  testWidgets('Lab 7 App hien thi form dang ky day du',
      (WidgetTester tester) async {
    // 1. Build widget Lab7App
    await tester.pumpWidget(const Lab7App());

    // 2. Xác thực tiêu đề chính hiển thị đúng
    expect(find.text('Tạo Tài Khoản Mới'), findsOneWidget);

    // 3. Xác thực có hiển thị các trường nhập thông tin cơ bản
    expect(find.text('Họ và tên'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Mật khẩu'), findsOneWidget);
    expect(find.text('Xác nhận mật khẩu'), findsOneWidget);
    expect(find.text('ĐĂNG KÝ NGAY'), findsOneWidget);
  });

  /// Test kiểm tra tính năng validation cảnh báo lỗi khi không nhập thông tin mà bấm đăng ký
  testWidgets('Lab 7 validate form khi click button dang ky ma de trong',
      (WidgetTester tester) async {
    await tester.pumpWidget(const Lab7App());

    // Đảm bảo cuộn tới nút "ĐĂNG KÝ NGAY" để tránh lỗi nằm ngoài màn hình kiểm thử (bounds Size(800.0, 600.0))
    final registerButton = find.text('ĐĂNG KÝ NGAY');
    await tester.ensureVisible(registerButton);
    await tester.pumpAndSettle();

    // Click nút Đăng Ký Ngay
    await tester.tap(registerButton);
    await tester.pump(); // Kích hoạt render lại giao diện hiển thị lỗi

    // Xác thực các cảnh báo lỗi validation được kích hoạt hiển thị
    expect(find.text('Vui lòng nhập họ và tên'), findsOneWidget);
    expect(find.text('Vui lòng nhập email'), findsOneWidget);
    expect(find.text('Vui lòng nhập mật khẩu'), findsOneWidget);
  });
}
