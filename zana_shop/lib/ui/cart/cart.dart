import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:zana_shop/common/http_client.dart";
import "package:zana_shop/data/repo/cart_repository.dart";
import "package:zana_shop/data/source/cart_data_source.dart";
import "package:zana_shop/theme/light_theme.dart";
import "package:zana_shop/ui/cart/cart_bloc/cart_bloc.dart";
import "package:zana_shop/widgets/empty_state.dart";
import "package:zana_shop/widgets/loading_state.dart";
import "package:zana_shop/widgets/navigation.dart";

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationWidget(),
      appBar: AppBar(title: Text("Your Cart")),
      body: SafeArea(
        child: BlocProvider(
          create: (context) => CartBloc(
            CartRepository(dataSource: CartRemoteDataSource(dio: httpClient)),
          )..add(CartStarted()),
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoading) {
                return LoadingState();
              } else if (state is CartLoaded) {
                if (state.cart.items.isEmpty) {
                  return EmptyState(
                    message: "there are no product in your cart!",
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<CartBloc>()..add(CartStarted());
                  },
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: state.cart.items.length,
                            itemBuilder: (context, index) {
                              final cart = state.cart.items[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 9,
                                ),
                                height: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "http://10.0.2.2:8000" +
                                            cart.product.image,
                                        fit: BoxFit.cover,
                                        height: 100,
                                        width: 80,
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 8),
                                            Text(
                                              "${cart.product.title}",
                                              style: TextStyle(fontSize: 16),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 8),
                                            Text(
                                              "${cart.product.finalPrice} dollor",
                                              style: TextStyle(fontSize: 16),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 120,
                                      height: 40,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppColors.textMain,
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton(
                                            onPressed: () =>
                                                context.read<CartBloc>().add(
                                                  CartItemDecreased(
                                                    cart.product.id,
                                                    "decrease",
                                                  ),
                                                ),
                                            icon: const Icon(
                                              Icons.remove,
                                              size: 16,
                                            ),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(
                                              minWidth: 30,
                                              minHeight: 40,
                                            ),
                                          ),
                                          Text(
                                            "${cart.quantity}",
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () =>
                                                context.read<CartBloc>().add(
                                                  CartItemIncreased(
                                                    cart.product.id,
                                                    "increase",
                                                  ),
                                                ),
                                            icon: const Icon(
                                              Icons.add,
                                              size: 16,
                                            ),
                                            padding: EdgeInsets.zero,
                                            constraints: const BoxConstraints(
                                              minWidth: 30,
                                              minHeight: 40,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } else if (state is CartError) {
                return Center(
                  child: Column(
                    children: [
                      Text("${state.message}"),
                      TextButton(
                        onPressed: () {
                          context.read<CartBloc>()..add(CartStarted());
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
}
