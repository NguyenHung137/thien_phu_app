import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'screens/products_screen.dart';
import 'screens/about_screen.dart';
import 'screens/contact_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Supabase.initialize(
      url: 'https://nmumsfxdgngceclogyuw.supabase.co',
      anonKey: 'sb_publishable_VEzNBjsTIC8VDGP7wMQN8Q_4_LAP43Q',
    );
  } catch (e) {
    debugPrint("Failed to initialize Supabase: $e");
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const ThienPhuApp());
}

class ThienPhuApp extends StatelessWidget {
  const ThienPhuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Máy Thiên Phú',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final GlobalKey<ProductsScreenState> _productsScreenKey = GlobalKey();
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(
        onCategorySelected: (categoryName) {
          setState(() {
            _currentIndex = 1;
          });
          _productsScreenKey.currentState?.selectCategoryByName(categoryName);
        },
      ),
      ProductsScreen(key: _productsScreenKey),
      const AboutScreen(),
      const ContactScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Trang Chủ'),
              _buildNavItem(1, Icons.inventory_2_rounded, 'Sản Phẩm'),
              _buildNavItem(2, Icons.business_rounded, 'Giới Thiệu'),
              _buildNavItem(3, Icons.contact_phone_rounded, 'Liên Hệ'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                key: ValueKey(isSelected),
                color: isSelected ? AppTheme.primaryColor : Colors.grey[500],
                size: 24,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.beVietnamPro(
                fontSize: 10,
                fontWeight:
                    isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? AppTheme.primaryColor : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
