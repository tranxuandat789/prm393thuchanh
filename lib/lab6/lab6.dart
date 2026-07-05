// Lab 6 - Responsive Movie Browser
//
// Cách chạy Lab 6:
// Thay đổi nội dung file main.dart thành:
//
// import 'package:flutter/material.dart';
// import 'lab6/lab6.dart';
// void main() {
//   runApp(const Lab6App());
// }

import 'package:flutter/material.dart';

/// Model định nghĩa dữ liệu cho mỗi bộ phim trong trình duyệt responsive
class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final double rating;
  final String posterUrl;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.rating,
    required this.posterUrl,
  });
}

// Cơ sở dữ liệu phim mẫu tĩnh phục vụ tìm kiếm, lọc và phân tích
const List<Movie> movieDatabase = [
  Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Sci-Fi', 'Action'],
    rating: 8.8,
    posterUrl:
        'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
  ),
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Crime'],
    rating: 9.0,
    posterUrl:
        'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Sci-Fi', 'Adventure'],
    rating: 8.7,
    posterUrl:
        'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
  ),
  Movie(
    title: 'The Matrix',
    year: 1999,
    genres: ['Action', 'Sci-Fi'],
    rating: 8.7,
    posterUrl:
        'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
  ),
  Movie(
    title: 'Avatar',
    year: 2009,
    genres: ['Sci-Fi', 'Adventure'],
    rating: 7.9,
    posterUrl:
        'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
  ),
  Movie(
    title: 'Spirited Away',
    year: 2001,
    genres: ['Anime', 'Adventure', 'Fantasy'],
    rating: 8.6,
    posterUrl:
        'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
  ),
  Movie(
    title: 'Parasite',
    year: 2019,
    genres: ['Thriller', 'Drama'],
    rating: 8.5,
    posterUrl:
        'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
  ),
  Movie(
    title: 'Pulp Fiction',
    year: 1994,
    genres: ['Crime', 'Drama'],
    rating: 8.9,
    posterUrl:
        'https://images.unsplash.com/photo-1485846234645-a62644f84728?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
  ),
];

/// Lớp chính của ứng dụng Lab 6 Responsive Browser
class Lab6App extends StatelessWidget {
  const Lab6App({super.key});

  /// Hàm xây dựng MaterialApp hỗ trợ cả Dark/Light Theme đồng bộ với hệ thống máy
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 6 - Responsive Movie Browser',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6200EE),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFBB86FC),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const MovieBrowserScreen(),
    );
  }
}

/// Màn hình giao diện chính có chứa thanh tìm kiếm, Genre chips và danh sách responsive
class MovieBrowserScreen extends StatefulWidget {
  const MovieBrowserScreen({super.key});

  /// Tạo State quản lý tìm kiếm, lọc và sắp xếp phim
  @override
  State<MovieBrowserScreen> createState() => _MovieBrowserScreenState();
}

/// Trạng thái lưu trữ của màn hình MovieBrowserScreen
class _MovieBrowserScreenState extends State<MovieBrowserScreen> {
  // Biến chứa nội dung nhập tìm kiếm
  String _searchQuery = '';
  // Danh sách các thể loại đang được lọc chọn
  final List<String> _selectedGenres = [];
  // Tiêu chí sắp xếp mặc định
  String _sortBy = 'A-Z'; // A-Z, Z-A, Year, Rating

  /// Getter trả về danh sách toàn bộ các thể loại phim độc nhất được sắp xếp theo thứ tự chữ cái
  List<String> get _allGenres {
    final genresSet = <String>{};
    for (var movie in movieDatabase) {
      genresSet.addAll(movie.genres);
    }
    return genresSet.toList()..sort();
  }

  /// Getter lọc và sắp xếp phim dựa trên từ khóa, các thể loại đã chọn và tiêu chí sort
  List<Movie> get _filteredAndSortedMovies {
    var movies = movieDatabase.where((movie) {
      // 1. Lọc theo từ khóa tìm kiếm (tiêu đề phim)
      final matchesSearch =
          movie.title.toLowerCase().contains(_searchQuery.toLowerCase());

      // 2. Lọc theo thể loại đã chọn (nếu có chọn)
      final matchesGenres = _selectedGenres.isEmpty ||
          _selectedGenres.every((genre) => movie.genres.contains(genre));

      return matchesSearch && matchesGenres;
    }).toList();

    // 3. Tiến hành sắp xếp danh sách kết quả
    if (_sortBy == 'A-Z') {
      movies.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sortBy == 'Z-A') {
      movies.sort((a, b) => b.title.compareTo(a.title));
    } else if (_sortBy == 'Year') {
      movies.sort((a, b) => b.year.compareTo(a.year));
    } else if (_sortBy == 'Rating') {
      movies.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return movies;
  }

  /// Thiết kế cấu trúc Card hiển thị phim theo hàng ngang dành cho Mobile (ListView)
  Widget _buildMovieListCard(Movie movie) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Image.network(
            movie.posterUrl,
            width: 90,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 90,
              height: 120,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(movie.rating.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(width: 12),
                      Text('Năm: ${movie.year}',
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: movie.genres
                        .map((g) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                g,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                ),
                              ),
                            ))
                        .toList(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Thiết kế cấu trúc Card hiển thị phim dành cho màn hình Tablet/Desktop rộng hơn (GridView 2 cột)
  Widget _buildMovieGridCard(Movie movie) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Image.network(
            movie.posterUrl,
            width: 120,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 120,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(
                        movie.rating.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        '•  ${movie.year}',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: movie.genres
                        .map((g) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                g,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSecondaryContainer,
                                ),
                              ),
                            ))
                        .toList(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// Hàm xây dựng giao diện chính của MovieBrowserScreen gồm bộ điều khiển lọc tìm kiếm và danh sách hiển thị responsive
  @override
  Widget build(BuildContext context) {
    final sortedMovies = _filteredAndSortedMovies;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trình Duyệt Phim'),
        centerTitle: true,
        elevation: 2,
        shadowColor: Colors.black26,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Panel điều khiển chứa ô tìm kiếm, dropdown sắp xếp và danh sách chips thể loại
            Container(
              padding: const EdgeInsets.all(16.0),
              color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm tiêu đề phim...',
                            prefixIcon: const Icon(Icons.search),
                            isDense: true,
                            contentPadding: const EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[600]!),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _sortBy,
                            icon: const Icon(Icons.sort),
                            items: const [
                              DropdownMenuItem(
                                  value: 'A-Z', child: Text('A-Z')),
                              DropdownMenuItem(
                                  value: 'Z-A', child: Text('Z-A')),
                              DropdownMenuItem(
                                  value: 'Year', child: Text('Năm')),
                              DropdownMenuItem(
                                  value: 'Rating', child: Text('Đánh giá')),
                            ],
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _sortBy = val;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Lọc theo thể loại:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: _allGenres.map((genre) {
                      final isSelected = _selectedGenres.contains(genre);
                      return FilterChip(
                        label: Text(genre),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedGenres.add(genre);
                            } else {
                              _selectedGenres.remove(genre);
                            }
                          });
                        },
                        selectedColor:
                            Theme.of(context).colorScheme.primaryContainer,
                        checkmarkColor:
                            Theme.of(context).colorScheme.onPrimaryContainer,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Danh sách phim hiển thị theo chế độ responsive thông qua LayoutBuilder
            Expanded(
              child: sortedMovies.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.movie_filter_outlined,
                              size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Không tìm thấy bộ phim nào phù hợp!',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        // Quyết định layout ListView (nếu < 800) hoặc GridView (nếu >= 800)
                        if (constraints.maxWidth < 800) {
                          return ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: sortedMovies.length,
                            itemBuilder: (context, index) {
                              return _buildMovieListCard(sortedMovies[index]);
                            },
                          );
                        } else {
                          return GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 2.2,
                            ),
                            itemCount: sortedMovies.length,
                            itemBuilder: (context, index) {
                              return _buildMovieGridCard(sortedMovies[index]);
                            },
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
