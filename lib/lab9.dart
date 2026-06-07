// Lab 9 - JSON Local Storage & CRUD Auto-save
//
// Cách chạy Lab 9:
// Thay đổi nội dung file main.dart thành:
//
// import 'package:flutter/material.dart';
// import 'lab9.dart';
// void main() {
//   runApp(const Lab9App());
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// Lớp chính của Lab 9 App kế thừa StatelessWidget
class Lab9App extends StatelessWidget {
  const Lab9App({super.key});

  /// Hàm xây dựng MaterialApp cấu hình theme Teal (Material 3)
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 9 - Local Storage & CRUD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00796B), // Teal
          brightness: Brightness.light,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

/// Màn hình điều hướng Tab chính tích hợp 3 phân mục bài tập Lab 9.1, 9.2, 9.3
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  /// Tạo State quản lý điều khiển chuyển đổi các Tab qua lại
  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

/// Trạng thái lưu trữ của MainNavigationScreen
class _MainNavigationScreenState extends State<MainNavigationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  /// Khởi tạo TabController chứa 3 tabs điều hướng
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  /// Giải phóng tài nguyên TabController khi widget bị hủy
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Hàm dựng màn hình Scaffold kết hợp TabBar và TabBarView
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9: JSON & Local Storage'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.folder_open), text: '9.1: Assets JSON'),
            Tab(icon: Icon(Icons.save_alt), text: '9.2: Local IO'),
            Tab(icon: Icon(Icons.edit_note), text: '9.3: CRUD Auto-save'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Lab9_1Screen(),
          Lab9_2Screen(),
          Lab9_3Screen(),
        ],
      ),
    );
  }
}

// ========================================================
// LAB 9.1: ĐỌC JSON TỪ ASSETS
// ========================================================
/// Màn hình đọc dữ liệu JSON thô từ Assets và hiển thị ra ListView
class Lab9_1Screen extends StatefulWidget {
  const Lab9_1Screen({super.key});

  /// Tạo State quản lý dữ liệu tải từ Assets
  @override
  State<Lab9_1Screen> createState() => _Lab9_1ScreenState();
}

/// Trạng thái của Lab9_1Screen
class _Lab9_1ScreenState extends State<Lab9_1Screen> {
  List<dynamic> _assetsData = [];
  bool _isLoading = true;
  String _errorMsg = '';

  /// Khởi chạy ban đầu để kích hoạt đọc Assets JSON ngay lập tức
  @override
  void initState() {
    super.initState();
    _loadJsonFromAssets();
  }

  /// Hàm bất đồng bộ đọc file json mẫu từ thư mục assets qua rootBundle
  Future<void> _loadJsonFromAssets() async {
    try {
      final String response = await rootBundle.loadString('assets/sample_data.json');
      final data = jsonDecode(response);
      setState(() {
        _assetsData = data as List<dynamic>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMsg = 'Lỗi đọc assets: $e\nĐảm bảo bạn đã khai báo thư mục assets trong pubspec.yaml!';
        _isLoading = false;
      });
    }
  }

  /// Hàm dựng màn hình hiển thị danh sách phim đọc từ assets
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMsg.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMsg,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _assetsData.length,
      itemBuilder: (context, index) {
        final item = _assetsData[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Text(item['id']?.toString() ?? ''),
            ),
            title: Text(
              item['title']?.toString() ?? 'Không có tên',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('Thể loại: ${item['genre'] ?? "N/A"} | Năm: ${item['year'] ?? "N/A"}'),
                const SizedBox(height: 4),
                Text(
                  item['description']?.toString() ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            isThreeLine: true,
          ),
        );
      },
    );
  }
}

// ========================================================
// LAB 9.2: LƯU & TẢI TỆP CỤC BỘ (LOCAL FILE I/O)
// ========================================================
/// Màn hình minh họa cách ghi và đọc tệp tin JSON cục bộ (Local Storage) thông qua path_provider
class Lab9_2Screen extends StatefulWidget {
  const Lab9_2Screen({super.key});

  /// Tạo State quản lý hoạt động đọc/ghi file
  @override
  State<Lab9_2Screen> createState() => _Lab9_2ScreenState();
}

/// Trạng thái của Lab9_2Screen
class _Lab9_2ScreenState extends State<Lab9_2Screen> {
  String _fileContent = 'Chưa có dữ liệu nào được tải.';
  bool _isSaving = false;

  /// Hàm phụ trợ lấy đường dẫn tuyệt đối của tệp tin lưu trữ cục bộ trên máy
  Future<File> _getLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/local_movies.json');
  }

  /// Hàm bất đồng bộ ghi một chuỗi JSON mẫu vào bộ nhớ thiết bị
  Future<void> _saveToLocalFile() async {
    setState(() => _isSaving = true);
    try {
      final file = await _getLocalFile();
      final sampleData = [
        {'id': 101, 'title': 'Lưu trữ cục bộ 1', 'date': DateTime.now().toIso8601String()},
        {'id': 102, 'title': 'Lưu trữ cục bộ 2', 'date': DateTime.now().toIso8601String()},
      ];
      await file.writeAsString(jsonEncode(sampleData));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã lưu dữ liệu vào Local File thành công!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ghi file thất bại: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  /// Hàm bất đồng bộ đọc nội dung tệp tin JSON cục bộ và định dạng đẹp mắt để hiển thị
  Future<void> _readFromLocalFile() async {
    try {
      final file = await _getLocalFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final parsedJson = jsonDecode(content);
        final prettyString = const JsonEncoder.withIndent('  ').convert(parsedJson);

        setState(() {
          _fileContent = prettyString;
        });
      } else {
        setState(() {
          _fileContent = 'File cục bộ không tồn tại! Vui lòng nhấn nút Lưu trước.';
        });
      }
    } catch (e) {
      setState(() {
        _fileContent = 'Lỗi đọc file: $e';
      });
    }
  }

  /// Hàm dựng giao diện chính của Lab9_2Screen
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveToLocalFile,
                  icon: const Icon(Icons.cloud_upload),
                  label: Text(_isSaving ? 'Đang lưu...' : 'Lưu File Cục Bộ'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _readFromLocalFile,
                  icon: const Icon(Icons.cloud_download),
                  label: const Text('Đọc File Cục Bộ'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Nội dung tệp tin cục bộ:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[400]!),
              ),
              child: SingleChildScrollView(
                child: Text(
                  _fileContent,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 13, color: Colors.black87),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ========================================================
// LAB 9.3: CRUD THAO TÁC CÓ TỰ ĐỘNG LƯU (AUTO-SAVE)
// ========================================================
/// Màn hình quản lý CRUD phim đầy đủ tính năng Thêm, Sửa, Xóa, Tìm kiếm tích hợp cơ chế tự động lưu (Auto-save)
class Lab9_3Screen extends StatefulWidget {
  const Lab9_3Screen({super.key});

  /// Tạo State quản lý vòng đời dữ liệu CRUD và Auto-save
  @override
  State<Lab9_3Screen> createState() => _Lab9_3ScreenState();
}

/// Trạng thái lưu trữ của Lab9_3Screen
class _Lab9_3ScreenState extends State<Lab9_3Screen> {
  // Danh sách các bộ phim đang được thao tác CRUD
  List<Map<String, dynamic>> _crudItems = [];
  // Từ khóa tìm kiếm phim
  String _searchQuery = '';
  // Biến kiểm soát trạng thái tải dữ liệu
  bool _isLoading = true;
  // Biến kiểm soát trạng thái tự động lưu ngầm
  bool _isAutoSaving = false;

  /// Khởi chạy ban đầu kích hoạt load dữ liệu cũ lên
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  /// Hàm lấy đường dẫn file lưu trữ dữ liệu CRUD
  Future<File> _getCrudFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/crud_data.json');
  }

  /// Hàm tải dữ liệu khởi chạy ban đầu: Đọc file CRUD cũ nếu có, ngược lại load từ assets và lưu đè
  Future<void> _loadInitialData() async {
    try {
      final file = await _getCrudFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> parsed = jsonDecode(content);
        setState(() {
          _crudItems = List<Map<String, dynamic>>.from(parsed);
          _isLoading = false;
        });
      } else {
        // Tải dự phòng dữ liệu mẫu từ Assets làm điểm bắt đầu
        final String response = await rootBundle.loadString('assets/sample_data.json');
        final List<dynamic> parsed = jsonDecode(response);
        setState(() {
          _crudItems = List<Map<String, dynamic>>.from(parsed);
          _isLoading = false;
        });
        await _saveData();
      }
    } catch (e) {
      setState(() {
        _crudItems = [];
        _isLoading = false;
      });
    }
  }

  /// Hàm bất đồng bộ lưu dữ liệu xuống file local (Được gọi tự động sau mỗi thay đổi CRUD)
  Future<void> _saveData() async {
    setState(() => _isAutoSaving = true);
    try {
      final file = await _getCrudFile();
      await file.writeAsString(jsonEncode(_crudItems));
    } catch (e) {
      debugPrint('Lỗi tự động lưu: $e');
    } finally {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) {
        setState(() => _isAutoSaving = false);
      }
    }
  }

  /// Hàm thêm một bộ phim mới vào danh sách đầu tiên và kích hoạt Auto-save
  void _addItem(String title, String genre, String year, String description) {
    final newItem = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'genre': genre,
      'year': year,
      'description': description,
    };
    setState(() {
      _crudItems.insert(0, newItem);
    });
    _saveData();
  }

  /// Hàm cập nhật chỉnh sửa một bộ phim đã tồn tại và kích hoạt Auto-save
  void _editItem(String id, String title, String genre, String year, String description) {
    setState(() {
      final index = _crudItems.indexWhere((item) => item['id'].toString() == id);
      if (index != -1) {
        _crudItems[index] = {
          'id': id,
          'title': title,
          'genre': genre,
          'year': year,
          'description': description,
        };
      }
    });
    _saveData();
  }

  /// Hàm xóa một bộ phim ra khỏi danh sách và kích hoạt Auto-save
  void _deleteItem(String id) {
    setState(() {
      _crudItems.removeWhere((item) => item['id'].toString() == id);
    });
    _saveData();
  }

  /// Getter lọc danh sách hiển thị dựa trên từ khóa tìm kiếm
  List<Map<String, dynamic>> get _filteredItems {
    if (_searchQuery.trim().isEmpty) return _crudItems;
    return _crudItems.where((item) {
      return item['title'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  /// Hàm mở Dialog nhập liệu phục vụ cả Thêm mới và Chỉnh sửa bộ phim
  void _openItemDialog({Map<String, dynamic>? item}) {
    final isEdit = item != null;
    final titleController = TextEditingController(text: isEdit ? item['title'] : '');
    final genreController = TextEditingController(text: isEdit ? item['genre'] : '');
    final yearController = TextEditingController(text: isEdit ? item['year'] : '');
    final descController = TextEditingController(text: isEdit ? item['description'] : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Chỉnh sửa phim' : 'Thêm phim mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Tên phim (*)', isDense: true),
                ),
                TextField(
                  controller: genreController,
                  decoration: const InputDecoration(labelText: 'Thể loại', isDense: true),
                ),
                TextField(
                  controller: yearController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Năm sản xuất', isDense: true),
                ),
                TextField(
                  controller: descController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Mô tả tóm tắt', isDense: true),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                final t = titleController.text.trim();
                final g = genreController.text.trim();
                final y = yearController.text.trim();
                final d = descController.text.trim();

                if (t.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vui lòng nhập tên phim!')),
                  );
                  return;
                }

                if (isEdit) {
                  _editItem(item['id'].toString(), t, g, y, d);
                } else {
                  _addItem(t, g, y, d);
                }

                Navigator.pop(context);
              },
              child: Text(isEdit ? 'Cập nhật' : 'Thêm mới'),
            ),
          ],
        );
      },
    );
  }

  /// Hàm dựng giao diện chính của Lab9_3Screen tích hợp nút Thêm và Tìm kiếm
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final displayItems = _filteredItems;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openItemDialog(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm theo tên phim...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(10),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedCrossFade(
                  firstChild: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.autorenew, color: Colors.teal, size: 18),
                        SizedBox(width: 4),
                        Text('Auto-saving...', style: TextStyle(fontSize: 12, color: Colors.teal)),
                      ],
                    ),
                  ),
                  secondChild: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.grey, size: 18),
                        SizedBox(width: 4),
                        Text('Saved', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  crossFadeState: _isAutoSaving ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  duration: const Duration(milliseconds: 200),
                )
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: displayItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.find_in_page_outlined, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 12),
                          const Text('Không tìm thấy bản ghi nào.'),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: displayItems.length,
                      itemBuilder: (context, index) {
                        final item = displayItems[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            title: Text(
                              item['title']?.toString() ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Thể loại: ${item['genre'] ?? "N/A"} | Năm: ${item['year'] ?? "N/A"}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () => _openItemDialog(item: item),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteItem(item['id'].toString()),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
