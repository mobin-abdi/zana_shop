import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zana_shop/common/http_client.dart';
import 'package:zana_shop/data/repo/product_repository.dart';
import 'package:zana_shop/data/source/product_data_source.dart';
import 'package:zana_shop/theme/light_theme.dart';
import 'package:zana_shop/ui/products/detail/product_detail.dart';
import 'package:zana_shop/ui/products/feature/feature_bloc/feature_bloc.dart';
import 'package:zana_shop/widgets/empty_state.dart';

class FeatureProductsScreen extends StatelessWidget {
  const FeatureProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "feature products",
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => FeatureBloc(
            ProductRepository(
              dataSource: ProductRemoteDataSource(dio: httpClient),
            ),
          )..add(FeatureStarted()),
          child: BlocBuilder<FeatureBloc, FeatureState>(
            builder: (context, state) {
              if (state is FeatureLoaded) {
                if (state.allProducts.isEmpty) {
                  return EmptyState(message: "there are no product");
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<FeatureBloc>().add(FeatureStarted());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.49,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: state.allProducts.length,
                      itemBuilder: (context, index) {
                        final products = state.allProducts[index];

                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailScreen(productId: products.id),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AspectRatio(
                                  aspectRatio: 3 / 5,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: products.image,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      errorWidget: (context, url, error) {
                                        return const Icon(
                                          Icons.image_not_supported,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    products.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: AppColors.textMain),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    "${products.finalPrice}",
                                    style: TextStyle(
                                      color: AppColors.textMain,
                                      fontWeight: FontWeight.bold,
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
                );
              }

              if (state is FeatureError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(state.message),

                      TextButton(
                        onPressed: () {
                          context.read<FeatureBloc>().add(FeatureStarted());
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [Text("try again"), Icon(Icons.refresh)],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
