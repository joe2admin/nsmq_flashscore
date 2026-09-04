class NewsArticle {
  final String id;
  final String title;
  final String summary;
  final String timeAgo;
  final String category;
  final String readTime;
  final bool isFeatured;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.timeAgo,
    required this.category,
    this.readTime = '3 min read',
    this.isFeatured = false,
  });
}
