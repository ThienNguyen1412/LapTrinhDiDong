class NewsArticle {
  final String title;
  final String date;
  final String summary;
  final String imageUrl;

  NewsArticle({
    required this.title,
    required this.date,
    required this.summary,
    required this.imageUrl,
  });

  // Dữ liệu mẫu (Static data)
  static List<NewsArticle> getNews() {
    return [
      NewsArticle(
        title: 'Thực phẩm giúp tăng cường miễn dịch mùa cúm',
        date: '05/10/2025',
        summary: 'Các chuyên gia dinh dưỡng khuyên dùng cam, quýt và rau xanh lá để bảo vệ sức khỏe trong thời tiết giao mùa.',
        imageUrl: 'https://picsum.photos/id/200/400/200',
      ),
      NewsArticle(
        title: 'Công nghệ AI trong chẩn đoán sớm ung thư',
        date: '02/10/2025',
        summary: 'Bệnh viện chúng tôi áp dụng thành công công nghệ mới giúp tăng độ chính xác trong phát hiện các tế bào ác tính.',
        imageUrl: 'https://picsum.photos/id/201/400/200',
      ),
      NewsArticle(
        title: 'Lịch tiêm chủng mở rộng cho trẻ em Quý IV',
        date: '28/09/2025',
        summary: 'Thông báo về lịch tiêm phòng các loại vaccine cần thiết. Phụ huynh vui lòng theo dõi và đưa trẻ đi đúng hẹn.',
        imageUrl: 'https://picsum.photos/id/202/400/200',
      ),
      NewsArticle(
        title: 'Tác hại của việc lạm dụng kháng sinh',
        date: '20/09/2025',
        summary: 'Bài viết cảnh báo về tình trạng kháng thuốc và những hậu quả nghiêm trọng đối với sức khỏe cộng đồng.',
        imageUrl: 'https://picsum.photos/id/203/400/200',
      ),
    ];
  }
}