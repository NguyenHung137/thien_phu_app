import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../widgets/product_category_card.dart';
import '../widgets/feature_card.dart';
import '../widgets/stat_counter.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) onCategorySelected;
  const HomeScreen({super.key, required this.onCategorySelected});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBanner = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  final List<Map<String, String>> _banners = [
    {
      'url': 'https://congnghemaythienphu.com/wp-content/uploads/2026/04/home-baner-01.webp',
      'title': 'Dây Chuyền Sản Xuất\nHiện Đại',
      'subtitle': 'Tự động hóa – Tối ưu – Hiệu quả',
    },
    {
      'url': 'https://congnghemaythienphu.com/wp-content/uploads/2026/04/home-baner-02.webp',
      'title': 'Máy Đóng Gói\nChuyên Nghiệp',
      'subtitle': 'Giải pháp đóng gói toàn diện',
    },
    {
      'url': 'https://congnghemaythienphu.com/wp-content/uploads/2026/04/home-baner-03.webp',
      'title': 'Máy Chiết Rót\nChính Xác',
      'subtitle': 'Đảm bảo chất lượng sản phẩm',
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {
      'icon': Icons.precision_manufacturing_rounded,
      'title': 'Dây Chuyền\nSản Xuất',
      'url': 'https://congnghemaythienphu.com/day-chuyen-san-xuat/',
      'color': const Color(0xFF446084),
    },
    {
      'icon': Icons.inventory_2_rounded,
      'title': 'Máy\nĐóng Gói',
      'url': 'https://congnghemaythienphu.com/may-dong-goi/',
      'color': const Color(0xFFC05530),
    },
    {
      'icon': Icons.local_drink_rounded,
      'title': 'Máy\nChiết Rót',
      'url': 'https://congnghemaythienphu.com/may-chiet-rot/',
      'color': const Color(0xFF627D47),
    },
    {
      'icon': Icons.restaurant_rounded,
      'title': 'Máy Thực\nPhẩm',
      'url': 'https://congnghemaythienphu.com/may-che-bien-thuc-pham/',
      'color': const Color(0xFF9B51E0),
    },
    {
      'icon': Icons.medication_rounded,
      'title': 'Máy Ngành\nDược',
      'url': 'https://congnghemaythienphu.com/may-nganh-duoc/',
      'color': const Color(0xFF1A7A7A),
    },
    {
      'icon': Icons.kitchen_rounded,
      'title': 'Tủ Đông\nTrưng Bày',
      'url': 'https://congnghemaythienphu.com/tu-dong-tu-trung-bay/',
      'color': const Color(0xFF2E7D32),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildHeroBanner(),
                _buildCategorySection(),
                _buildStatsSection(),
                _buildFeaturesSection(),
                _buildNewsSection(),
                _buildCallToAction(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      backgroundColor: AppTheme.primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.precision_manufacturing, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'THIÊN PHÚ',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                'Công Nghệ Chế Tạo Máy',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 10,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, color: Colors.white),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHeroBanner() {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: 240,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            onPageChanged: (index, reason) {
              setState(() => _currentBanner = index);
            },
          ),
          items: _banners.asMap().entries.map((entry) {
            return _buildBannerItem(entry.value);
          }).toList(),
        ),
        const SizedBox(height: 12),
        AnimatedSmoothIndicator(
          activeIndex: _currentBanner,
          count: _banners.length,
          effect: ExpandingDotsEffect(
            dotColor: Colors.grey[300]!,
            activeDotColor: AppTheme.primaryColor,
            dotHeight: 6,
            dotWidth: 6,
            expansionFactor: 3,
          ),
          onDotClicked: (index) {
            _carouselController.animateToPage(index);
          },
        ),
      ],
    );
  }

  Widget _buildBannerItem(Map<String, String> banner) {
    return Stack(
      children: [
        // Image
        Positioned.fill(
          child: Image.network(
            banner['url']!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
            ),
          ),
        ),
        // Gradient overlay
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
          ),
        ),
        // Text content
        Positioned(
          bottom: 24,
          left: 20,
          right: 20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                banner['title']!,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                banner['subtitle']!,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Danh Mục Sản Phẩm', 'Khám phá các dòng máy chuyên dụng'),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              return ProductCategoryCard(
                icon: _categories[index]['icon'] as IconData,
                title: _categories[index]['title'] as String,
                color: _categories[index]['color'] as Color,
                delay: index * 100,
                onTap: () {
                  widget.onCategorySelected(_categories[index]['title'] as String);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A5F), Color(0xFF446084)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Con Số Ấn Tượng',
            style: GoogleFonts.beVietnamPro(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              StatCounter(value: '5+', label: 'Năm\nKinh Nghiệm'),
              StatCounter(value: '1000+', label: 'Khách Hàng\nTin Tưởng'),
              StatCounter(value: '500+', label: 'Sản Phẩm\nCung Cấp'),
              StatCounter(value: '50+', label: 'Đối Tác\nTrên Toàn Quốc'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          _buildSectionTitle('Tại Sao Chọn Thiên Phú?', 'Cam kết chất lượng – Uy tín hàng đầu'),
          const SizedBox(height: 16),
          FeatureCard(
            icon: Icons.verified_rounded,
            iconColor: AppTheme.primaryColor,
            title: 'Sản Phẩm Chính Hãng',
            description: 'Nhập khẩu và phân phối chính hãng các dòng máy móc công nghiệp cao cấp từ các thương hiệu uy tín',
            delay: 0,
          ),
          const SizedBox(height: 12),
          FeatureCard(
            icon: Icons.support_agent_rounded,
            iconColor: AppTheme.secondaryColor,
            title: 'Hỗ Trợ 24/7',
            description: 'Đội ngũ kỹ thuật viên chuyên nghiệp luôn sẵn sàng hỗ trợ và giải đáp mọi thắc mắc của quý khách',
            delay: 100,
          ),
          const SizedBox(height: 12),
          FeatureCard(
            icon: Icons.local_shipping_rounded,
            iconColor: AppTheme.accentColor,
            title: 'Giao Hàng Toàn Quốc',
            description: 'Dịch vụ giao hàng và lắp đặt tận nơi trên toàn quốc, đảm bảo máy móc vận hành đúng chuẩn',
            delay: 200,
          ),
          const SizedBox(height: 12),
          FeatureCard(
            icon: Icons.build_circle_rounded,
            iconColor: const Color(0xFF9B51E0),
            title: 'Bảo Hành Chính Sách Tốt',
            description: 'Chính sách bảo hành dài hạn với đội ngũ kỹ thuật viên lành nghề, đảm bảo thiết bị hoạt động ổn định',
            delay: 300,
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      bool launched = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(url);
      }
    } catch (e) {
      debugPrint("Error launching $urlString: $e");
      try {
        await launchUrl(url);
      } catch (innerE) {
        debugPrint("Fallback failed for $urlString: $innerE");
      }
    }
  }

  Widget _buildNewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Tin Tức & Kiến Thức', 'Cập nhật thông tin mới nhất'),
          const SizedBox(height: 16),
          _buildNewsCard(
            'Thiên Phú - Đơn vị tiên phong cung cấp dây chuyền máy móc tự động hóa',
            'Báo Pháp Luật TP.HCM giới thiệu về vị thế tiên phong của Công ty Chế tạo Máy Thiên Phú trong lĩnh vực tự động hóa...',
            'https://congnghemaythienphu.com/wp-content/uploads/2023/08/cong-ty-scaled.jpg',
            'https://plo.vn/thien-phu-don-vi-tien-phong-trong-linh-vuc-cung-cap-day-chuyen-san-xuat-va-may-dong-goi-tai-viet-nam-post790627.html',
          ),
          const SizedBox(height: 12),
          _buildNewsCard(
            'Công ty Chế tạo máy Thiên Phú - Đối tác tin cậy của nhiều doanh nghiệp',
            'Trang tin 24h.com.vn khẳng định uy tín và năng lực chế tạo máy công nghiệp, dây chuyền sản xuất của Thiên Phú...',
            'https://congnghemaythienphu.com/wp-content/uploads/2023/08/cong-ty-scaled.jpg',
            'https://www.24h.com.vn/doanh-nghiep/cong-ty-che-tao-may-thien-phu-doi-tac-tin-cay-cua-nhieu-doanh-nghiep-c849a1567035.html',
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(String title, String desc, String imageUrl, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.network(
                imageUrl,
                width: 110,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 110,
                  height: 90,
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  child: const Icon(Icons.image, color: AppTheme.primaryColor),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.darkColor,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      desc,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1);
  }

  Widget _buildCallToAction() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFC05530), Color(0xFFE67E22)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondaryColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Tư Vấn Miễn Phí!',
            style: GoogleFonts.beVietnamPro(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Liên hệ ngay để được tư vấn giải pháp máy móc phù hợp nhất cho doanh nghiệp của bạn',
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              color: Colors.white.withOpacity(0.9),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone_rounded, size: 18),
                  label: Text(
                    'Gọi Ngay',
                    style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.secondaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_rounded, size: 18),
                  label: Text(
                    'Chat Zalo',
                    style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w700),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.beVietnamPro(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppTheme.darkColor,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              width: 30,
              height: 3,
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                subtitle,
                style: GoogleFonts.beVietnamPro(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
