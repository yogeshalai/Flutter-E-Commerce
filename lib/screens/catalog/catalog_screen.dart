import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';
import '/models/models.dart';
import '/widgets/widgets.dart';

class CatalogScreen extends StatelessWidget {
  static const String routeName = '/catalog';

  static Route route({required Category category}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => CatalogScreen(category: category),
    );
  }

  final Category category;

  const CatalogScreen({
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: category.name),
      bottomNavigationBar: const CustomNavBar(screen: routeName),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SearchBox(category: category),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  );
                }
                if (state is ProductLoaded) {
                  final List<Product> categoryProducts = state.products
                      .where((product) => product.category == category.name)
                      .toList();

                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 16.0,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.15,
                    ),
                    itemCount: categoryProducts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                        child: ProductCard.catalog(
                          product: categoryProducts[index],
                        ),
                      );
                    },
                  );
                } else {
                  return const Text('Something went wrong');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
