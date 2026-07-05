import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_tranxuandat/lab8b/lab8b.dart';

/// Hàm main chứa các bài test tự động cho ứng dụng Lab 8B
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

  /// Test kiểm tra xem Lab 8B App có khởi tạo bình thường và hiển thị đúng tiêu đề cùng trạng thái Loading ban đầu hay không
  testWidgets('Lab 8B App khoi tao va hien thi tieu de kem trang thai loading',
      (WidgetTester tester) async {
    // 1. Build widget Lab8BApp
    await tester.pumpWidget(const Lab8BApp());

    // 2. Xác thực tiêu đề chính trên AppBar hiển thị đúng
    expect(find.text('Phim Nổi Bật (TVMaze)'), findsOneWidget);

    // 3. Xác thực hiển thị trạng thái đang khám phá kho phim ban đầu
    expect(find.text('Đang khám phá kho phim...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
