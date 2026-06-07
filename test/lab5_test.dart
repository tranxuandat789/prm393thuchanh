import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prm393_tranxuandat/lab5.dart';
import 'mock_http_client.dart';

/// Hàm main chứa các bài test tự động cho ứng dụng Lab 5
void main() {
  /// Thiết lập bộ lọc lỗi mạng toàn cục cho suite test trước khi chạy
  setUpAll(() {
    HttpOverrides.global = MockHttpOverrides();
    FlutterError.onError = (FlutterErrorDetails details) {
      // Bỏ qua các ngoại lệ do không có mạng thật để tải ảnh trong widget test
      if (details.exception is NetworkImageLoadException ||
          details.exception is HttpException ||
          details.exception is SocketException) {
        return;
      }
      FlutterError.presentError(details);
    };
  });

  /// Test kiểm tra xem Lab 5 App có khởi tạo bình thường và hiển thị danh sách phim tĩnh hay không
  testWidgets('Lab 5 App hien thi danh sach phim tinh', (WidgetTester tester) async {
    // 1. Build widget Lab5App
    await tester.pumpWidget(const Lab5App());

    // 2. Xác thực tiêu đề AppBar hiển thị đúng
    expect(find.text('Phim Thịnh Hành'), findsOneWidget);

    // 3. Xác thực có hiển thị các bộ phim tĩnh
    expect(find.text('Inception'), findsOneWidget);
    expect(find.text('The Dark Knight'), findsOneWidget);
    expect(find.text('Interstellar'), findsOneWidget);
  });

  /// Test kiểm tra tương tác click mở màn hình chi tiết phim
  testWidgets('Lab 5 dieu huong den man hinh Chi tiet phim', (WidgetTester tester) async {
    await tester.pumpWidget(const Lab5App());

    // Tap vào phim Inception
    await tester.tap(find.text('Inception'));
    
    // Đợi transition chuyển đổi trang hoàn tất
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Xác thực màn hình chi tiết hiển thị đúng thông tin của phim Inception
    expect(find.text('Inception'), findsOneWidget);
    expect(find.text('Thể loại'), findsOneWidget);
    expect(find.text('Tóm tắt nội dung'), findsOneWidget);
  });
}
