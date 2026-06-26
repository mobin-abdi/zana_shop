import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zana_shop/common/http_client.dart';
import 'package:zana_shop/data/repo/product_repository.dart';
import 'package:zana_shop/data/source/product_data_source.dart';
import 'package:zana_shop/theme/light_theme.dart';
import 'package:zana_shop/ui/products/detail/product_detail.dart';
import 'package:zana_shop/ui/search/search_bloc/search_bloc.dart';
import 'package:zana_shop/widgets/empty_state.dart';
import 'package:zana_shop/widgets/navigation.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(
        ProductRepository(dataSource: ProductRemoteDataSource(dio: httpClient)),
      )..add(LoadPopularProducts()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            bottomNavigationBar: const NavigationWidget(),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // بخش سرچ و فیلتر
                    _buildSearchHeader(context),

                    // لیست نتایج سرچ یا محبوب‌ها
                    BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        if (state is SearchLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is SearchLoaded) {
                          if (state.result.isEmpty) {
                            return const EmptyState(
                              message: "نتیجه‌ای برای جستجوی شما یافت نشد.",
                            );
                          }

                          return _buildProductList(state.result);
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 250,
          height: 49,
          margin: const EdgeInsets.fromLTRB(32, 32, 16, 32),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.textMain.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 32, 32, 32),
          child: SizedBox(
            width: 50,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  context.read<SearchBloc>().add(
                    SearchStarted(_controller.text),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffFAFAFA),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Icon(Icons.search),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductList(List<dynamic> products) {
    if (products.isEmpty) {
      return const EmptyState(message: "there are no product to show");
    }

    return SizedBox(
      height: 250,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 32),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: products.length > 10 ? 10 : products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Padding(
              padding: const EdgeInsets.only(left: 16),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailScreen(productId: product.id),
                    ),
                  );
                },
                child: Container(
                  width: 130,
                  height: 230,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AspectRatio(
                        aspectRatio: 4 / 6,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: product.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          product.title,
                          style: TextStyle(color: AppColors.textMain),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "${product.finalPrice}",
                          style: TextStyle(color: AppColors.textMain),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
