import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '/blocs/blocs.dart';
import '/widgets/widgets.dart';

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => CartScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cart'),
      bottomNavigationBar: const CustomNavBar(screen: routeName),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
          if (state is CartLoaded) {
            Map cart = state.cart.productQuantity(state.cart.products);

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.cart.freeDeliveryString,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/');
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black,
                          shape: const RoundedRectangleBorder(),
                          elevation: 0,
                        ),
                        child: Text(
                          'Add More Items',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 400,
                    child: ListView.builder(
                      itemCount: cart.keys.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ProductCard.cart(
                          product: cart.keys.elementAt(index),
                          quantity: cart.values.elementAt(index),
                        );
                      },
                    ),
                  ),
                  OrderSummary(cart: state.cart),
                ],
              ),
            );
          }
          return const Text('Something went wrong');
        },
      ),
    );
  }
}
