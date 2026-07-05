// Lab 8 - REST API List Screen
//
// Cách chạy Lab 8:
// Thay đổi nội dung file main.dart thành:
//
// import 'package:flutter/material.dart';
// import 'lab8.dart';
// void main() {
//   runApp(const Lab8App());
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Model định nghĩa dữ liệu cho bài viết nhận về từ API
class Post {
  final int id;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.title,
    required this.body,
  });

  /// Hàm Factory để khởi tạo đối tượng Post từ cấu trúc dữ liệu JSON map
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }
}

/// Dịch vụ kết nối và tải thông tin từ máy chủ REST API
class ApiService {
  static const String _url = 'https://jsonplaceholder.typicode.com/posts';

  /// Hàm bất đồng bộ tải danh sách bài viết từ máy chủ, xử lý lỗi kết nối và parse dữ liệu JSON
  Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(Uri.parse(_url)).timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => Post.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Mã lỗi phản hồi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Không thể tải bài viết. Lỗi: $e');
    }
  }
}

/// Lớp chính của Lab 8 App kế thừa StatelessWidget
class Lab8App extends StatelessWidget {
  const Lab8App({super.key});

  /// Hàm xây dựng MaterialApp cấu hình theme màu xanh dương Material 3
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 8 - REST API',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E88E5), // Blue
          brightness: Brightness.light,
        ),
      ),
      home: const PostListScreen(),
    );
  }
}

/// Màn hình chính hiển thị danh sách bài viết được fetch từ API
class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  /// Tạo State quản lý luồng dữ liệu Future và tương tác làm mới màn hình
  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

/// Trạng thái lưu trữ của PostListScreen
class _PostListScreenState extends State<PostListScreen> {
  // Thực thể dịch vụ kết nối API
  final ApiService _apiService = ApiService();
  // Biến lưu trữ luồng bất đồng bộ Future chứa danh sách bài viết
  late Future<List<Post>> _postsFuture;

  /// Khởi tạo trạng thái ban đầu và gọi fetch dữ liệu lần đầu
  @override
  void initState() {
    super.initState();
    _postsFuture = _apiService.fetchPosts();
  }

  /// Hàm trigger làm mới dữ liệu hoặc thử lại khi gặp lỗi
  void _retryFetch() {
    setState(() {
      _postsFuture = _apiService.fetchPosts();
    });
  }

  /// Hàm xây dựng giao diện chính kết hợp FutureBuilder xử lý 4 trạng thái
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách Bài viết API'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _retryFetch,
          ),
        ],
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          // 1. Trạng thái Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Đang tải dữ liệu từ API...',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          // 2. Trạng thái Error (Không có mạng, timeout, server sập)
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.cloud_off,
                        size: 64, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    const Text(
                      'Đã xảy ra lỗi kết nối!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      snapshot.error.toString().replaceAll('Exception: ', ''),
                      style: const TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _retryFetch,
                      icon: const Icon(Icons.replay),
                      label: const Text('Thử Lại'),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. Trạng thái thành công nhưng danh sách Empty
          final posts = snapshot.data;
          if (posts == null || posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Không có bài viết nào!',
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _retryFetch,
                    child: const Text('Tải lại'),
                  ),
                ],
              ),
            );
          }

          // 4. Trạng thái Success có dữ liệu
          return RefreshIndicator(
            onRefresh: () async {
              _retryFetch();
              await _postsFuture.catchError(
                  (_) => <Post>[]); // Bọc lỗi tránh crash khi vuốt refresh
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      foregroundColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      child: Text(post.id.toString()),
                    ),
                    title: Text(
                      post.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Bài viết số ${post.id}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 16, top: 8),
                        child: Text(
                          post.body,
                          style: TextStyle(
                              color: Colors.grey[800],
                              height: 1.5,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
