// Lab 7 - Signup Form
//
// Cách chạy Lab 7:
// Thay đổi nội dung file main.dart thành:
//
// import 'package:flutter/material.dart';
// import 'lab7.dart';
// void main() {
//   runApp(const Lab7App());
// }

import 'package:flutter/material.dart';

/// Lớp chính của Lab 7 App kế thừa StatelessWidget
class Lab7App extends StatelessWidget {
  const Lab7App({super.key});

  /// Hàm xây dựng MaterialApp cấu hình theme màu xanh lá của Google (Material 3)
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 7 - Signup Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0F9D58), // Google Green
          brightness: Brightness.light,
        ),
      ),
      home: const SignupFormScreen(),
    );
  }
}

/// Màn hình Form đăng ký tài khoản với các trường thông tin đầy đủ validation và tối ưu UX
class SignupFormScreen extends StatefulWidget {
  const SignupFormScreen({super.key});

  /// Tạo State quản lý dữ liệu nhập, validation và các logic UX
  @override
  State<SignupFormScreen> createState() => _SignupFormScreenState();
}

/// Trạng thái lưu trữ của SignupFormScreen
class _SignupFormScreenState extends State<SignupFormScreen> {
  // Khóa GlobalKey dùng quản lý trạng thái của Form
  final _formKey = GlobalKey<FormState>();

  // Bộ điều khiển Text của các trường nhập dữ liệu
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Các nút tiêu điểm (FocusNode) giúp kiểm soát điều khiển con trỏ bàn phím
  final _nameFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  // Các biến quản lý hiển thị và bảo mật thông tin
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.grey;

  /// Hàm khởi tạo lắng nghe sự thay đổi của mật khẩu để tính toán độ mạnh yếu của nó
  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_checkPasswordStrength);
  }

  /// Giải phóng bộ nhớ của các bộ điều khiển và các FocusNode khi Widget bị huỷ
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  /// Hàm kiểm tra và tính toán độ mạnh yếu của mật khẩu dựa trên 4 tiêu chí phức tạp
  void _checkPasswordStrength() {
    final password = _passwordController.text;
    double strength = 0.0;

    if (password.isEmpty) {
      strength = 0.0;
    } else {
      // 1. Độ dài tối thiểu 8 ký tự
      if (password.length >= 8) strength += 0.25;
      // 2. Chứa ít nhất một chữ viết hoa
      if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25;
      // 3. Chứa ít nhất một chữ số
      if (password.contains(RegExp(r'[0-9]'))) strength += 0.25;
      // 4. Chứa ít nhất một ký tự đặc biệt
      if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25;
    }

    setState(() {
      _passwordStrength = strength;
      if (strength == 0.0) {
        _passwordStrengthText = 'Trống';
        _passwordStrengthColor = Colors.grey;
      } else if (strength <= 0.25) {
        _passwordStrengthText = 'Rất yếu';
        _passwordStrengthColor = Colors.red;
      } else if (strength <= 0.5) {
        _passwordStrengthText = 'Yếu';
        _passwordStrengthColor = Colors.orange;
      } else if (strength <= 0.75) {
        _passwordStrengthText = 'Khá mạnh';
        _passwordStrengthColor = Colors.blue;
      } else {
        _passwordStrengthText = 'Cực kỳ mạnh';
        _passwordStrengthColor = Colors.green;
      }
    });
  }

  /// Hàm xử lý gửi biểu mẫu Form khi người dùng nhấn nút ĐĂNG KÝ
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bạn phải đồng ý với Điều khoản dịch vụ!'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Đăng ký thành công và hiển thị thông báo SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Đăng ký thành công tài khoản cho ${_nameController.text}!'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }
  }

  /// Hàm dựng giao diện chính của SignupFormScreen
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Ẩn bàn phím khi người dùng chạm vào bất kỳ khoảng trống nào ngoài Form
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đăng Ký Tài Khoản'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.account_circle,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Tạo Tài Khoản Mới',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vui lòng điền đầy đủ thông tin bên dưới',
                      style: TextStyle(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Họ và Tên TextFormField
                    TextFormField(
                      controller: _nameController,
                      focusNode: _nameFocus,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_emailFocus),
                      decoration: InputDecoration(
                        labelText: 'Họ và tên',
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập họ và tên';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Email TextFormField
                    TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocus),
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập email';
                        }
                        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value.trim())) {
                          return 'Định dạng email không hợp lệ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Mật khẩu TextFormField
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_confirmPasswordFocus),
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập mật khẩu';
                        }
                        if (value.length < 8) {
                          return 'Mật khẩu phải chứa ít nhất 8 ký tự';
                        }
                        if (!value.contains(RegExp(r'[0-9]'))) {
                          return 'Mật khẩu phải chứa ít nhất 1 chữ số';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),

                    // Chỉ báo độ mạnh yếu của mật khẩu
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Độ mạnh mật khẩu:', style: TextStyle(fontSize: 12)),
                            Text(
                              _passwordStrengthText,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _passwordStrengthColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: _passwordStrength,
                          backgroundColor: Colors.grey[200],
                          color: _passwordStrengthColor,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Xác nhận Mật khẩu TextFormField
                    TextFormField(
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocus,
                      obscureText: _obscureConfirmPassword,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _submitForm(),
                      decoration: InputDecoration(
                        labelText: 'Xác nhận mật khẩu',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng xác nhận lại mật khẩu';
                        }
                        if (value != _passwordController.text) {
                          return 'Mật khẩu xác nhận không trùng khớp';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Checkbox chấp nhận điều khoản dịch vụ
                    CheckboxListTile(
                      value: _agreeToTerms,
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            _agreeToTerms = val;
                          });
                        }
                      },
                      title: const Text(
                        'Tôi đồng ý với các Điều khoản dịch vụ và Chính sách bảo mật',
                        style: TextStyle(fontSize: 13),
                      ),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'ĐĂNG KÝ NGAY',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
