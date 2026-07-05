import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_tranxuandat/lab6/lab6.dart';

/// Hàm main chứa các bài test tự động cho ứng dụng Lab 6
void main() {
  /// Thiết lập bộ lọc lỗi mạng toàn cục cho suite test trước khi chạy
  setUpAll(() {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exception is NetworkImageLoadException ||
          details.exception is HttpException ||
          details.exception is SocketException) {
        return;
      }
      FlutterError.presentError(details);
    };
  });

  /// Test kiểm tra xem Lab 6 App có khởi tạo bình thường và hiển thị các điều khiển tìm kiếm lọc phim hay không
  testWidgets('Lab 6 App hien thi trinh duyet phim responsive',
      (WidgetTester tester) async {
    // 1. Build widget Lab6App
    await tester.pumpWidget(const Lab6App());

    // 2. Xác thực tiêu đề trên AppBar hiển thị đúng
    expect(find.text('Trình Duyệt Phim'), findsOneWidget);

    // 3. Xác thực có ô tìm kiếm và nhãn lọc thể loại
    expect(find.text('Lọc theo thể loại:'), findsOneWidget);
    expect(find.text('Tìm kiếm tiêu đề phim...'), findsOneWidget);

    // 4. Xác thực hiển thị một vài bộ phim mẫu hiển thị ở hàng đầu tiên sau khi sắp xếp A-Z (Inception và Avatar)
    expect(find.text('Inception'), findsOneWidget);
    expect(find.text('Avatar'), findsOneWidget);
  });

  /// Test kiểm tra tính năng tìm kiếm phim bằng text field
  testWidgets('Lab 6 tim kiem phim theo tieu de', (WidgetTester tester) async {
    await tester.pumpWidget(const Lab6App());

    // Nhập từ khóa 'Matrix' vào ô tìm kiếm
    await tester.enterText(find.byType(TextField), 'Matrix');
    await tester.pump(); // Cập nhật lại giao diện ngay

    // Xác thực chỉ còn phim The Matrix hiển thị và các phim khác biến mất
    expect(find.text('The Matrix'), findsOneWidget);
    expect(find.text('Inception'), findsNothing);
  });
}
