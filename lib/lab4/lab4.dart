// Lab 4 - Basic Widgets & UI Fixes
//
// Cách chạy Lab 4:
// Thay đổi nội dung file main.dart thành:
//
// import 'package:flutter/material.dart';
// import 'lab4/lab4.dart';
// void main() {
//   runApp(const Lab4App());
// }

import 'package:flutter/material.dart';

/// Lớp chính của Lab 4 kế thừa StatefulWidget để quản lý trạng thái giao diện (Dark/Light theme)
class Lab4App extends StatefulWidget {
  const Lab4App({super.key});

  /// Tạo trạng thái State cho Lab4App
  @override
  State<Lab4App> createState() => _Lab4AppState();
}

/// Trạng thái của Lab4App quản lý ThemeMode (Sáng/Tối) của ứng dụng
class _Lab4AppState extends State<Lab4App> {
  // Biến lưu trữ chế độ giao diện hiện tại của ứng dụng
  ThemeMode _themeMode = ThemeMode.light;

  /// Hàm xử lý chuyển đổi qua lại giữa Chế độ sáng và Chế độ tối
  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  /// Hàm xây dựng MaterialApp với cấu hình Material 3 và cấu hình Theme sáng/tối dựa trên trạng thái
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 4 - Flutter Basics',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
      ),
      home: Lab4HomeScreen(
        themeMode: _themeMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

/// Màn hình menu chính của Lab 4 chứa danh sách 5 bài tập dưới dạng các thẻ Card
class Lab4HomeScreen extends StatelessWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const Lab4HomeScreen({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  /// Hàm xây dựng giao diện menu chính của Lab 4
  @override
  Widget build(BuildContext context) {
    // Định nghĩa danh sách các bài tập gồm tiêu đề, mô tả, biểu tượng, màn hình điều hướng và màu sắc chủ đạo
    final List<Map<String, dynamic>> exercises = [
      {
        'title': 'Exercise 1: Basic Widgets',
        'subtitle': 'Text, Image, Icon, Card, ListTile',
        'icon': Icons.widgets_outlined,
        'screen': const Exercise1Screen(),
        'color': Colors.blue,
      },
      {
        'title': 'Exercise 2: Input Controls',
        'subtitle': 'Slider, Switch, Radio, DatePicker',
        'icon': Icons.input_outlined,
        'screen': const Exercise2Screen(),
        'color': Colors.green,
      },
      {
        'title': 'Exercise 3: Bố cục Layout',
        'subtitle': 'Column, Row, Padding, ListView',
        'icon': Icons.dashboard_customize_outlined,
        'screen': const Exercise3Screen(),
        'color': Colors.orange,
      },
      {
        'title': 'Exercise 4: Scaffold & Theme',
        'subtitle': 'AppBar, FAB, Dark Mode Toggle',
        'icon': Icons.dark_mode_outlined,
        'screen': Exercise4Screen(
          themeMode: themeMode,
          onToggleTheme: onToggleTheme,
        ),
        'color': Colors.purple,
      },
      {
        'title': 'Exercise 5: Sửa lỗi UI & State',
        'subtitle': 'ListView, Overflow, setState, Context',
        'icon': Icons.build_circle_outlined,
        'screen': const Exercise5Screen(),
        'color': Colors.red,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 4 - Flutter UI Basics'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: themeMode == ThemeMode.light
                ? [const Color(0xFFF9F7FC), const Color(0xFFF1EEF6)]
                : [const Color(0xFF121212), const Color(0xFF1E1E1E)],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16.0),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16.0),
                onTap: () {
                  // Điều hướng sang màn hình bài tập tương ứng
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => exercise['screen'] as Widget),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (exercise['color'] as Color).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          exercise['icon'] as IconData,
                          color: exercise['color'] as Color,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise['title'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              exercise['subtitle'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios, size: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==========================================
// EXERCISE 1 SCREEN: Basic Widgets
// ==========================================
/// Màn hình minh họa các widget cơ bản: Text, Image.network, Icon, Card, ListTile
class Exercise1Screen extends StatelessWidget {
  const Exercise1Screen({super.key});

  /// Hàm dựng giao diện Exercise1Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 1: Basic Widgets'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  'https://picsum.photos/800/400',
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Trả về widget thay thế nếu không tải được ảnh từ network
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image,
                          size: 50, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 30),
                        const SizedBox(width: 8),
                        Text(
                          'Khám phá Flutter',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Flutter là một SDK mã nguồn mở dành cho ứng dụng di động được tạo ra bởi Google. '
                      'Nó được sử dụng để phát triển các ứng dụng cho Android và iOS, cũng như là phương thức chính '
                      'để tạo ứng dụng cho Google Fuchsia.',
                      style: TextStyle(fontSize: 15, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.phone, color: Colors.blue),
                    title: const Text('Số điện thoại hỗ trợ'),
                    subtitle: const Text('+84 123 456 789'),
                    trailing: IconButton(
                      icon: const Icon(Icons.call),
                      onPressed: () {},
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.red),
                    title: const Text('Email liên hệ'),
                    subtitle: const Text('support@flutter.com'),
                    trailing: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// EXERCISE 2 SCREEN: Input Controls
// ==========================================
/// Màn hình chứa các điều khiển nhập liệu: Slider, Switch, RadioListTile, DatePicker
class Exercise2Screen extends StatefulWidget {
  const Exercise2Screen({super.key});

  /// Tạo state quản lý thay đổi đầu vào của các điều khiển nhập liệu
  @override
  State<Exercise2Screen> createState() => _Exercise2ScreenState();
}

/// Trạng thái lưu trữ của các input: giá trị Slider, trạng thái bật tắt Switch, phương án được chọn, ngày đã chọn
class _Exercise2ScreenState extends State<Exercise2Screen> {
  double _sliderValue = 50.0;
  bool _switchValue = true;
  String _selectedRadio = 'Option A';
  DateTime? _selectedDate;

  /// Hàm bất đồng bộ gọi hiển thị hộp thoại chọn ngày DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      // Đảm bảo widget chưa bị gỡ khỏi widget tree trước khi setState
      if (!mounted) return;
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  /// Hàm dựng giao diện Exercise2Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 2: Input Controls'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Slider: Mức độ hài lòng ($_sliderValue%)',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    value: _sliderValue,
                    min: 0.0,
                    max: 100.0,
                    divisions: 10,
                    label: _sliderValue.round().toString(),
                    onChanged: (double value) {
                      setState(() {
                        _sliderValue = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: SwitchListTile(
              title: const Text('Nhận thông báo',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Bật để nhận tin tức mới nhất qua email'),
              value: _switchValue,
              onChanged: (bool value) {
                setState(() {
                  _switchValue = value;
                });
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Chọn phương án tốt nhất:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  RadioListTile<String>(
                    title: const Text('Phương án A'),
                    value: 'Option A',
                    groupValue: _selectedRadio,
                    onChanged: (value) {
                      setState(() {
                        _selectedRadio = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Phương án B'),
                    value: 'Option B',
                    groupValue: _selectedRadio,
                    onChanged: (value) {
                      setState(() {
                        _selectedRadio = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Chọn ngày sinh:',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          _selectedDate == null
                              ? 'Chưa chọn ngày'
                              : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Chọn Ngày'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// EXERCISE 3 SCREEN: Column, Row, Padding & ListView
// ==========================================
/// Màn hình minh họa thiết kế layout với các widget: Column, Row, Padding, SizedBox, ListView.builder
class Exercise3Screen extends StatelessWidget {
  const Exercise3Screen({super.key});

  /// Hàm tạo nhanh các nút chức năng dạng vòng tròn với icon và nhãn tương ứng
  Widget _buildActionItem(
      BuildContext context, IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  /// Hàm dựng giao diện layout của Exercise3Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 3: Bố cục Layout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionItem(
                    context, Icons.share, 'Chia sẻ', Colors.indigo),
                _buildActionItem(
                    context, Icons.favorite, 'Yêu thích', Colors.red),
                _buildActionItem(
                    context, Icons.comment, 'Bình luận', Colors.green),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: 15,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          child: Text('${index + 1}'),
                        ),
                        title: Text('Thành viên nhóm ${index + 1}'),
                        subtitle: const Text('Vai trò: Thành viên tích cực'),
                        trailing: const Icon(Icons.check_circle,
                            color: Colors.green, size: 20),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// EXERCISE 4 SCREEN: Scaffold, Theme & Toggle
// ==========================================
/// Màn hình minh họa sử dụng Scaffold, AppBar, FloatingActionButton và Toggle Dark/Light Mode
class Exercise4Screen extends StatelessWidget {
  final ThemeMode themeMode;
  final VoidCallback onToggleTheme;

  const Exercise4Screen({
    super.key,
    required this.themeMode,
    required this.onToggleTheme,
  });

  /// Hàm dựng giao diện Exercise4Screen
  @override
  Widget build(BuildContext context) {
    final isDark = themeMode == ThemeMode.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 4: Scaffold & Theme'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isDark ? Icons.dark_mode : Icons.light_mode,
              size: 80,
              color: isDark ? Colors.amber : Colors.orange,
            ),
            const SizedBox(height: 20),
            Text(
              isDark
                  ? 'Chế độ tối (Dark Mode) đang bật'
                  : 'Chế độ sáng (Light Mode) đang bật',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: onToggleTheme,
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              label: Text(isDark
                  ? 'Chuyển sang Chế độ sáng'
                  : 'Chuyển sang Chế độ tối'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Hiển thị thông báo nhanh khi bấm FAB
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đây là FloatingActionButton!')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ==========================================
// EXERCISE 5 SCREEN: Common UI & State Bug Fixes
// ==========================================
/// Màn hình minh họa chi tiết và cách khắc phục 4 lỗi phổ biến nhất trong Flutter
class Exercise5Screen extends StatefulWidget {
  const Exercise5Screen({super.key});

  /// Tạo state cho Exercise5Screen
  @override
  State<Exercise5Screen> createState() => _Exercise5ScreenState();
}

/// Trạng thái lưu trữ các biến phục vụ cho demo fix lỗi setState và DatePicker
class _Exercise5ScreenState extends State<Exercise5Screen> {
  // Biến dùng để demo fix setState issue trong Dialog
  bool _dialogSwitch = false;
  DateTime? _fixedDatePickerDate;

  /// Hàm phụ trợ để xây dựng nhanh các thẻ thông báo lỗi và giải pháp tương ứng
  Widget _buildBugFixSection({
    required String title,
    required String description,
    required String fixDescription,
    required Widget demoWidget,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.teal)),
            const SizedBox(height: 8),
            Text(description,
                style: const TextStyle(fontSize: 13, color: Colors.redAccent)),
            const SizedBox(height: 8),
            Text(fixDescription,
                style: const TextStyle(fontSize: 13, color: Colors.green)),
            const SizedBox(height: 12),
            demoWidget,
          ],
        ),
      ),
    );
  }

  /// Hàm dựng giao diện hiển thị các phần hướng dẫn sửa lỗi của Exercise5Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5: Sửa lỗi UI & State'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. ListView inside Column Error & Fix demo
            _buildBugFixSection(
              title: '1. Lỗi ListView trong Column (Chưa khai báo chiều cao)',
              description:
                  'Lỗi xảy ra: Lỗi vỡ giao diện (RenderBox was not laid out) khi ListView.builder đặt trực tiếp trong Column mà không chỉ rõ chiều cao.',
              fixDescription:
                  'Giải pháp: Bọc ListView.builder trong widget Expanded (để chiếm hết không gian còn lại) hoặc đặt chiều cao cố định bằng SizedBox.',
              demoWidget: Container(
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Container(
                      color: Colors.green.withOpacity(0.1),
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      child: const Text('Tiêu đề Column',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, idx) => ListTile(
                          title: Text(
                              'Mục danh sách thứ $idx (Đã sửa bằng Expanded)'),
                          dense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 2. Overflow/Keyboard issue demo
            _buildBugFixSection(
              title: '2. Lỗi Overflow bàn phím / nội dung màn hình',
              description:
                  'Lỗi xảy ra: Bị vạch sọc vàng đen (overflow) khi nội dung quá dài hoặc khi bàn phím ảo đẩy lên che khuất nội dung.',
              fixDescription:
                  'Giải pháp: Sử dụng SingleChildScrollView để bọc nội dung, giúp màn hình cuộn được khi tràn không gian.',
              demoWidget: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.indigo, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Màn hình hiện tại bạn đang cuộn này là một ví dụ! Nó sử dụng SingleChildScrollView bao bọc để tránh bị lỗi tràn viền khi có nhiều thẻ hướng dẫn lỗi.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. setState inside Dialog update issue
            _buildBugFixSection(
              title:
                  '3. Lỗi setState trong Dialog/BottomSheet không cập nhật UI',
              description:
                  'Lỗi xảy ra: Gọi setState() ở widget cha nhưng switch hoặc slider bên trong AlertDialog/BottomSheet không cập nhật do dialog dùng context riêng.',
              fixDescription:
                  'Giải pháp: Sử dụng StatefulBuilder bên trong Dialog hoặc tách nội dung Dialog thành một StatefulWidget riêng để gọi setState nội bộ.',
              demoWidget: ElevatedButton(
                onPressed: () {
                  // Mở hộp thoại chứa StatefulBuilder để tự cập nhật state cục bộ
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Sửa lỗi setState trong Dialog'),
                        content: StatefulBuilder(
                          builder: (context, setStateInDialog) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Thay đổi Switch dưới đây:'),
                                SwitchListTile(
                                  title: Text(_dialogSwitch
                                      ? 'Trạng thái: Bật'
                                      : 'Trạng thái: Tắt'),
                                  value: _dialogSwitch,
                                  onChanged: (val) {
                                    // Ta phải dùng setState của StatefulBuilder để update cục bộ dialog
                                    setStateInDialog(() {
                                      _dialogSwitch = val;
                                    });
                                    // Và cập nhật lại state của widget cha để đồng bộ
                                    setState(() {});
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Đóng'),
                          )
                        ],
                      );
                    },
                  );
                },
                child: Text(
                    'Mở Dialog Demo (Trạng thái hiện tại: ${_dialogSwitch ? "Bật" : "Tắt"})'),
              ),
            ),
            const SizedBox(height: 20),

            // 4. DatePicker Context Issue
            _buildBugFixSection(
              title:
                  '4. Lỗi DatePicker dùng sai context / setState sau khi dispose',
              description:
                  'Lỗi xảy ra: Gọi showDatePicker bằng một context bất đồng bộ đã bị huỷ (unmounted) dẫn đến crash ứng dụng.',
              fixDescription:
                  'Giải pháp: Kiểm tra kiểm định mounted (if (!mounted) return;) sau khi kết quả async trả về trước khi gọi setState().',
              demoWidget: ElevatedButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    // Cực kỳ quan trọng để kiểm tra xem widget còn tồn tại trên màn hình không
                    if (!mounted) return;
                    setState(() {
                      _fixedDatePickerDate = pickedDate;
                    });
                  }
                },
                child: Text(
                  _fixedDatePickerDate == null
                      ? 'Chọn ngày an toàn'
                      : 'Ngày đã chọn: ${_fixedDatePickerDate!.day}/${_fixedDatePickerDate!.month}/${_fixedDatePickerDate!.year}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
