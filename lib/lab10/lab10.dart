// Lab 10 - Auth Integration, Session & Notifications
//
// Cách chạy Lab 10:
// Thay đổi nội dung file main.dart thành:
//
// import 'package:flutter/material.dart';
// import 'lab10/lab10.dart';
// void main() {
//   runApp(const Lab10App());
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Khởi tạo global instance cho Local Notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Hàm bất đồng bộ thiết lập cấu hình khởi tạo của hệ thống thông báo Local Notification
Future<void> initNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

/// Hàm bất đồng bộ gọi hiển thị một thông báo hệ thống lập tức với tiêu đề và nội dung được chọn
Future<void> showNotification(
    {required String title, required String body}) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'lab10_channel_id',
    'Lab 10 Channel',
    channelDescription: 'Kênh thông báo cho Lab 10',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );
  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: DarwinNotificationDetails(),
  );
  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    notificationDetails,
  );
}

// -------------------------------------------------------------
// LAB 10 APP ENTRY POINT
// -------------------------------------------------------------
/// Lớp chính của Lab 10 App kế thừa StatefulWidget để khởi tạo các dịch vụ nền
class Lab10App extends StatefulWidget {
  const Lab10App({super.key});

  /// Tạo State quản lý trạng thái khởi chạy dịch vụ
  @override
  State<Lab10App> createState() => _Lab10AppState();
}

/// Trạng thái lưu trữ của Lab10App
class _Lab10AppState extends State<Lab10App> {
  // Trạng thái cho biết Firebase đã kết nối thành công chưa
  bool _firebaseInitialized = false;

  /// Kích hoạt thiết lập các dịch vụ hệ thống ngay khi chạy
  @override
  void initState() {
    super.initState();
    _setupServices();
  }

  /// Hàm bất đồng bộ khởi tạo an toàn cho Local Notification và Firebase (Tránh crash nếu thiếu file cấu hình native)
  Future<void> _setupServices() async {
    // 1. Khởi tạo Local Notification
    try {
      await initNotifications();
    } catch (e) {
      debugPrint("Lỗi khởi tạo thông báo: $e");
    }

    // 2. Khởi tạo Firebase
    try {
      await Firebase.initializeApp();
      setState(() {
        _firebaseInitialized = true;
      });
    } catch (e) {
      debugPrint("Firebase chưa được cấu hình native: $e");
    }
  }

  /// Hàm dựng ứng dụng MaterialApp hỗ trợ Dark/Light ThemeMode
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10 - Auth & System Integration',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3F51B5), // Indigo
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3F51B5),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: Lab10MenuScreen(firebaseInitialized: _firebaseInitialized),
    );
  }
}

// -------------------------------------------------------------
// LAB 10 MENU SCREEN
// -------------------------------------------------------------
/// Màn hình menu chính của Lab 10 chứa danh sách 6 mục bài tập cụ thể
class Lab10MenuScreen extends StatelessWidget {
  final bool firebaseInitialized;

  const Lab10MenuScreen({super.key, required this.firebaseInitialized});

  /// Hàm xây dựng giao diện hiển thị danh sách các mục bài tập
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> menuItems = [
      {
        'title': '10.1 Mock Login',
        'subtitle': 'Đăng nhập giả lập với delay 2s',
        'icon': Icons.login_outlined,
        'color': Colors.blue,
        'widget': const MockLoginScreen(),
      },
      {
        'title': '10.2 Real API Login',
        'subtitle': 'Đăng nhập thật qua DummyJSON API',
        'icon': Icons.api_outlined,
        'color': Colors.green,
        'widget': const RealApiLoginScreen(),
      },
      {
        'title': '10.3 Session Persistence',
        'subtitle': 'Lưu phiên & Tự động Đăng nhập',
        'icon': Icons.history_toggle_off_outlined,
        'color': Colors.orange,
        'widget': const AutoLoginScreen(),
      },
      {
        'title': '10.4 Google Sign In',
        'subtitle': 'Xác thực tài khoản Google qua Firebase',
        'icon': Icons.g_mobiledata,
        'color': Colors.red,
        'widget': GoogleSignInScreen(firebaseInitialized: firebaseInitialized),
      },
      {
        'title': '10.5 Local Notification',
        'subtitle': 'Cấp quyền & Kích hoạt thông báo hệ thống',
        'icon': Icons.notifications_active_outlined,
        'color': Colors.teal,
        'widget': const NotificationScreen(),
      },
      {
        'title': 'Lab 10 Full Integration',
        'subtitle': 'Tích hợp đầy đủ luồng Xác thực & Thông báo',
        'icon': Icons.integration_instructions_outlined,
        'color': Colors.indigo,
        'widget':
            FullIntegrationScreen(firebaseInitialized: firebaseInitialized),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 10: Auth & System Integration'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 3,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: (item['color'] as Color).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(item['icon'] as IconData,
                    color: item['color'] as Color),
              ),
              title: Text(item['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(item['subtitle'] as String),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => item['widget'] as Widget),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// -------------------------------------------------------------
// 10.1 MOCK LOGIN SCREEN
// -------------------------------------------------------------
/// Màn hình đăng nhập giả lập có kiểm thử dữ liệu nhập và delay mô phỏng mạng
class MockLoginScreen extends StatefulWidget {
  const MockLoginScreen({super.key});

  /// Tạo State quản lý nhập liệu
  @override
  State<MockLoginScreen> createState() => _MockLoginScreenState();
}

/// Trạng thái lưu trữ của MockLoginScreen
class _MockLoginScreenState extends State<MockLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  /// Giải phóng bộ nhớ của các bộ điều khiển khi widget bị hủy
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Hàm giả lập quá trình đăng nhập chậm 2 giây
  void _handleMockLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() => _isLoading = false);
        // Chuyển hướng sang màn hình Home giả lập
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DummyHomeScreen(
                title: 'Mock Home', userEmail: 'mock_user@example.com'),
          ),
        );
      }
    }
  }

  /// Hàm dựng giao diện chính của MockLoginScreen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('10.1 Mock Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.lock_person_outlined,
                    size: 64, color: Colors.blue),
                const SizedBox(height: 16),
                const Text('Đăng nhập giả lập',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: 'Email', border: OutlineInputBorder()),
                  validator: (val) => (val == null || !val.contains('@'))
                      ? 'Email không hợp lệ'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Mật khẩu', border: OutlineInputBorder()),
                  validator: (val) => (val == null || val.length < 6)
                      ? 'Mật khẩu tối thiểu 6 ký tự'
                      : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleMockLogin,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Đăng Nhập'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 10.2 REAL API LOGIN SCREEN
// -------------------------------------------------------------
/// Màn hình đăng nhập kết nối API DummyJSON thực tế
class RealApiLoginScreen extends StatefulWidget {
  const RealApiLoginScreen({super.key});

  /// Tạo State quản lý đăng nhập thật
  @override
  State<RealApiLoginScreen> createState() => _RealApiLoginScreenState();
}

/// Trạng thái lưu trữ của RealApiLoginScreen
class _RealApiLoginScreenState extends State<RealApiLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspassword');
  bool _isLoading = false;

  /// Giải phóng bộ nhớ của các bộ điều khiển khi widget bị hủy
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Hàm bất đồng bộ gửi yêu cầu POST đăng nhập thực tế tới API DummyJSON
  void _handleRealLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final response = await http.post(
          Uri.parse('https://dummyjson.com/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': _usernameController.text.trim(),
            'password': _passwordController.text,
          }),
        );

        if (!mounted) return;
        setState(() => _isLoading = false);

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final token = data['token'] as String;
          final firstName = data['firstName'] as String? ?? 'User';

          // Gửi thông báo hệ thống chào mừng
          showNotification(
              title: 'Đăng nhập thành công!',
              body: 'Chào mừng trở lại, $firstName');

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DummyHomeScreen(
                  title: 'API Home - Chào $firstName',
                  userEmail: 'Token: ${token.substring(0, 10)}...'),
            ),
          );
        } else {
          final errorMsg = jsonDecode(response.body)['message'] ??
              'Sai tài khoản hoặc mật khẩu!';
          _showErrorDialog(errorMsg);
        }
      } catch (e) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        _showErrorDialog('Không thể kết nối máy chủ API: $e');
      }
    }
  }

  /// Hàm hiển thị Dialog thông báo lỗi đăng nhập chi tiết
  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lỗi Đăng Nhập'),
        content: Text(msg),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đồng ý')),
        ],
      ),
    );
  }

  /// Hàm dựng giao diện chính của RealApiLoginScreen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('10.2 Real API Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.api, size: 64, color: Colors.green),
                const SizedBox(height: 12),
                const Text(
                  'Đăng nhập qua DummyJSON API\n(Sử dụng tài khoản mẫu bên dưới)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                      labelText: 'Username', border: OutlineInputBorder()),
                  validator: (val) =>
                      (val == null || val.isEmpty) ? 'Nhập username' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      labelText: 'Password', border: OutlineInputBorder()),
                  validator: (val) =>
                      (val == null || val.isEmpty) ? 'Nhập password' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleRealLogin,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Đăng nhập API'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 10.3 SESSION PERSISTENCE (AUTO LOGIN) SCREEN
// -------------------------------------------------------------
/// Màn hình đăng nhập tự động lưu Session qua SharedPreferences
class AutoLoginScreen extends StatefulWidget {
  const AutoLoginScreen({super.key});

  /// Tạo State quản lý session
  @override
  State<AutoLoginScreen> createState() => _AutoLoginScreenState();
}

/// Trạng thái lưu trữ của AutoLoginScreen
class _AutoLoginScreenState extends State<AutoLoginScreen> {
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspassword');
  bool _isChecking = true;
  bool _isLoading = false;
  String? _savedToken;

  /// Kích hoạt tự động kiểm tra token cũ khi mở màn hình
  @override
  void initState() {
    super.initState();
    _checkSavedSession();
  }

  /// Giải phóng bộ nhớ của các bộ điều khiển khi widget bị hủy
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Hàm bất đồng bộ kiểm tra SharedPreferences xem đã lưu token đăng nhập chưa
  Future<void> _checkSavedSession() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    await Future.delayed(
        const Duration(seconds: 1)); // Delay tạo hiệu ứng kiểm tra
    if (mounted) {
      setState(() {
        _savedToken = token;
        _isChecking = false;
      });
    }
  }

  /// Hàm đăng nhập API và lưu Token, Tên người dùng xuống SharedPreferences để ghi nhớ phiên
  Future<void> _loginAndSave() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'] as String;

        // Ghi dữ liệu xuống SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('auth_name', data['firstName'] ?? 'User');

        showNotification(
            title: 'Tự động đăng nhập đã bật',
            body: 'Lần tới bạn không cần nhập mật khẩu nữa.');

        setState(() {
          _savedToken = token;
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Đăng nhập thất bại!')));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Lỗi kết nối: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Hàm Đăng xuất xóa bỏ toàn bộ Token lưu trữ và đưa về trạng thái Đăng nhập
  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_name');
    setState(() {
      _savedToken = null;
    });
  }

  /// Hàm dựng giao diện chính của AutoLoginScreen
  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Đang kiểm tra phiên làm việc...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('10.3 Session Persistence')),
      body: _savedToken != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle,
                        color: Colors.green, size: 72),
                    const SizedBox(height: 16),
                    const Text('Phiên Đăng Nhập Được Bảo Lưu!',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Token: ${_savedToken!.substring(0, 15)}...',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: _handleLogout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Đăng Xuất (Xóa Session)'),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(Icons.history_toggle_off,
                        size: 64, color: Colors.orange),
                    const SizedBox(height: 16),
                    const Text(
                        'Chưa có phiên làm việc. Hãy đăng nhập để lưu cấu hình.',
                        textAlign: TextAlign.center),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                          labelText: 'Username', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: 'Password', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _loginAndSave,
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48)),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Đăng nhập & Ghi nhớ phiên'),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

// -------------------------------------------------------------
// 10.4 GOOGLE SIGN IN SCREEN
// -------------------------------------------------------------
/// Màn hình xác thực tài khoản Google sử dụng Firebase Authentication
class GoogleSignInScreen extends StatefulWidget {
  final bool firebaseInitialized;

  const GoogleSignInScreen({super.key, required this.firebaseInitialized});

  /// Tạo State quản lý xác thực Google
  @override
  State<GoogleSignInScreen> createState() => _GoogleSignInScreenState();
}

/// Trạng thái lưu trữ của GoogleSignInScreen
class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  bool _isLoading = false;
  User? _currentUser;

  /// Đồng bộ hóa tài khoản đang đăng nhập từ FirebaseAuth nếu Firebase đã được khởi tạo
  @override
  void initState() {
    super.initState();
    if (widget.firebaseInitialized) {
      _currentUser = FirebaseAuth.instance.currentUser;
    }
  }

  /// Hàm bất đồng bộ thực hiện đăng nhập tài khoản Google an toàn, chống crash ứng dụng
  Future<void> _handleGoogleSignIn() async {
    if (!widget.firebaseInitialized) {
      _showFirebaseConfigManual();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        setState(() {
          _currentUser = userCredential.user;
        });

        showNotification(
          title: 'Google Login',
          body: 'Đăng nhập Google thành công: ${_currentUser?.displayName}',
        );
      }
    } catch (e) {
      _showErrorDialog(
          "Lỗi xác thực Google: $e\nLưu ý: Tính năng này yêu cầu cấu hình Firebase gốc (Android/iOS) và SHA-1 key.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Hàm bất đồng bộ đăng xuất tài khoản Google khỏi hệ thống
  Future<void> _handleGoogleSignOut() async {
    if (widget.firebaseInitialized) {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    }
    setState(() {
      _currentUser = null;
    });
  }

  /// Hiển thị hộp thoại hướng dẫn cấu hình thủ công Firebase
  void _showFirebaseConfigManual() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yêu cầu Cấu hình Firebase'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Tính năng Đăng nhập Google sử dụng Firebase thực tế yêu cầu bạn cấu hình nền tảng gốc. Các bước thực hiện:'),
              SizedBox(height: 12),
              Text('1. Cài đặt FlutterFire CLI trên máy tính.'),
              Text('2. Chạy lệnh: "flutterfire configure" tại thư mục dự án.'),
              Text(
                  '3. Đăng ký Web client ID và tải file google-services.json vào thư mục android/app/.'),
              Text('4. Tải file GoogleService-Info.plist cho iOS.'),
              SizedBox(height: 12),
              Text(
                'Lưu ý an toàn: Mã nguồn Dart của Lab đã được viết đầy đủ & sẵn sàng biên dịch thành công.',
                style: TextStyle(
                    color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                // Mock user data phục vụ xem trước giao diện profile
                _currentUser = FirebaseAuth.instance.currentUser;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Đang hiển thị chế độ giả lập giao diện Profile')),
              );
            },
            child: const Text('Xem giao diện Demo'),
          ),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đã hiểu')),
        ],
      ),
    );
  }

  /// Hiển thị Dialog thông báo lỗi hệ thống
  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thông Báo Hệ Thống'),
        content: Text(msg),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng')),
        ],
      ),
    );
  }

  /// Hàm dựng giao diện chính của GoogleSignInScreen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('10.4 Google Sign In')),
      body: _currentUser != null ||
              (!widget.firebaseInitialized && _currentUser != null)
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: _currentUser?.photoURL != null
                          ? NetworkImage(_currentUser!.photoURL!)
                          : null,
                      child: _currentUser?.photoURL == null
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _currentUser?.displayName ?? 'Người Dùng Thử Nghiệm',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentUser?.email ?? 'test_google@gmail.com',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: _handleGoogleSignOut,
                      icon: const Icon(Icons.logout),
                      label: const Text('Đăng Xuất Google'),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.g_mobiledata,
                        size: 100, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      'Đăng nhập bằng tài khoản Google của bạn',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _handleGoogleSignIn,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        backgroundColor: Colors.red[700],
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.login),
                      label: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Đăng Nhập Với Google'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// -------------------------------------------------------------
// 10.5 LOCAL NOTIFICATION SCREEN
// -------------------------------------------------------------
/// Màn hình cấp quyền thông báo và kích hoạt thủ công Local Notification
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  /// Tạo State quản lý thông báo
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

/// Trạng thái lưu trữ của NotificationScreen
class _NotificationScreenState extends State<NotificationScreen> {
  /// Xin quyền gửi thông báo từ hệ điều hành (Bắt buộc chạy runtime trên Android 13+)
  Future<void> _requestPermissions() async {
    try {
      final bool? granted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(granted == true
                ? 'Đã được cấp quyền thông báo!'
                : 'Quyền thông báo bị từ chối!'),
            backgroundColor: granted == true ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint("Lỗi yêu cầu quyền: $e");
    }
  }

  /// Kích hoạt gửi nhanh một thông báo hệ thống tức thì
  void _triggerManualNotification() {
    showNotification(
      title: 'Thông báo thủ công',
      body: 'Đây là nội dung được kích hoạt bằng nút nhấn của bạn.',
    );
  }

  /// Hàm dựng giao diện chính của NotificationScreen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('10.5 Local Notification')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.notifications_active,
                  size: 72, color: Colors.teal),
              const SizedBox(height: 24),
              const Text(
                'Quản Lý Thông Báo Hệ Thống',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Kích hoạt quyền thông báo trước khi gửi trên Android 13+',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _requestPermissions,
                icon: const Icon(Icons.security),
                label: const Text('Yêu Cầu Quyền Gửi Thông Báo'),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _triggerManualNotification,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Gửi Thông Báo Tức Thì'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// LAB 10 FULL INTEGRATION SCREEN
// -------------------------------------------------------------
/// Màn hình tích hợp toàn bộ luồng Auth, SharedPreferences Session, và Local Notifications
class FullIntegrationScreen extends StatefulWidget {
  final bool firebaseInitialized;

  const FullIntegrationScreen({super.key, required this.firebaseInitialized});

  /// Tạo State quản lý tích hợp luồng
  @override
  State<FullIntegrationScreen> createState() => _FullIntegrationScreenState();
}

/// Trạng thái lưu trữ của FullIntegrationScreen
class _FullIntegrationScreenState extends State<FullIntegrationScreen> {
  bool _isChecking = true;
  String? _currentUserToken;
  String _currentUserName = 'User';
  final _usernameController = TextEditingController(text: 'emilys');
  final _passwordController = TextEditingController(text: 'emilyspassword');
  bool _isLoading = false;

  /// Kích hoạt tự động kiểm tra Session khi tải màn hình
  @override
  void initState() {
    super.initState();
    _checkPersistence();
  }

  /// Giải phóng bộ nhớ của các bộ điều khiển khi widget bị hủy
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Hàm bất đồng bộ kiểm tra SharedPreferences xem đã lưu phiên đăng nhập trước đó chưa
  Future<void> _checkPersistence() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final name = prefs.getString('auth_name') ?? 'User';
    await Future.delayed(
        const Duration(milliseconds: 800)); // Delay tạo hiệu ứng
    if (mounted) {
      setState(() {
        _currentUserToken = token;
        _currentUserName = name;
        _isChecking = false;
      });
    }
  }

  /// Hàm bất đồng bộ gửi yêu cầu POST đăng nhập DummyJSON và lưu phiên làm việc
  Future<void> _loginAPI() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty)
      return;
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'] as String;
        final name = data['firstName'] as String? ?? 'User';

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('auth_name', name);

        // Gửi thông báo hệ thống chào mừng thành công
        await showNotification(
          title: 'Kết nối thành công (Full Integration)',
          body: 'Chào mừng $name! Phiên đăng nhập đã được ghi nhớ.',
        );

        setState(() {
          _currentUserToken = token;
          _currentUserName = name;
        });
      } else {
        _showToast('Đăng nhập API thất bại! Vui lòng kiểm tra tài khoản.');
      }
    } catch (e) {
      _showToast('Lỗi kết nối: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Hàm bất đồng bộ xử lý đăng nhập Google và lưu token phiên làm việc
  Future<void> _loginGoogle() async {
    if (!widget.firebaseInitialized) {
      // Chạy ở chế độ Mock Google Login nếu chưa có cấu hình native
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', 'mock_google_token_123456');
      await prefs.setString('auth_name', 'Google Guest');

      showNotification(
        title: 'Google Login (Mock mode)',
        body:
            'Hệ thống chạy giả lập đăng nhập Google vì thiếu firebase_options.dart.',
      );

      setState(() {
        _currentUserToken = 'mock_google_token_123456';
        _currentUserName = 'Google Guest';
      });
      return;
    }

    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final name = userCredential.user?.displayName ?? 'Google User';
        final token = userCredential.user?.uid ?? 'google_uid';

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('auth_name', name);

        showNotification(
            title: 'Google Login (Full)', body: 'Chào mừng $name!');

        setState(() {
          _currentUserToken = token;
          _currentUserName = name;
        });
      }
    } catch (e) {
      _showToast('Đăng nhập Google thất bại: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  /// Hàm Đăng xuất xóa bỏ toàn bộ Token phiên làm việc và đăng xuất Firebase
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('auth_name');

    if (widget.firebaseInitialized) {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    }

    setState(() {
      _currentUserToken = null;
      _currentUserName = 'User';
    });
  }

  /// Hàm tiện ích hiển thị thông báo SnackBar nhanh, kiểm tra trạng thái mounted an toàn
  void _showToast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  /// Hàm dựng giao diện chính của FullIntegrationScreen (Chuyển đổi linh hoạt giữa Dashboard và login Form)
  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Đang đồng bộ hóa phiên đăng nhập...'),
            ],
          ),
        ),
      );
    }

    if (_currentUserToken != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ứng dụng đã kết nối')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.verified_user, size: 80, color: Colors.indigo),
                const SizedBox(height: 20),
                Text('Xin chào, $_currentUserName!',
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Phiên làm việc của bạn đang hoạt động.',
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[800],
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                  ),
                  icon: const Icon(Icons.exit_to_app),
                  label: const Text('ĐĂNG XUẤT HỆ THỐNG'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập tích hợp')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.security, size: 64, color: Colors.indigo),
              const SizedBox(height: 16),
              const Text('Cổng đăng nhập an toàn',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                    labelText: 'Username (DummyJSON)',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Password', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _loginAPI,
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48)),
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('ĐĂNG NHẬP API'),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('HOẶC')),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: _isLoading ? null : _loginGoogle,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  side: BorderSide(color: Colors.red[700]!),
                  foregroundColor: Colors.red[700],
                ),
                icon: const Icon(Icons.login),
                label: const Text('ĐĂNG NHẬP BẰNG GOOGLE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// DUMMY HOME SCREEN FOR MOCK / REAL LOGIN REDIRECTS
// -------------------------------------------------------------
/// Màn hình giao diện Home giả lập sau khi đăng nhập thành công
class DummyHomeScreen extends StatelessWidget {
  final String title;
  final String userEmail;

  const DummyHomeScreen(
      {super.key, required this.title, required this.userEmail});

  /// Hàm dựng giao diện chính của DummyHomeScreen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: false, // Tắt nút quay lại mặc định
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.home, size: 80, color: Colors.blue),
              const SizedBox(height: 20),
              const Text('Chào mừng đến trang chủ giả lập!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Tài khoản: $userEmail',
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Quay về Menu Lab 10'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
