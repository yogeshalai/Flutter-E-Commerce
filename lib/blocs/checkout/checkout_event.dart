part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class UpdateCheckout extends CheckoutEvent {
  final Checkout checkout;

  const UpdateCheckout(this.checkout);

  @override
  List<Object?> get props => [checkout];
}

class ConfirmCheckout extends CheckoutEvent {
  final bool isPaymentSuccessful;

  const ConfirmCheckout(this.isPaymentSuccessful);

  @override
  List<Object?> get props => [isPaymentSuccessful];
}
