// Lab 5 - Movie Detail App
//
// Cách chạy Lab 5:
// Thay đổi nội dung file main.dart thành:
//
// import 'package:flutter/material.dart';
// import 'lab5.dart';
// void main() {
//   runApp(const Lab5App());
// }

import 'package:flutter/material.dart';

/// Model định nghĩa cấu trúc dữ liệu cho một bộ phim
class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<String> trailers;

  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
  });
}

// Danh sách dữ liệu tĩnh mô phỏng các bộ phim thịnh hành
const List<Movie> sampleMovies = [
  Movie(
    id: '1',
    title: 'Inception',
    posterUrl:
        'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
    overview:
        'Dom Cobb là một kẻ cắp chuyên nghiệp, người có khả năng xâm nhập vào tiềm thức của người khác thông qua giấc mơ để đánh cắp các bí mật kinh doanh. Lần này, anh nhận một nhiệm vụ ngược lại: cấy một ý tưởng vào tâm trí của một CEO.',
    genres: ['Hành động', 'Khoa học viễn tưởng', 'Giật gân'],
    rating: 8.8,
    trailers: ['Official Trailer 1', 'Teaser Trailer', 'Behind the Scenes'],
  ),
  Movie(
    id: '2',
    title: 'The Dark Knight',
    posterUrl:
        'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
    overview:
        'Khi Joker xuất hiện tàn phá thành phố Gotham, Batman phải đối mặt với thử thách lớn nhất về mặt tâm lý lẫn thể chất để ngăn chặn tên tội phạm điên cuồng này và bảo vệ những người vô tội.',
    genres: ['Hành động', 'Tội phạm', 'Kịch tính'],
    rating: 9.0,
    trailers: ['Teaser Trailer', 'Main Trailer', 'IMAX Trailer'],
  ),
  Movie(
    id: '3',
    title: 'Interstellar',
    posterUrl:
        'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
    overview:
        'Trái Đất đang đứng trước bờ vực diệt vong. Một nhóm các nhà thám hiểm không gian du hành qua một lỗ sâu mới được phát hiện ngoài vũ trụ để tìm kiếm một hành tinh mới có sự sống cho nhân loại.',
    genres: ['Phiêu lưu', 'Khoa học viễn tưởng', 'Kịch tính'],
    rating: 8.7,
    trailers: ['Teaser 1', 'Official Trailer 3', 'Final Trailer'],
  ),
];

/// Lớp chính của Lab 5 App kế thừa StatelessWidget
class Lab5App extends StatelessWidget {
  const Lab5App({super.key});

  /// Hàm xây dựng MaterialApp cấu hình theme đỏ phong cách rạp chiếu phim (Material 3)
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 5 - Movie Detail App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE50914), // Netflix Red
          brightness: Brightness.dark,
        ),
      ),
      home: const Lab5HomeScreen(),
    );
  }
}

/// Màn hình Home hiển thị danh sách các phim thịnh hành
class Lab5HomeScreen extends StatelessWidget {
  const Lab5HomeScreen({super.key});

  /// Hàm xây dựng danh sách phim ListView và xử lý chuyển cảnh Hero khi nhấn vào mỗi item
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phim Thịnh Hành'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: sampleMovies.length,
        itemBuilder: (context, index) {
          final movie = sampleMovies[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: InkWell(
              onTap: () {
                // Chuyển sang màn hình Chi tiết phim
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetailScreen(movie: movie),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: 'poster_${movie.id}',
                    child: Container(
                      width: 110,
                      height: 160,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(movie.posterUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                movie.rating.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                movie.genres.first,
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            movie.overview,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey[300],
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 16, right: 16),
                    child: Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Màn hình Chi tiết phim hiển thị ảnh banner rộng lớn, các thông tin cụ thể, nút đánh giá và danh sách trailer
class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  /// Tạo state quản lý trạng thái Yêu thích và Đánh giá của phim
  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

/// Trạng thái lưu trữ của màn hình chi tiết phim
class _MovieDetailScreenState extends State<MovieDetailScreen> {
  // Biến lưu trạng thái phim yêu thích hay chưa
  bool _isFavorite = false;
  // Biến lưu điểm số đánh giá của người dùng
  double? _userRating;

  /// Hàm phụ trợ thiết kế nhanh nút hành động ở phần tương tác (Yêu thích, Đánh giá, Chia sẻ)
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// Hàm mở hộp thoại để người dùng chọn số sao đánh giá phim từ 1 đến 5
  void _showRatingDialog(BuildContext context) {
    double selectedRating = 5.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Đánh giá của bạn'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Vui lòng chọn số sao:'),
              const SizedBox(height: 16),
              StatefulBuilder(
                builder: (context, setStateInDialog) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starRating = index + 1.0;
                      return IconButton(
                        icon: Icon(
                          starRating <= selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 36,
                        ),
                        onPressed: () {
                          // Cập nhật điểm sao trong phạm vi dialog
                          setStateInDialog(() {
                            selectedRating = starRating;
                          });
                        },
                      );
                    }),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // Lưu lại kết quả đánh giá trên widget cha
                setState(() {
                  _userRating = selectedRating;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          'Cảm ơn bạn đã đánh giá ${_userRating!.round()} sao!')),
                );
              },
              child: const Text('Gửi'),
            ),
          ],
        );
      },
    );
  }

  /// Hàm dựng giao diện chính của màn hình chi tiết phim MovieDetailScreen
  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;
    final theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner hình ảnh phim kết hợp hiệu ứng Hero mượt mà và Gradient overlay mờ
            Stack(
              children: [
                Hero(
                  tag: 'poster_${movie.id}',
                  child: Container(
                    height: 350,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(movie.posterUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        theme.colorScheme.surface.withOpacity(0.5),
                        theme.colorScheme.surface,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ],
            ),

            // Các trường thông tin văn bản
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 24),
                      const SizedBox(width: 4),
                      Text(
                        movie.rating.toString(),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(IMDb)',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Nút hành động tương tác phim
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(
                        icon: _isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        label: 'Yêu thích',
                        color: _isFavorite ? Colors.red : Colors.white,
                        onTap: () {
                          setState(() {
                            _isFavorite = !_isFavorite;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _isFavorite
                                    ? 'Đã thêm vào mục Yêu thích'
                                    : 'Đã xóa khỏi mục Yêu thích',
                              ),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                      _buildActionButton(
                        icon: Icons.star_border,
                        label: _userRating == null
                            ? 'Đánh giá'
                            : 'Đã đánh giá: ${_userRating!.round()}',
                        color:
                            _userRating != null ? Colors.amber : Colors.white,
                        onTap: () => _showRatingDialog(context),
                      ),
                      _buildActionButton(
                        icon: Icons.share_outlined,
                        label: 'Chia sẻ',
                        color: Colors.white,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Đang chia sẻ bộ phim "${movie.title}"...'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Thể loại (Genres Chips)
                  const Text(
                    'Thể loại',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: movie.genres
                        .map((genre) => Chip(
                              label: Text(genre),
                              backgroundColor:
                                  theme.colorScheme.primaryContainer,
                              labelStyle: TextStyle(
                                  color: theme.colorScheme.onPrimaryContainer),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // Overview
                  const Text(
                    'Tóm tắt nội dung',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    movie.overview,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                      color: Colors.grey[300],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Danh sách video trailers
                  const Text(
                    'Danh sách Trailers & Videos',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),

            // Dựng danh sách trailer dưới dạng ListView.builder
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: movie.trailers.length,
              itemBuilder: (context, index) {
                final trailerName = movie.trailers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.play_circle_fill,
                        color: Color(0xFFE50914), size: 36),
                    title: Text(trailerName),
                    subtitle: const Text('Độ phân giải 1080p'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Đang mở video: $trailerName')),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
