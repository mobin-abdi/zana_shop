import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zana_shop/common/http_client.dart';
import 'package:zana_shop/data/repo/cart_repository.dart';
import 'package:zana_shop/data/repo/product_repository.dart';
import 'package:zana_shop/data/source/cart_data_source.dart';
import 'package:zana_shop/data/source/product_data_source.dart';
import 'package:zana_shop/theme/light_theme.dart';
import 'package:zana_shop/ui/products/detail/product_bloc/product_detail_bloc.dart';
import 'package:zana_shop/widgets/loading_state.dart';

class ProductDetailScreen extends StatelessWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) =>
          ProductDetailBloc(
            ProductRepository(
              dataSource: ProductRemoteDataSource(dio: httpClient),
            ),
            CartRepository(dataSource: CartRemoteDataSource(dio: httpClient)),
          )
            ..add(ProductDetailStarted(productId)),
          child: BlocBuilder<ProductDetailBloc, ProductDetailState>(
            builder: (context, state) {
              if (state is ProductDetailLoading) {
                return LoadingState();
              } else if (state is ProductDetailLoded) {
                return Column(
                  children: [
                    Expanded(
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            expandedHeight: 600,
                            floating: false,
                            pinned: true,
                            flexibleSpace: FlexibleSpaceBar(
                              background: CachedNetworkImage(
                                imageUrl: state.product.image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate([
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 32,
                                  right: 32,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 32),
                                    Text(
                                      "${state.product.title}",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "category: ${state.product.category}",
                                      style: TextStyle(
                                        color: AppColors.dotInactive,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "cost:",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          "${state.product.finalPrice} dollor",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textMain,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 32),
                                    Text(
                                      overflow: TextOverflow.clip,
                                      "description: ${state.product
                                          .description}",
                                      style: TextStyle(
                                        color: AppColors.dotInactive,
                                      ),
                                    ),
                                    SizedBox(height: 32),
                                    SizedBox(
                                      height: 250,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        physics:
                                        AlwaysScrollableScrollPhysics(),
                                        itemCount: state.popular.length > 10
                                            ? 10
                                            : state.popular.length,
                                        itemBuilder: (context, index) {
                                          final popular = state.popular[index];

                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              right: 16,
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProductDetailScreen(
                                                          productId: popular.id,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                width: 130,
                                                height: 230,
                                                decoration: BoxDecoration(
                                                  color: AppColors.background,
                                                  borderRadius:
                                                  BorderRadius.circular(12),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    AspectRatio(
                                                      aspectRatio: 4 / 6,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                        child:
                                                        CachedNetworkImage(
                                                          height: 150,
                                                          imageUrl:
                                                          popular.image,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                        left: 8,
                                                      ),
                                                      child: Text(
                                                        "${popular.title}",
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .textMain,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                        left: 8,
                                                      ),
                                                      child: Text(
                                                        "${popular.finalPrice}",
                                                        style: TextStyle(
                                                          color: AppColors
                                                              .textMain,
                                                        ),
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
                                  ],
                                ),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildBuyButton(context, state)
                  ],
                );
              } else if (state is ProductDetailError) {
                return Center(
                  child: Column(
                    children: [
                      Text("${state.message}"),
                      TextButton(
                        onPressed: () {
                          context.read<ProductDetailBloc>().add(
                            ProductDetailStarted(productId),
                          );
                        },
                        child: const Row(
                          children: [Text("try again"), Icon(Icons.refresh)],
                        ),
                      ),
                    ],
                  ),
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

  Widget _buildBuyButton(BuildContext context, ProductDetailLoded state) {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: const BoxDecoration(
        color: AppColors.textMain,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Center(
        child: TextButton(
          onPressed: () {
            context.read<ProductDetailBloc>().add(
              AddToCartEvent(productId: state.product.id),
            );
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Added to cart!")));
          },
          child: const Text(
            "add to cart",
            style: TextStyle(color: AppColors.background, fontSize: 18),
          ),
        ),
      ),
    );
  }
}