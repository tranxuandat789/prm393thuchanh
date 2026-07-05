import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_tranxuandat/lab4/lab4.dart';

/// Hàm main chứa các bài test tự động cho ứng dụng Lab 4
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

  /// Test kiểm tra xem Lab 4 App có khởi tạo bình thường và hiển thị đầy đủ menu hay không
  testWidgets('Lab 4 App khoi tao va hien thi menu chinh',
      (WidgetTester tester) async {
    // 1. Build widget Lab4App
    await tester.pumpWidget(const Lab4App());

    // 2. Xác thực tiêu đề trên AppBar hiển thị đúng
    expect(find.text('Lab 4 - Flutter UI Basics'), findsOneWidget);

    // 3. Xác thực hiển thị đầy đủ 5 thẻ bài tập
    expect(find.text('Exercise 1: Basic Widgets'), findsOneWidget);
    expect(find.text('Exercise 2: Input Controls'), findsOneWidget);
    expect(find.text('Exercise 3: Bố cục Layout'), findsOneWidget);
    expect(find.text('Exercise 4: Scaffold & Theme'), findsOneWidget);
    expect(find.text('Exercise 5: Sửa lỗi UI & State'), findsOneWidget);
  });

  /// Test kiểm tra tương tác click mở màn hình bài tập 1
  testWidgets('Lab 4 dieu huong den man hinh Exercise 1',
      (WidgetTester tester) async {
    await tester.pumpWidget(const Lab4App());

    // Tap vào bài tập 1
    await tester.tap(find.text('Exercise 1: Basic Widgets'));
    await tester.pumpAndSettle(); // Đợi hiệu ứng chuyển màn hình hoàn tất

    // Xác thực tiêu đề màn hình mới hiển thị đúng
    expect(find.text('Exercise 1: Basic Widgets'), findsOneWidget);
    expect(find.text('Khám phá Flutter'), findsOneWidget);
  });
}
