import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_theme.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => ProductsScreenState();
}

class ProductsScreenState extends State<ProductsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCategory = 0;
  List<Map<String, dynamic>> _allProducts = [];
  bool _isLoading = true;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _mainCategories = [
    {
      'name': 'Tất Cả',
      'icon': Icons.grid_view_rounded,
      'color': AppTheme.primaryColor,
    },
    {
      'name': 'Dây Chuyền',
      'icon': Icons.alt_route_rounded,
      'color': const Color(0xFF2F80ED),
    },
    {
      'name': 'Đóng Gói',
      'icon': Icons.inventory_2_rounded,
      'color': AppTheme.secondaryColor,
    },
    {
      'name': 'Chiết Rót',
      'icon': Icons.local_drink_rounded,
      'color': const Color(0xFF627D47),
    },
    {
      'name': 'Thực Phẩm',
      'icon': Icons.restaurant_rounded,
      'color': const Color(0xFF9B51E0),
    },
    {
      'name': 'Ngành Dược',
      'icon': Icons.medication_rounded,
      'color': const Color(0xFF1A7A7A),
    },
    {
      'name': 'Tủ Đông - Tủ Mát',
      'icon': Icons.kitchen_rounded,
      'color': const Color(0xFF2D9CDB),
    },
    {
      'name': 'Thanh Trùng',
      'icon': Icons.thermostat_rounded,
      'color': const Color(0xFFEB5757),
    },
    {
      'name': 'Khác',
      'icon': Icons.more_horiz_rounded,
      'color': const Color(0xFF828282),
    },
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    List<Map<String, dynamic>> result = _allProducts;
    
    // Filter by Category
    if (_selectedCategory != 0) {
      final catName = _mainCategories[_selectedCategory]['name'] as String;
      result = result.where((p) {
        final pCat = p['category'] as String;
        if (catName == 'Thanh Trùng') {
          return pCat.contains('Thanh Trùng') || pCat.contains('Tiệt Trùng');
        }
        return pCat == catName;
      }).toList();
    }
    
    // Filter by Search Query
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      result = result.where((p) {
        final name = (p['name'] as String).toLowerCase();
        final desc = (p['desc'] as String).toLowerCase();
        final cat = (p['category'] as String).toLowerCase();
        return name.contains(query) || desc.contains(query) || cat.contains(query);
      }).toList();
    }
    
    return result;
  }

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: _mainCategories.length, vsync: this);
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final response = await Supabase.instance.client
          .from('products')
          .select();
      
      setState(() {
        _allProducts = response.map((item) => Map<String, dynamic>.from(item)).toList();
        _isLoading = false;
      });
      debugPrint("Loaded ${_allProducts.length} products from Supabase online.");
      return;
    } catch (e) {
      debugPrint("Failed to load products from Supabase online, trying fallback: $e");
    }

    try {
      final String response = await rootBundle.loadString('assets/data/products.json');
      final data = await json.decode(response) as List<dynamic>;
      
      setState(() {
        _allProducts = data.map((item) => Map<String, dynamic>.from(item)).toList();
        _isLoading = false;
      });
      debugPrint("Loaded products from offline assets fallback.");
    } catch (e) {
      debugPrint("Error loading products fallback: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void selectCategoryByName(String categoryName) {
    final cleanName = categoryName.replaceAll('\n', ' ').replaceAll('Máy ', '').trim();
    int index = -1;
    for (int i = 0; i < _mainCategories.length; i++) {
      final name = _mainCategories[i]['name'] as String;
      if (name.toLowerCase().contains(cleanName.toLowerCase()) || 
          cleanName.toLowerCase().contains(name.toLowerCase())) {
        index = i;
        break;
      }
    }
    if (index != -1) {
      setState(() {
        _selectedCategory = index;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.67,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 115,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 12, width: 100, color: Colors.white),
                        const SizedBox(height: 6),
                        Container(height: 10, width: 130, color: Colors.white),
                        const SizedBox(height: 4),
                        Container(height: 10, width: 80, color: Colors.white),
                        const Spacer(),
                        Container(height: 25, width: double.infinity, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;
    
    return Scaffold(
      backgroundColor: AppTheme.lightBg,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            expandedHeight: 230,
            backgroundColor: AppTheme.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppTheme.primaryGradient),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: MediaQuery.of(context).padding.top + 16,
                    bottom: 62, // 50 (bottom height) + 12 (spacing)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Sản Phẩm',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value;
                            });
                          },
                          style: GoogleFonts.beVietnamPro(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Tìm kiếm sản phẩm...',
                            hintStyle: GoogleFonts.beVietnamPro(
                              color: Colors.white60,
                              fontSize: 13,
                            ),
                            prefixIcon: const Icon(
                              Icons.search_rounded,
                              color: Colors.white70,
                              size: 18,
                            ),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.clear_rounded,
                                      color: Colors.white70,
                                      size: 16,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = "";
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isLoading 
                            ? 'Đang tải danh sách sản phẩm...' 
                            : _searchQuery.isNotEmpty
                                ? 'Tìm thấy ${filtered.length} kết quả phù hợp'
                                : 'Đã tìm thấy ${_allProducts.length} máy móc chế biến công nghiệp',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Container(
                color: Colors.transparent,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: _mainCategories.asMap().entries.map((entry) {
                      final isSelected = _selectedCategory == entry.key;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedCategory = entry.key);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                entry.value['icon'] as IconData,
                                size: 14,
                                color: isSelected
                                    ? entry.value['color'] as Color
                                    : Colors.white,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                entry.value['name'] as String,
                                style: GoogleFonts.beVietnamPro(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? AppTheme.darkColor
                                      : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: _isLoading
            ? _buildShimmerGrid()
            : filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'Không có sản phẩm nào thuộc mục này.',
                          style: GoogleFonts.beVietnamPro(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.67,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _buildProductCard(filtered[index], index);
                    },
                  ),
      ),
    );
  }


  Widget _buildProductCard(Map<String, dynamic> product, int index) {
    return GestureDetector(
      onTap: () => _showProductDetail(product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: product['image'] as String,
                    height: 115,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 115,
                      color: Colors.grey[100],
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 1.5),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 115,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor.withOpacity(0.1),
                            AppTheme.primaryColor.withOpacity(0.2),
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.precision_manufacturing,
                          size: 48,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
                if (product['tag'] != null)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: product['tagColor'] as Color,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product['tag'] as String,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['name'] as String,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.darkColor,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product['desc'] as String,
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 11,
                        color: Colors.grey[500],
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _showProductDetail(product),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Xem Chi Tiết',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: (index * 80).ms).slideY(begin: 0.1),
    );
  }

  void _showProductDetail(Map<String, dynamic> product) {
    // Gather all images for this product
    final List<String> images = [product['image'] as String];
    if (product['detail_images'] != null) {
      images.addAll(List<String>.from(product['detail_images']));
    }

    final htmlDesc = product['html_desc'] as String? ?? '<p>${product['desc']}</p>';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductImageCarousel(images: images),
                      const SizedBox(height: 20),
                      Text(
                        product['name'] as String,
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.darkColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product['category'] as String,
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Chi Tiết Sản Phẩm',
                        style: GoogleFonts.beVietnamPro(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.darkColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      HtmlWidget(
                        htmlDesc,
                        textStyle: GoogleFonts.beVietnamPro(
                          fontSize: 14,
                          color: Colors.grey[800],
                          height: 1.6,
                        ),
                        customStylesBuilder: (element) {
                          if (element.localName == 'h2') {
                            return {
                              'font-size': '18px',
                              'font-weight': 'bold',
                              'color': '#1A2A3A',
                              'margin-top': '20px',
                              'margin-bottom': '10px'
                            };
                          }
                          if (element.localName == 'h3') {
                            return {
                              'font-size': '16px',
                              'font-weight': 'bold',
                              'color': '#446084',
                              'margin-top': '15px',
                              'margin-bottom': '8px'
                            };
                          }
                          if (element.localName == 'table') {
                            return {
                              'border-collapse': 'collapse',
                              'width': '100%',
                              'margin-top': '16px',
                              'margin-bottom': '16px',
                              'background-color': '#F8F9FA',
                              'border': '1px solid #E2E8F0',
                            };
                          }
                          if (element.localName == 'th') {
                            return {
                              'background-color': '#1A2A3A',
                              'color': '#FFFFFF',
                              'font-weight': '700',
                              'padding': '10px 12px',
                              'text-align': 'left',
                              'font-size': '13px',
                              'border': '1px solid #E2E8F0',
                            };
                          }
                          if (element.localName == 'td') {
                            return {
                              'padding': '10px 12px',
                              'border-bottom': '1px solid #E2E8F0',
                              'border-right': '1px solid #E2E8F0',
                              'font-size': '13px',
                              'color': '#1A2A3A',
                            };
                          }
                          return null;
                        },
                      ),
                      
                      // Specs Table (Native Premium Table)
                      if (product['specs'] != null && 
                          (product['specs'] as Map).isNotEmpty &&
                          !htmlDesc.contains('<table')) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Thông Số Kỹ Thuật',
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.darkColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                          ),
                          child: Column(
                            children: (product['specs'] as Map<String, dynamic>).entries.map((entry) {
                              final isLast = entry.key == (product['specs'] as Map).keys.last;
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey[200]!,
                                      width: isLast ? 0 : 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        entry.key,
                                        style: GoogleFonts.beVietnamPro(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      flex: 6,
                                      child: Text(
                                        entry.value.toString(),
                                        style: GoogleFonts.beVietnamPro(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.darkColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.phone_rounded, size: 18),
                              label: Text(
                                'Gọi Tư Vấn',
                                style: GoogleFonts.beVietnamPro(
                                    fontWeight: FontWeight.w700),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primaryColor,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
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
                              icon: const Icon(Icons.request_quote_rounded,
                                  size: 18),
                              label: Text(
                                'Báo Giá',
                                style: GoogleFonts.beVietnamPro(
                                    fontWeight: FontWeight.w700),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryColor,
                                side: const BorderSide(
                                    color: AppTheme.primaryColor),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductImageCarousel extends StatefulWidget {
  final List<String> images;
  const ProductImageCarousel({super.key, required this.images});

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CarouselSlider(
            carouselController: _controller,
            options: CarouselOptions(
              height: 220,
              viewportFraction: 1.0,
              enlargeCenterPage: false,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: widget.images.map((url) {
              return CachedNetworkImage(
                imageUrl: url,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[100],
                  child: const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[100],
                  child: const Center(
                    child: Icon(Icons.precision_manufacturing, size: 48, color: Colors.grey),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (widget.images.length > 1) ...[
          const SizedBox(height: 10),
          AnimatedSmoothIndicator(
            activeIndex: _currentIndex,
            count: widget.images.length,
            effect: ExpandingDotsEffect(
              dotColor: Colors.grey[300]!,
              activeDotColor: AppTheme.primaryColor,
              dotHeight: 6,
              dotWidth: 6,
              expansionFactor: 3,
            ),
            onDotClicked: (index) {
              _controller.animateToPage(index);
            },
          ),
        ],
      ],
    );
  }
}
