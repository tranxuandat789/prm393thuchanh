import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_tranxuandat/lab8/lab8.dart';

/// Hàm main chứa các bài test tự động cho ứng dụng Lab 8
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

  /// Test kiểm tra xem Lab 8 App có khởi tạo bình thường và hiển thị đúng tiêu đề cùng trạng thái Loading ban đầu hay không
  testWidgets('Lab 8 App khoi tao va hien thi tieu de kem trang thai loading',
      (WidgetTester tester) async {
    // 1. Build widget Lab8App
    await tester.pumpWidget(const Lab8App());

    // 2. Xác thực tiêu đề trên AppBar hiển thị đúng
    expect(find.text('Danh sách Bài viết API'), findsOneWidget);

    // 3. Xác thực hiển thị dòng chữ Loading ban đầu khi chờ dữ liệu API
    expect(find.text('Đang tải dữ liệu từ API...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
