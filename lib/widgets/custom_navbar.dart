import 'dart:io';

import 'package:ecommerce_app/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;

import '/widgets/widgets.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';

class CustomNavBar extends StatelessWidget {
  final String screen;
  final Product? product;

  const CustomNavBar({
    Key? key,
    required this.screen,
    this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: Container(
        height: 70,
        child: (screen == '/product')
            ? AddToCartNavBar(product: product!)
            : (screen == '/cart')
                ? const GoToCheckoutNavBar()
                : (screen == '/checkout')
                    ? const OrderNowNavBar()
                    : const HomeNavBar(),
      ),
    );
  }
}

class HomeNavBar extends StatelessWidget {
  const HomeNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.home, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/');
          },
        ),
        IconButton(
          icon: const Icon(Icons.shopping_cart, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/cart');
          },
        ),
        IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        )
      ],
    );
  }
}

class AddToCartNavBar extends StatelessWidget {
  const AddToCartNavBar({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {},
        ),
        BlocBuilder<WishlistBloc, WishlistState>(
          builder: (context, state) {
            if (state is WishlistLoading) {
              return const CircularProgressIndicator();
            }
            if (state is WishlistLoaded) {
              return IconButton(
                icon: const Icon(Icons.favorite, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Added to your Wishlist!'),
                    ),
                  );
                  context
                      .read<WishlistBloc>()
                      .add(AddProductToWishlist(product));
                },
              );
            }
            return const Text('Something went wrong!');
          },
        ),
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return const CircularProgressIndicator();
            }
            if (state is CartLoaded) {
              return ElevatedButton(
                onPressed: () {
                  context.read<CartBloc>().add(AddProduct(product));
                  Navigator.pushNamed(context, '/cart');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  shape: const RoundedRectangleBorder(),
                ),
                child: Text(
                  'ADD TO CART',
                  style: Theme.of(context).textTheme.headline3,
                ),
              );
            }
            return const Text('Something went wrong!');
          },
        ),
      ],
    );
  }
}

class GoToCheckoutNavBar extends StatelessWidget {
  const GoToCheckoutNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/checkout');
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            shape: const RoundedRectangleBorder(),
          ),
          child: Text(
            'GO TO CHECKOUT',
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
      ],
    );
  }
}

class OrderNowNavBar extends StatelessWidget {
  const OrderNowNavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (context, state) {
            if (state is CheckoutLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            if (state is CheckoutLoaded) {
              if (state.checkout.paymentMethod == PaymentMethod.credit_card &&
                  state.checkout.paymentMethodId != null) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                  ),
                  onPressed: () {
                    context.read<PaymentBloc>().add(
                          CreatePaymentIntent(
                            paymentMethodId: state.checkout.paymentMethodId!,
                            amount: state.checkout.total,
                          ),
                        );
                  },
                  child: Text(
                    'Pay with Credit Card',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                );
              }
              if (Platform.isAndroid &&
                  state.checkout.paymentMethod == PaymentMethod.google_pay) {
                return GooglePay(
                  products: state.checkout.cart.products,
                  total: state.checkout.total.toString(),
                );
              }
              if (Platform.isIOS &&
                  state.checkout.paymentMethod == PaymentMethod.apple_pay) {
                return ApplePay(
                  products: state.checkout.cart.products,
                  total: state.checkout.total.toString(),
                );
              } else {
                return ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/payment-selection');
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.white),
                  child: Text(
                    'CHOOSE PAYMENT',
                    style: Theme.of(context).textTheme.headline3,
                  ),
                );
              }
            } else {
              return const Text('Something went wrong');
            }
          },
        ),
      ],
    );
  }
}
