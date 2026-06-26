import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:zana_shop/common/http_client.dart';
import 'package:zana_shop/data/repo/banner_repository.dart';
import 'package:zana_shop/data/repo/product_repository.dart';
import 'package:zana_shop/data/source/banner_data_source.dart';
import 'package:zana_shop/data/source/product_data_source.dart';
import 'package:zana_shop/theme/light_theme.dart';
import 'package:zana_shop/ui/home/home_bloc/home_bloc.dart';
import 'package:zana_shop/ui/products/category/category_product.dart';
import 'package:zana_shop/ui/products/feature/feature_products.dart';
import 'package:zana_shop/ui/products/popular/popular.dart';
import 'package:zana_shop/ui/products/recommended/recommended.dart';
import 'package:zana_shop/widgets/appbar.dart';
import 'package:zana_shop/widgets/banner_widget.dart';
import 'package:zana_shop/widgets/error.dart';
import 'package:zana_shop/widgets/loading_state.dart';
import 'package:zana_shop/widgets/navigation.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      bottomNavigationBar: NavigationWidget(),
      appBar: CustomAppBar(
        title: "zana shop",
        leading: IconButton(icon: const Icon(Icons.menu), onPressed: () {}),
        action: IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {},
        ),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => HomeBloc(
            ProductRepository(
              dataSource: ProductRemoteDataSource(dio: httpClient),
            ),
            BannerRepository(
              dataSource: BannerRemoteDataSource(dio: httpClient),
            ),
          )..add(HomeStarted()),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return LoadingState();
              } else if (state is HomeLoaded) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<HomeBloc>().add(HomeStarted());
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            padding: const EdgeInsets.only(right: 32),
                            scrollDirection: Axis.horizontal,
                            itemCount: state.categories.length,
                            itemBuilder: (context, index) {
                              final category = state.categories[index];
                              return Padding(
                                padding: const EdgeInsets.only(left: 32),
                                child: CategoryItem(
                                  icon: Icons.category,
                                  label: category.name,
                                  categoryId: category.id,
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 32),
                        if (state.banners.isNotEmpty)
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              SizedBox(
                                height: 200,
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: state.banners.length,
                                  itemBuilder: (context, index) {
                                    final banner = state.banners[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: BannerWidget(
                                        banner: banner,
                                        aspectRatio: 16 / 9,
                                        onTap: () async {
                                          final Uri uri = Uri.parse(banner.url);
                                          if (await canLaunchUrl(uri)) {
                                            await launchUrl(
                                              uri,
                                              mode: LaunchMode.platformDefault,
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "fialed to open link",
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: SmoothPageIndicator(
                                  controller: _pageController,
                                  count: state.banners.length,
                                  axisDirection: Axis.horizontal,
                                  effect: SlideEffect(
                                    spacing: 8.0,
                                    radius: 4.0,
                                    dotWidth: 24.0,
                                    dotHeight: 16.0,
                                    paintStyle: PaintingStyle.stroke,
                                    strokeWidth: 1.5,
                                    dotColor: AppColors.dotInactive,
                                    activeDotColor: AppColors.background,
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          const SizedBox(height: 0),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.only(right: 32, left: 32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Feature Products",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FeatureProductsScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Show all",
                                  style: TextStyle(color: AppColors.accent),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 250,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 32),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: state.featureProducts.length > 10
                                  ? 10
                                  : state.featureProducts.length,
                              itemBuilder: (context, index) {
                                final products = state.featureProducts[index];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Container(
                                    width: 130,
                                    height: 230,
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 4 / 6,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: CachedNetworkImage(
                                              height: 150,
                                              imageUrl: products.image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                          ),
                                          child: Text(
                                            products.title,
                                            style: TextStyle(
                                              color: AppColors.textMain,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8,
                                          ),
                                          child: Text(
                                            "${products.finalPrice}",
                                            style: TextStyle(
                                              color: AppColors.textMain,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.only(left: 32, right: 32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Recommended",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => RecommendedScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "show all",
                                  style: TextStyle(color: AppColors.accent),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 66,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 32),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: state.recommndedProducts.length > 10
                                  ? 10
                                  : state.recommndedProducts.length,
                              itemBuilder: (context, index) {
                                final products =
                                    state.recommndedProducts[index];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Container(
                                    width: 213,
                                    height: 66,
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.darkGrey.withOpacity(
                                            0.1,
                                          ),
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 1,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: SizedBox(
                                              width: 66,
                                              height: 66,
                                              child: CachedNetworkImage(
                                                imageUrl: products.image,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              products.title,
                                              style: TextStyle(
                                                color: AppColors.textMain,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "${products.finalPrice}",
                                              style: TextStyle(
                                                color: AppColors.textMain,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Padding(
                          padding: const EdgeInsets.only(left: 32, right: 32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Popular",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PopularScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "show all",
                                  style: TextStyle(color: AppColors.accent),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 66,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16, right: 32),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: state.popularProducts.length > 10
                                  ? 10
                                  : state.popularProducts.length,
                              itemBuilder: (context, index) {
                                final popularProduct =
                                    state.popularProducts[index];
                                return Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Container(
                                    width: 213,
                                    height: 66,
                                    decoration: BoxDecoration(
                                      color: AppColors.background,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.darkGrey.withOpacity(
                                            0.1,
                                          ),
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 1,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: SizedBox(
                                              width: 66,
                                              height: 66,
                                              child: CachedNetworkImage(
                                                imageUrl: popularProduct.image,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              popularProduct.title,
                                              style: TextStyle(
                                                color: AppColors.textMain,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              "${popularProduct.finalPrice}",
                                              style: TextStyle(
                                                color: AppColors.textMain,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                );
              } else if (state is HomeError) {
                return ErrorMessage(
                  message: state.message,
                  onPressed: () {
                    context.read<HomeBloc>().add(HomeStarted());
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int categoryId;

  const CategoryItem({
    super.key,
    required this.icon,
    required this.label,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryProductsScreen(
              categoryId: categoryId,
              categoryName: label,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Icon(icon, color: AppColors.darkGrey),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textMain),
          ),
        ],
      ),
    );
  }
}
