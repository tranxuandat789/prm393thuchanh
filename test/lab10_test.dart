import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_tranxuandat/lab10.dart';

/// Hàm main chứa các bài test tự động cho ứng dụng Lab 10
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

  /// Test kiểm tra xem Lab 10 App có khởi tạo bình thường và hiển thị đầy đủ menu các tính năng tích hợp hay không
  testWidgets('Lab 10 App khoi tao va hien thi menu cac tinh nang', (WidgetTester tester) async {
    // 1. Build widget Lab10App
    await tester.pumpWidget(const Lab10App());

    // 2. Xác thực tiêu đề AppBar chính hiển thị đúng
    expect(find.text('Lab 10: Auth & System Integration'), findsOneWidget);

    // 3. Xác thực có hiển thị đầy đủ các tính năng tích hợp trong menu
    expect(find.text('10.1 Mock Login'), findsOneWidget);
    expect(find.text('10.2 Real API Login'), findsOneWidget);
    expect(find.text('10.3 Session Persistence'), findsOneWidget);
    expect(find.text('10.4 Google Sign In'), findsOneWidget);
    expect(find.text('10.5 Local Notification'), findsOneWidget);
    expect(find.text('Lab 10 Full Integration'), findsOneWidget);
  });
}
