// Lab 8B - Movie Explorer
//
// Cách chạy Lab 8B:
// Thay đổi nội dung file main.dart thành:
//
// import 'package:flutter/material.dart';
// import 'lab8b/lab8b.dart';
// void main() {
//   runApp(const Lab8BApp());
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Model định nghĩa cấu trúc dữ liệu cho phim được fetch từ TVMaze API
class ApiMovie {
  final int id;
  final String title;
  final String posterUrl;
  final double rating;
  final String overview;
  final List<String> genres;
  final String status;
  final String language;

  const ApiMovie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.rating,
    required this.overview,
    required this.genres,
    required this.status,
    required this.language,
  });

  /// Hàm Factory để parse cấu trúc JSON thô từ TVMaze API thành đối tượng ApiMovie sạch sẽ
  factory ApiMovie.fromJson(Map<String, dynamic> json) {
    // Xử lý làm sạch overview bằng cách xóa các thẻ HTML sinh ra từ API
    String cleanOverview = json['summary'] as String? ?? 'Không có mô tả nào.';
    cleanOverview =
        cleanOverview.replaceAll(RegExp(r'<[^>]*>'), ''); // Remove HTML tags

    // Lấy ảnh poster chất lượng trung bình
    final imageMap = json['image'] as Map<String, dynamic>?;
    final poster = imageMap != null
        ? imageMap['medium'] as String? ?? imageMap['original'] as String? ?? ''
        : 'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3';

    // Lấy rating trung bình của phim
    final ratingMap = json['rating'] as Map<String, dynamic>?;
    final double ratingVal = ratingMap != null
        ? (ratingMap['average'] as num?)?.toDouble() ?? 7.0
        : 7.0;

    return ApiMovie(
      id: json['id'] as int,
      title: json['name'] as String? ?? 'Chưa rõ tiêu đề',
      posterUrl: poster,
      rating: ratingVal,
      overview: cleanOverview,
      genres: List<String>.from(json['genres'] ?? []),
      status: json['status'] as String? ?? 'N/A',
      language: json['language'] as String? ?? 'N/A',
    );
  }
}

/// Lớp chính của Lab 8B App kế thừa StatelessWidget
class Lab8BApp extends StatelessWidget {
  const Lab8BApp({super.key});

  /// Hàm xây dựng MaterialApp phong cách rạp chiếu phim với màu vàng hổ phách (Material 3)
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 8B - Movie Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFFC107), // Amber / Gold
          brightness: Brightness.dark,
        ),
      ),
      home: const MovieExplorerHomeScreen(),
    );
  }
}

/// Màn hình chính khám phá danh sách phim nổi bật từ API công cộng
class MovieExplorerHomeScreen extends StatefulWidget {
  const MovieExplorerHomeScreen({super.key});

  /// Tạo State quản lý yêu thích phim và tải dữ liệu mạng
  @override
  State<MovieExplorerHomeScreen> createState() =>
      _MovieExplorerHomeScreenState();
}

/// Trạng thái lưu trữ của MovieExplorerHomeScreen
class _MovieExplorerHomeScreenState extends State<MovieExplorerHomeScreen> {
  // Biến luồng bất đồng bộ Future chứa danh sách phim
  late Future<List<ApiMovie>> _moviesFuture;
  // Mảng lưu danh sách các Id bộ phim yêu thích
  final List<int> _favoriteMovieIds = [];

  /// Khởi tạo trạng thái ban đầu và kích hoạt tải dữ liệu
  @override
  void initState() {
    super.initState();
    _moviesFuture = _fetchTrendingMovies();
  }

  /// Hàm bất đồng bộ gọi API phim công cộng TVMaze không cần Key
  Future<List<ApiMovie>> _fetchTrendingMovies() async {
    const String url = 'https://api.tvmaze.com/shows';
    try {
      final response = await http.get(Uri.parse(url)).timeout(
            const Duration(seconds: 10),
          );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // Lấy 20 bộ phim đầu tiên làm đại diện
        final limitedData = data.take(20).toList();
        return limitedData
            .map((item) => ApiMovie.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Mã lỗi phản hồi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Không thể kết nối máy chủ phim. Lỗi: $e');
    }
  }

  /// Hàm trigger làm mới danh sách phim
  void _retryFetch() {
    setState(() {
      _moviesFuture = _fetchTrendingMovies();
    });
  }

  /// Hàm chuyển đổi trạng thái yêu thích của bộ phim
  void _toggleFavorite(int movieId) {
    setState(() {
      if (_favoriteMovieIds.contains(movieId)) {
        _favoriteMovieIds.remove(movieId);
      } else {
        _favoriteMovieIds.add(movieId);
      }
    });
  }

  /// Hàm mở hộp thoại Dialog hiển thị toàn bộ thông tin chi tiết của bộ phim
  void _showMovieDetail(BuildContext context, ApiMovie movie) {
    showDialog(
      context: context,
      builder: (context) {
        final isFav = _favoriteMovieIds.contains(movie.id);
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Banner hình ảnh phim
                Stack(
                  children: [
                    Image.network(
                      movie.posterUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 250,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black87],
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // Chi tiết phim
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text('${movie.rating} (TVMaze)',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(movie.status,
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: movie.genres
                            .map((g) => Chip(
                                  label: Text(g),
                                  labelStyle: const TextStyle(fontSize: 12),
                                  padding: EdgeInsets.zero,
                                ))
                            .toList(),
                      ),
                      const Divider(height: 24),
                      const Text('Tóm tắt nội dung:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview,
                        style: const TextStyle(
                            height: 1.4, fontSize: 13, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                // Nút hành động ở chân dialog
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _toggleFavorite(movie.id);
                            Navigator.pop(context);
                            _showMovieDetail(
                                context, movie); // Reopen to update UI
                          },
                          icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red),
                          label: Text(isFav ? 'Bỏ yêu thích' : 'Yêu thích'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Đóng'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Hàm dựng giao diện chính của MovieExplorerHomeScreen kết hợp FutureBuilder xử lý 3 trạng thái
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phim Nổi Bật (TVMaze)'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _retryFetch,
          ),
        ],
      ),
      body: FutureBuilder<List<ApiMovie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          // 1. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.amber),
                  SizedBox(height: 16),
                  Text('Đang khám phá kho phim...',
                      style: TextStyle(color: Colors.amber)),
                ],
              ),
            );
          }

          // 2. Error State
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.signal_wifi_connected_no_internet_4,
                        size: 64, color: Colors.amber),
                    const SizedBox(height: 16),
                    const Text(
                      'Không thể tải dữ liệu phim!',
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
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tải Lại'),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. Empty State
          final movies = snapshot.data;
          if (movies == null || movies.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.movie, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Không tìm thấy bộ phim nào!'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _retryFetch,
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          // 4. Success State
          return RefreshIndicator(
            onRefresh: () async {
              _retryFetch();
              await _moviesFuture.catchError((_) => <ApiMovie>[]);
            },
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65,
              ),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                final isFav = _favoriteMovieIds.contains(movie.id);

                return Card(
                  elevation: 4,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      // Toàn bộ ảnh nền và thông tin
                      InkWell(
                        onTap: () => _showMovieDetail(context, movie),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Image.network(
                                movie.posterUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: Colors.grey[800],
                                  child:
                                      const Icon(Icons.broken_image, size: 40),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star,
                                          color: Colors.amber, size: 14),
                                      const SizedBox(width: 4),
                                      Text(
                                        movie.rating.toString(),
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      Text(
                                        movie.language,
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[500]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      // Nút Yêu thích ở góc trên phải
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          radius: 18,
                          child: IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.white,
                              size: 18,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => _toggleFavorite(movie.id),
                          ),
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
