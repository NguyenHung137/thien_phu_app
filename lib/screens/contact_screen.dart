import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 0,
            backgroundColor: AppTheme.primaryColor,
            title: Text(
              'Liên Hệ',
              style: GoogleFonts.beVietnamPro(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            flexibleSpace: Container(
              decoration:
                  const BoxDecoration(gradient: AppTheme.primaryGradient),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildContactHeader(),
                _buildContactInfo(),
                _buildWorkingHours(),
                _buildContactForm(),
                _buildSocialSection(),
                _buildMapPlaceholder(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
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
            color: AppTheme.primaryColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.headset_mic_rounded, color: Colors.white, size: 40),
          const SizedBox(height: 12),
          Text(
            'Chúng Tôi Luôn Sẵn Sàng Hỗ Trợ',
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Đội ngũ tư vấn chuyên nghiệp của Thiên Phú luôn sẵn sàng tư vấn miễn phí và giải đáp mọi thắc mắc của quý khách hàng',
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              color: Colors.white70,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildContactInfo() {
    final contacts = [
      {
        'icon': Icons.phone_rounded,
        'title': 'Hotline',
        'value': '1900 633 539',
        'subtitle': '+84 961 233 599',
        'color': AppTheme.secondaryColor,
        'action': 'Gọi Ngay',
      },
      {
        'icon': Icons.email_rounded,
        'title': 'Email',
        'value': 'congnghemaythienphu.jsc@gmail.com',
        'subtitle': 'Phản hồi trong 24h',
        'color': AppTheme.primaryColor,
        'action': 'Gửi Email',
      },
      {
        'icon': Icons.location_on_rounded,
        'title': 'Địa Chỉ',
        'value': 'Số 1/644 Đường 22 Tháng 12',
        'subtitle': 'Kp Hoà Lân 2, P. Thuận Giao, Thuận An, Bình Dương',
        'color': AppTheme.accentColor,
        'action': 'Xem Bản Đồ',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: contacts.asMap().entries.map((entry) {
          final contact = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
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
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        (contact['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(contact['icon'] as IconData,
                      color: contact['color'] as Color, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact['title'] as String,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        contact['value'] as String,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkColor,
                        ),
                      ),
                      if ((contact['subtitle'] as String).isNotEmpty)
                        Text(
                          contact['subtitle'] as String,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: (contact['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    contact['action'] as String,
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: contact['color'] as Color,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: (entry.key * 100).ms).slideX(begin: 0.1);
        }).toList(),
      ),
    );
  }

  Widget _buildWorkingHours() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  color: AppTheme.primaryColor, size: 22),
              const SizedBox(width: 10),
              Text(
                'Giờ Làm Việc',
                style: GoogleFonts.beVietnamPro(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.darkColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildHoursRow('Thứ 2 - Thứ 7', '08:00 - 17:00', true),
          const Divider(height: 16),
          _buildHoursRow('Chủ Nhật', 'Nghỉ', false),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildHoursRow(String day, String time, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          day,
          style: GoogleFonts.beVietnamPro(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.accentColor.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            time,
            style: GoogleFonts.beVietnamPro(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isActive ? AppTheme.accentColor : Colors.grey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactForm() {
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Gửi Yêu Cầu Tư Vấn',
              style: GoogleFonts.beVietnamPro(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppTheme.darkColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Điền thông tin để được tư vấn miễn phí',
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _nameController,
              label: 'Họ & Tên',
              hint: 'Nhập họ tên của bạn',
              icon: Icons.person_outline_rounded,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Vui lòng nhập họ tên' : null,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _phoneController,
              label: 'Số Điện Thoại',
              hint: 'Nhập số điện thoại liên hệ',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Vui lòng nhập số điện thoại' : null,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _emailController,
              label: 'Email (tuỳ chọn)',
              hint: 'Nhập địa chỉ email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _messageController,
              label: 'Nội Dung Cần Tư Vấn',
              hint: 'Mô tả nhu cầu hoặc câu hỏi của bạn...',
              icon: Icons.message_outlined,
              maxLines: 4,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Vui lòng nhập nội dung' : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        'Gửi Yêu Cầu',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: GoogleFonts.beVietnamPro(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor, size: 20),
        labelStyle: GoogleFonts.beVietnamPro(
          fontSize: 13,
          color: Colors.grey[600],
        ),
        hintStyle: GoogleFonts.beVietnamPro(
          fontSize: 13,
          color: Colors.grey[400],
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        filled: true,
        fillColor: AppTheme.lightBg,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }

  Widget _buildSocialSection() {
    final socials = [
      {
        'icon': Icons.facebook_rounded,
        'label': 'Facebook',
        'color': const Color(0xFF1877F2),
        'url': 'https://www.facebook.com/chetaomaythienphu',
      },
      {
        'icon': Icons.play_circle_fill_rounded,
        'label': 'YouTube',
        'color': const Color(0xFFFF0000),
        'url': 'https://www.youtube.com/@chetaomaythienphu',
      },
      {
        'icon': Icons.work_rounded,
        'label': 'LinkedIn',
        'color': const Color(0xFF0A66C2),
        'url': 'https://www.linkedin.com/in/ctythienphu/',
      },
      {
        'icon': Icons.music_note_rounded,
        'label': 'TikTok',
        'color': const Color(0xFF000000),
        'url': 'https://www.tiktok.com/@thienphu.ct',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Theo Dõi Chúng Tôi',
            style: GoogleFonts.beVietnamPro(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppTheme.darkColor,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: socials
                .map((s) => Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                            right: s == socials.last ? 0 : 8),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: (s['color'] as Color).withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: (s['color'] as Color).withOpacity(0.2),
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(s['icon'] as IconData,
                                color: s['color'] as Color, size: 26),
                            const SizedBox(height: 4),
                            Text(
                              s['label'] as String,
                              style: GoogleFonts.beVietnamPro(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.darkColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildMapPlaceholder() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.accentColor.withOpacity(0.1),
          ],
        ),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.map_rounded, size: 48, color: AppTheme.primaryColor),
          const SizedBox(height: 12),
          Text(
            'Số 1/644 Đường 22 Tháng 12',
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.darkColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Kp Hoà Lân 2, P. Thuận Giao, Thuận An, Bình Dương',
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.directions_rounded, size: 16),
            label: Text(
              'Chỉ Đường',
              style: GoogleFonts.beVietnamPro(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 250.ms);
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _isSubmitting = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  'Yêu cầu đã được gửi thành công!',
                  style: GoogleFonts.beVietnamPro(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: AppTheme.accentColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        _nameController.clear();
        _phoneController.clear();
        _emailController.clear();
        _messageController.clear();
      }
    }
  }
}
