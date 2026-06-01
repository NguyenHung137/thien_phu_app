import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            backgroundColor: AppTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://congnghemaythienphu.com/wp-content/uploads/2023/08/cong-ty-scaled.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      decoration:
                          const BoxDecoration(gradient: AppTheme.primaryGradient),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Giới Thiệu',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Công Ty CP Công Nghệ Chế Tạo Máy Thiên Phú',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildIntroSection(),
                _buildMissionSection(),
                _buildValuesSection(),
                _buildTeamSection(),
                _buildPartnersSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.business_rounded,
                    color: AppTheme.primaryColor, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Về Chúng Tôi',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.darkColor,
                      ),
                    ),
                    Text(
                      'Thành lập năm 2020',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Công Ty Cổ Phần Công Nghệ Chế Tạo Máy Thiên Phú kính chào quý khách. '
            'Tự hào là đơn vị uy tín trên toàn quốc chuyên nhập khẩu và phân phối các loại máy móc chế biến thực phẩm, '
            'máy đóng gói sản phẩm, máy chiết rót và dây chuyền sản xuất công nghiệp.',
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.7,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Chúng tôi chuyên cung cấp giải pháp tự động hóa và thiết bị chế biến thực phẩm hàng đầu tại Việt Nam, '
            'giúp doanh nghiệp tối ưu hiệu suất, tiết kiệm chi phí và nâng cao chất lượng sản phẩm.',
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.7,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05);
  }

  Widget _buildMissionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildMiniCard(
              Icons.flag_rounded,
              'Sứ Mệnh',
              'Cung cấp giải pháp máy móc tối ưu, giúp doanh nghiệp Việt Nam nâng cao năng suất',
              AppTheme.primaryColor,
              0,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildMiniCard(
              Icons.remove_red_eye_rounded,
              'Tầm Nhìn',
              'Trở thành đối tác tin cậy hàng đầu trong lĩnh vực tự động hóa sản xuất tại Việt Nam',
              AppTheme.secondaryColor,
              100,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCard(
      IconData icon, String title, String desc, Color color, int delay) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.beVietnamPro(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            desc,
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: delay.ms).slideX(begin: delay == 0 ? -0.1 : 0.1);
  }

  Widget _buildValuesSection() {
    final values = [
      {
        'icon': Icons.verified_rounded,
        'title': 'Uy Tín',
        'desc': 'Cam kết chất lượng và uy tín trong mọi giao dịch',
        'color': const Color(0xFF446084),
      },
      {
        'icon': Icons.emoji_objects_rounded,
        'title': 'Sáng Tạo',
        'desc': 'Không ngừng cải tiến và ứng dụng công nghệ mới',
        'color': const Color(0xFFC05530),
      },
      {
        'icon': Icons.handshake_rounded,
        'title': 'Tận Tâm',
        'desc': 'Luôn đặt lợi ích khách hàng lên hàng đầu',
        'color': const Color(0xFF627D47),
      },
      {
        'icon': Icons.speed_rounded,
        'title': 'Hiệu Quả',
        'desc': 'Tối ưu quy trình để mang lại kết quả tốt nhất',
        'color': const Color(0xFF9B51E0),
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Giá Trị Cốt Lõi',
            style: GoogleFonts.beVietnamPro(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.darkColor,
            ),
          ),
          const SizedBox(height: 16),
          ...values.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color:
                              (entry.value['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(entry.value['icon'] as IconData,
                            color: entry.value['color'] as Color, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.value['title'] as String,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.darkColor,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              entry.value['desc'] as String,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: (entry.key * 100).ms).slideX(begin: 0.1),
              )),
        ],
      ),
    );
  }

  Widget _buildTeamSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A5F), Color(0xFF446084)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Đội Ngũ Chuyên Nghiệp',
            style: GoogleFonts.beVietnamPro(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Đội ngũ kỹ thuật viên và nhân viên bán hàng giàu kinh nghiệm, được đào tạo bài bản, '
            'luôn sẵn sàng tư vấn và hỗ trợ quý khách hàng 24/7.',
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              color: Colors.white70,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildTeamStat('30+', 'Nhân Viên'),
              _buildTeamStat('10+', 'Kỹ Thuật Viên'),
              _buildTeamStat('5+', 'Chuyên Gia'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildTeamStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.beVietnamPro(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.beVietnamPro(
            fontSize: 11,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPartnersSection() {
    final certifications = [
      {'icon': Icons.workspace_premium_rounded, 'title': 'Chứng Nhận ISO', 'desc': 'Hệ thống quản lý chất lượng ISO 9001:2015'},
      {'icon': Icons.verified_user_rounded, 'title': 'Đối Tác Chính Hãng', 'desc': 'Được ủy quyền phân phối bởi các hãng uy tín'},
      {'icon': Icons.military_tech_rounded, 'title': 'Giải Thưởng Thương Hiệu', 'desc': 'Top 10 thương hiệu uy tín ngành máy móc'},
    ];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Text(
            'Chứng Nhận & Giải Thưởng',
            style: GoogleFonts.beVietnamPro(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppTheme.darkColor,
            ),
          ),
          const SizedBox(height: 16),
          ...certifications.asMap().entries.map((entry) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(entry.value['icon'] as IconData,
                          color: AppTheme.accentColor, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.value['title'] as String,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.darkColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            entry.value['desc'] as String,
                            style: GoogleFonts.beVietnamPro(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: (entry.key * 100).ms)),
        ],
      ),
    );
  }
}
