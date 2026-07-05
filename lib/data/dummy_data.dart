import '../models/book.dart';

class DummyData {
  static final List<Book> books = [
    Book(
      id: 'b1',
      title: 'Hành Trình Vào Vô Tận',
      author: 'Giáo sư Stephen Hawking',
      coverUrl:
          'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?q=80&w=600&auto=format&fit=crop',
      rating: 4.9,
      category: 'Science',
      description:
          'Khám phá những bí ẩn sâu thẳm nhất của vũ trụ từ vụ nổ Big Bang cho đến hố đen và tương lai của thời gian. Cuốn sách cung cấp những kiến thức khoa học vũ trụ tiên tiến dưới góc nhìn vô cùng dễ hiểu và lôi cuốn dành cho tất cả mọi người.',
      chapters: [
        Chapter(
          id: 'b1_c1',
          title: 'Chương 1: Tia sáng đầu tiên của Vũ Trụ',
          content:
              'Vũ trụ của chúng ta bắt đầu từ một điểm kỳ dị vô cùng nhỏ, vô cùng nóng và đặc. Khoảng 13.8 tỷ năm trước, một sự kiện vĩ đại được gọi là Big Bang đã diễn ra, khai sinh ra không gian, thời gian và toàn bộ vật chất. Trong những phần triệu giây đầu tiên, vũ trụ giãn nở nhanh hơn cả tốc độ ánh sáng, một thời kỳ được gọi là sự lạm phát vũ trụ. Các hạt cơ bản bắt đầu hình thành, rồi kết hợp lại tạo nên các nguyên tử hydro và heli đầu tiên. Hàng triệu năm sau, trọng lực kéo các đám mây khí khổng lồ này lại với nhau, nén chúng cho đến khi lõi của chúng bắt đầu bùng cháy, tạo ra những ngôi sao đầu tiên chiếu sáng màn đêm vô tận. Đây chính là bình minh của vũ trụ, nơi cuộc hành trình vĩ đại của chúng ta thực sự bắt đầu.',
        ),
        Chapter(
          id: 'b1_c2',
          title: 'Chương 2: Bí ẩn của Hố Đen',
          content:
              'Hố đen là những vật thể kỳ lạ nhất trong vũ trụ. Khi một ngôi sao khổng lồ cạn kiệt nhiên liệu hạt nhân, nó không thể chống lại lực hấp dẫn của chính mình và sụp đổ dưới trọng lượng khổng lồ. Kết quả là một điểm kỳ dị có mật độ vô hạn được sinh ra, bao bọc bởi một ranh giới vô hình gọi là chân trời sự kiện. Không có gì, kể cả ánh sáng, có thể thoát khỏi sức hút của hố đen khi đã bước qua chân trời sự kiện này. Thời gian xung quanh hố đen cũng bị bẻ cong nghiêm trọng: nếu bạn quan sát một phi hành gia rơi vào hố đen từ xa, bạn sẽ thấy họ chuyển động chậm dần và dường như đóng băng vĩnh viễn ở rìa chân trời sự kiện, trong khi đối với chính phi hành gia đó, họ sẽ rơi thẳng vào điểm kỳ dị trong nháy mắt và bị xé toạc bởi lực thủy triều cực đại.',
        ),
        Chapter(
          id: 'b1_c3',
          title: 'Chương 3: Tương lai của loài người',
          content:
              'Liệu Trái Đất có mãi là ngôi nhà duy nhất của chúng ta? Trong hàng tỷ năm tới, Mặt Trời sẽ giãn nở thành một người khổng lồ đỏ và nuốt chửng các hành tinh vòng trong, bao gồm cả Trái Đất. Để tồn tại, nhân loại bắt buộc phải hướng tầm mắt lên bầu trời đêm và tìm kiếm những hành tinh có thể định cư mới trong các hệ sao lân cận. Công nghệ du hành không gian hiện tại vẫn còn sơ khai, nhưng với sự phát triển của động cơ đẩy ion, buồm mặt trời và có thể là công nghệ bẻ cong không gian trong tương lai, chúng ta hoàn toàn có thể chạm tới những thế giới mới. Hành trình này sẽ rất dài và đầy gian nan, đòi hỏi sự đoàn kết và trí tuệ vượt bậc của toàn nhân loại, nhưng đó là con đường duy nhất để ngọn lửa văn minh của chúng ta không bao giờ tắt.',
        ),
      ],
    ),
    Book(
      id: 'b2',
      title: 'Kỷ Nguyên Trí Tuệ Nhân Tạo',
      author: 'TS. Nicholas Thorne',
      coverUrl:
          'https://images.unsplash.com/photo-1507842217343-583bb7270b66?q=80&w=600&auto=format&fit=crop',
      rating: 4.7,
      category: 'Technology',
      description:
          'Tìm hiểu về cuộc cách mạng công nghệ lớn nhất thế kỷ 21: Trí tuệ nhân tạo (AI). Làm thế nào học sâu (Deep Learning) và các mô hình ngôn ngữ lớn đang định hình lại công việc, giáo dục và tương lai xã hội loài người.',
      chapters: [
        Chapter(
          id: 'b2_c1',
          title: 'Chương 1: Sự trỗi dậy của mạng Neural',
          content:
              'Mạng neural nhân tạo được lấy cảm hứng từ cấu trúc sinh học của não bộ con người. Bằng cách kết nối hàng tỷ node xử lý đơn giản (neuron nhân tạo) theo nhiều lớp chồng lên nhau, các nhà khoa học máy tính đã tạo ra những hệ thống có khả năng tự học hỏi từ dữ liệu. Thay vì viết các dòng code hướng dẫn máy tính làm thế nào để nhận biết một con mèo, chúng ta chỉ cần đưa cho mạng neural hàng triệu bức ảnh mèo và không phải mèo. Qua quá trình lan truyền ngược (backpropagation), các trọng số liên kết giữa các neuron tự động điều chỉnh cho đến khi hệ thống đạt độ chính xác cực cao. Kỷ nguyên học sâu chính thức bắt đầu, biến những điều tưởng chừng là khoa học viễn tưởng thành hiện thực hàng ngày.',
        ),
        Chapter(
          id: 'b2_c2',
          title: 'Chương 2: Mô hình ngôn ngữ lớn và Tương tác người - máy',
          content:
              'Sự xuất hiện của kiến trúc Transformer đã tạo nên một bước ngoặt vĩ đại trong việc xử lý ngôn ngữ tự nhiên. Các mô hình ngôn ngữ lớn (LLM) giờ đây không chỉ đơn thuần là đoán từ tiếp theo trong câu, mà chúng đã phát triển khả năng hiểu ngữ cảnh sâu sắc, lập luận logic cơ bản và thậm chí là sáng tạo nghệ thuật. Con người giờ đây có thể giao tiếp với máy tính bằng ngôn ngữ tự nhiên hàng ngày như đang trò chuyện với một người bạn đồng hành thông thái. Điều này mở ra một kỷ nguyên mới của sự cộng tác: AI trở thành trợ lý đắc lực hỗ trợ lập trình, viết lách, dịch thuật và nghiên cứu khoa học, giúp nâng cao năng suất của con người lên gấp nhiều lần.',
        ),
      ],
    ),
    Book(
      id: 'b3',
      title: 'Tư Duy Ngược Trong Kinh Doanh',
      author: 'Marcus Aurelius Black',
      coverUrl:
          'https://images.unsplash.com/photo-1512820790803-83ca734da794?q=80&w=600&auto=format&fit=crop',
      rating: 4.6,
      category: 'Business',
      description:
          'Lối tư duy phá cách giúp phá vỡ các quy tắc kinh doanh truyền thống để tạo nên sự đột phá vượt trội. Cuốn sách dành cho những doanh nhân muốn tìm kiếm đại dương xanh và tạo dựng chỗ đứng vững chắc trên thị trường đầy biến động.',
      chapters: [
        Chapter(
          id: 'b3_c1',
          title: 'Chương 1: Phá vỡ tư duy lối mòn',
          content:
              'Hầu hết các doanh nghiệp thất bại không phải vì họ làm sai công thức, mà vì họ làm quá đúng những công thức cũ kỹ trong một thị trường đã thay đổi. Tư duy ngược bắt đầu bằng việc đặt câu hỏi "Tại sao?". Tại sao chúng ta phải bán sản phẩm theo cách này? Tại sao khách hàng phải tuân theo quy trình phức tạp đó? Khi tất cả đối thủ đều đi theo hướng A, cơ hội thực sự thường nằm ở hướng ngược lại B. Đi ngược đám đông không phải là nổi loạn mù quáng, mà là sự phân tích thấu đáo để tìm ra những nhu cầu chưa được đáp ứng của khách hàng, từ đó định hình lại toàn bộ luật chơi và giành chiến thắng tuyệt đối.',
        ),
        Chapter(
          id: 'b3_c2',
          title: 'Chương 2: Nghệ thuật thất bại nhanh để thành công',
          content:
              'Trong thế giới kinh doanh hiện đại đầy biến động, lập một kế hoạch hoàn hảo 5 năm không còn hiệu quả nữa. Thay vào đó, khả năng thích ứng và phản hồi nhanh chóng mới là chìa khóa sống còn. Doanh nghiệp cần xây dựng văn hóa "thất bại nhanh" (fail fast) - thử nghiệm các ý tưởng mới với chi phí thấp nhất và thời gian ngắn nhất thông qua các sản phẩm khả dụng tối thiểu (MVP). Thất bại không phải là dấu chấm hết, mà là nguồn dữ liệu vô giá giúp bạn tinh chỉnh và định hướng lại sản phẩm của mình trước khi cạn kiệt tài nguyên. Ai học hỏi nhanh nhất từ thất bại, người đó sẽ chiến thắng.',
        ),
      ],
    ),
    Book(
      id: 'b4',
      title: 'Hồ Sơ Thượng Cổ: Lời Nguyền Cổ Đại',
      author: 'Arthur C. Doyle Jr.',
      coverUrl:
          'https://images.unsplash.com/photo-1516979187457-637abb4f9353?q=80&w=600&auto=format&fit=crop',
      rating: 4.8,
      category: 'Fantasy',
      description:
          'Một cuộc phiêu lưu giả tưởng ly kỳ đưa độc giả vào thế giới của ma thuật cổ xưa, các ký tự rune bị lãng quên và một lời nguyền ngàn năm đe dọa hủy diệt vương quốc Eldoria.',
      chapters: [
        Chapter(
          id: 'b4_c1',
          title: 'Chương 1: Ký tự Rune cuối cùng',
          content:
              'Màn đêm buông xuống thung lũng sương mù Eldoria, mang theo cái lạnh thấu xương của mùa đông vĩnh cửu. Trong căn phòng nghiên cứu chật hẹp chứa đầy những cuốn sách da dê cũ kỹ, nhà khảo cổ trẻ Alan đang tỉ mỉ quét lớp bụi thời gian khỏi một phiến đá cổ. Dưới ánh nến bập bùng, những đường rãnh ngoằn ngoèo bắt đầu phát sáng một màu xanh lam huyền ảo. Đó là ký tự Rune của sự hủy diệt, thứ ma thuật được cho là đã biến mất cùng sự sụp đổ của các Thượng cổ thần từ ba ngàn năm trước. Một tiếng thì thầm khẽ vang lên bên tai Alan, thôi thúc anh chạm tay vào phiến đá, mở đầu cho chuỗi sự kiện thay đổi hoàn toàn vận mệnh của thế giới.',
        ),
        Chapter(
          id: 'b4_c2',
          title: 'Chương 2: Cánh cổng bóng tối hé mở',
          content:
              'Khi ngón tay Alan vừa chạm vào phiến đá, mặt đất đột ngột rung chuyển dữ dội. Một luồng ánh sáng tối đen như mực phóng thẳng lên bầu trời, xé toạc các tầng mây và tạo ra một vết nứt không gian khổng lồ. Từ trong vết nứt, những sinh vật bóng đêm gầm rú lao ra, mang theo nỗi sợ hãi tột cùng gieo rắc lên vương quốc. Alan nhận ra mình vừa vô tình phá vỡ phong ấn của Lời nguyền cổ đại. Để sửa chữa sai lầm, anh phải tìm đến Đền thờ ánh sáng nằm sâu trên đỉnh núi tuyết băng giá, nơi cất giữ bảo vật duy nhất có thể khôi phục lại phong ấn trước khi bóng tối nuốt chửng hoàn toàn Eldoria.',
        ),
      ],
    ),
    Book(
      id: 'b5',
      title: 'Mùa Hè Năm Ấy Ta Gặp Nhau',
      author: 'Hạ Vy',
      coverUrl:
          'https://images.unsplash.com/photo-1476275466078-4007374efbbe?q=80&w=600&auto=format&fit=crop',
      rating: 4.5,
      category: 'Romance',
      description:
          'Câu chuyện tình yêu nhẹ nhàng, lãng mạn đầy hoài niệm giữa hai tâm hồn cô đơn tình cờ gặp nhau tại một thị trấn ven biển đầy nắng và gió trong một mùa hè rực rỡ.',
      chapters: [
        Chapter(
          id: 'b5_c1',
          title: 'Chương 1: Thị trấn ven biển đầy nắng',
          content:
              'Tiếng sóng biển rì rào vỗ vào bờ cát vàng như một khúc nhạc êm dịu chào đón Vy đến với thị trấn yên bình sau những tháng ngày mệt mỏi ở thành phố ồn ào. Cô thuê một căn nhà gỗ nhỏ xinh xắn nằm sát biển, nơi mỗi sớm mai chỉ cần mở cửa sổ ra là có thể hít hà hương vị mặn mòi của đại dương và ngắm nhìn ánh bình minh rạng rỡ. Vy tự hứa với bản thân sẽ dành trọn mùa hè này để chữa lành tâm hồn, đọc những cuốn sách yêu thích và vẽ những bức tranh phong cảnh thiên nhiên tuyệt đẹp. Cô không hề biết rằng, chính tại nơi đầy nắng và gió này, định mệnh đã sắp đặt cho cô gặp anh.',
        ),
        Chapter(
          id: 'b5_c2',
          title: 'Chương 2: Tiếng đàn dương cầm dưới cơn mưa',
          content:
              'Cơn mưa mùa hè bất chợt ập xuống thị trấn, Vy vội vã chạy vào trú chân dưới hiên của một quán cà phê sách cổ kính. Từ bên trong quán, những giai điệu dương cầm trầm bổng, da diết vang lên, len lỏi qua tiếng mưa rơi tí tách ngoài hiên. Vy khẽ đẩy cửa bước vào, đập vào mắt cô là hình ảnh một chàng trai trẻ với mái tóc hơi rối đang say sưa lướt ngón tay trên những phím đàn. Ánh sáng vàng ấm áp bao phủ lấy anh, tạo nên một khung cảnh đẹp đến nao lòng. Khi phím đàn cuối cùng ngân vang rồi lịm dần, anh ngước mắt lên nhìn cô và nở một nụ cười ấm áp như nắng mùa hè. Đó là khoảnh khắc thời gian như ngừng trôi đối với cả hai.',
        ),
      ],
    ),
    Book(
      id: 'b6',
      title: 'Vật Lý Thiên Văn Cho Người Bận Rộn',
      author: 'Neil deGrasse Tyson',
      coverUrl:
          'https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=600&auto=format&fit=crop',
      rating: 4.8,
      category: 'Science',
      description:
          'Tóm lược ngắn gọn nhưng đầy súc tích và thú vị về bản chất của không gian, thời gian và vị trí của con người trong vũ trụ rộng lớn bao la.',
      chapters: [
        Chapter(
          id: 'b6_c1',
          title: 'Chương 1: Bản chất của Không Gian và Thời Gian',
          content:
              'Không gian không phải là một khoảng trống rỗng vô vị, và thời gian cũng không trôi qua một cách đồng đều như nhau đối với mọi người. Theo thuyết tương đối rộng của Albert Einstein, không gian và thời gian được đan kết lại với nhau thành một tấm lưới bốn chiều gọi là không-thời gian. Sự hiện diện của vật chất và năng lượng khổng lồ, như các ngôi sao và hành tinh, sẽ bẻ cong tấm lưới này, tạo ra cái mà chúng ta gọi là lực hấp dẫn. Trái Đất quay quanh Mặt Trời không phải vì một lực hút vô hình kéo nó lại, mà vì nó đang di chuyển theo đường thẳng ngắn nhất trên một bề mặt không-thời gian bị Mặt Trời uốn cong dữ dội.',
        ),
      ],
    ),
    Book(
      id: 'b7',
      title: 'Khởi Nghiệp Tinh Gọn',
      author: 'Eric Ries',
      coverUrl:
          'https://images.unsplash.com/photo-1522071820081-009f0129c71c?q=80&w=600&auto=format&fit=crop',
      rating: 4.7,
      category: 'Business',
      description:
          'Phương pháp luận đột phá giúp các công ty khởi nghiệp và các tập đoàn lớn quản trị đổi mới sáng tạo, phát triển sản phẩm nhanh hơn và tránh lãng phí nguồn lực.',
      chapters: [
        Chapter(
          id: 'b7_c1',
          title: 'Chương 1: Định nghĩa về Khởi nghiệp Tinh gọn',
          content:
              'Khởi nghiệp không phải là một canh bạc may rủi, mà là một môn khoa học quản trị đặc biệt áp dụng trong điều kiện cực kỳ không chắc chắn. Một công ty khởi nghiệp là một tổ chức con người được thiết kế để tạo ra sản phẩm hoặc dịch vụ mới dưới những điều kiện mơ hồ nhất. Phương pháp Khởi nghiệp Tinh gọn hướng dẫn chúng ta cách lái một doanh nghiệp thông qua vòng lặp phản hồi cốt lõi: Xây dựng - Đo lường - Học hỏi. Mục tiêu không phải là tạo ra một sản phẩm hoàn mỹ ngay từ đầu, mà là học hỏi nhanh nhất xem khách hàng thực sự muốn gì và sẵn sàng trả tiền cho cái gì.',
        ),
      ],
    ),
    Book(
      id: 'b8',
      title: 'Lập Trình Flutter Toàn Tập',
      author: 'Nguyễn Trần Khánh',
      coverUrl:
          'https://images.unsplash.com/photo-1555066931-4365d14bab8c?q=80&w=600&auto=format&fit=crop',
      rating: 4.9,
      category: 'Technology',
      description:
          'Sách hướng dẫn tự học phát triển ứng dụng đa nền tảng bằng Flutter từ cơ bản đến nâng cao. Tích hợp các dự án thực tế, các kiến thức cốt lõi về Widget, State Management và tối ưu hiệu năng.',
      chapters: [
        Chapter(
          id: 'b8_c1',
          title: 'Chương 1: Tại sao chọn Flutter?',
          content:
              'Flutter là bộ công cụ phát triển phần mềm di động mã nguồn mở do Google phát triển, cho phép lập trình viên xây dựng các ứng dụng biên dịch bản địa (native) tuyệt đẹp cho cả Android, iOS, Web và Desktop chỉ từ một cơ sở mã nguồn (codebase) duy nhất. Khác với các framework lai trước đây sử dụng cầu nối JavaScript chậm chạp, Flutter tự vẽ toàn bộ giao diện của mình thông qua công cụ đồ họa Skia hoặc Impeller hiệu năng cao. Điều này mang lại trải nghiệm mượt mà 60fps hoặc thậm chí 120fps trên các thiết bị cao cấp. Kết hợp với tính năng Hot Reload thay đổi giao diện tức thì trong 1 giây, Flutter đã trở thành lựa chọn hàng đầu của cộng đồng phát triển ứng dụng di động toàn cầu.',
        ),
      ],
    )
  ];
}
