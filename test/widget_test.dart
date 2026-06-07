import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:prm393_tranxuandat/main.dart';
import 'package:prm393_tranxuandat/services/book_provider.dart';
import 'mock_http_client.dart';

void main() {
  setUpAll(() {
    // Kích hoạt giả lập tải ảnh mạng
    HttpOverrides.global = MockHttpOverrides();
  });

  testWidgets('BookifyApp khoi tao va hien thi dung tieu de', (WidgetTester tester) async {
    // Xây dựng widget BookifyApp được bao bọc bởi BookProvider
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => BookProvider(),
        child: const BookifyApp(),
      ),
    );

    // Đợi tất cả animation và microtask kết thúc
    await tester.pumpAndSettle(const Duration(milliseconds: 100));

    // Xác thực tiêu đề ứng dụng 'Bookify' hiển thị trên AppBar
    expect(find.text('Bookify'), findsOneWidget);

    // Xác thực có thanh tìm kiếm với gợi ý tìm kiếm sách
    expect(find.text('Tìm kiếm tựa sách hoặc tác giả...'), findsOneWidget);
  });
}
