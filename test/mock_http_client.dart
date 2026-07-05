import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

/// Mảng byte đại diện cho 1 ảnh PNG trong suốt kích thước 1x1 pixel.
final Uint8List transparentImage = Uint8List.fromList([
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0A,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82
]);

/// Ghi đè cấu hình HTTP mặc định của hệ thống để chuyển hướng tất cả các yêu cầu HTTP
/// qua MockHttpClient thay vì gửi yêu cầu mạng thực tế.
class MockHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return MockHttpClient();
  }
}

/// Lớp giả lập HttpClient sử dụng cơ chế noSuchMethod để tránh lỗi biên dịch khi giao diện SDK thay đổi.
class MockHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> open(
      String method, String host, int port, String path) {
    return Future.value(MockHttpClientRequest());
  }

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) {
    return Future.value(MockHttpClientRequest());
  }

  @override
  Future<HttpClientRequest> get(String host, int port, String path) =>
      open("get", host, port, path);
  @override
  Future<HttpClientRequest> getUrl(Uri url) => openUrl("get", url);
  @override
  Future<HttpClientRequest> post(String host, int port, String path) =>
      open("post", host, port, path);
  @override
  Future<HttpClientRequest> postUrl(Uri url) => openUrl("post", url);
  @override
  Future<HttpClientRequest> put(String host, int port, String path) =>
      open("put", host, port, path);
  @override
  Future<HttpClientRequest> putUrl(Uri url) => openUrl("put", url);
  @override
  Future<HttpClientRequest> delete(String host, int port, String path) =>
      open("delete", host, port, path);
  @override
  Future<HttpClientRequest> deleteUrl(Uri url) => openUrl("delete", url);
  @override
  Future<HttpClientRequest> head(String host, int port, String path) =>
      open("head", host, port, path);
  @override
  Future<HttpClientRequest> headUrl(Uri url) => openUrl("head", url);
  @override
  Future<HttpClientRequest> patch(String host, int port, String path) =>
      open("patch", host, port, path);
  @override
  Future<HttpClientRequest> patchUrl(Uri url) => openUrl("patch", url);

  @override
  noSuchMethod(Invocation invocation) => null;
}

/// Lớp giả lập HttpClientRequest.
class MockHttpClientRequest implements HttpClientRequest {
  @override
  HttpHeaders get headers => MockHttpHeaders();

  @override
  Future<HttpClientResponse> get done => Future.value(MockHttpClientResponse());

  @override
  Future<HttpClientResponse> close() => Future.value(MockHttpClientResponse());

  @override
  noSuchMethod(Invocation invocation) => null;
}

/// Lớp giả lập HttpHeaders.
class MockHttpHeaders implements HttpHeaders {
  @override
  noSuchMethod(Invocation invocation) => null;
}

/// Lớp giả lập HttpClientResponse trả về ảnh trong suốt 1x1.
class MockHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => 200;

  @override
  int get contentLength => transparentImage.length;

  @override
  HttpHeaders get headers => MockHttpHeaders();

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  bool get isRedirect => false;

  @override
  bool get persistentConnection => true;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable([transparentImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  noSuchMethod(Invocation invocation) => null;
}
