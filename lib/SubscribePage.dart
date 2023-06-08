import 'package:flutter/material.dart';
import 'package:recytrack/HomePage.dart';
import 'package:stripe_payment/stripe_payment.dart';

class SubscribePage extends StatefulWidget {
  static const String routeName = '/subscribePage';

  @override
  _SubscribePageState createState() => _SubscribePageState();
}

class _SubscribePageState extends State<SubscribePage> {
  // final _subscribePage = SubscribePage(SubscribePageState());

  // initialize Stripe payment
  void initState() {
    super.initState();
    StripePayment.setOptions(
        StripeOptions(publishableKey: "your_publishable_key_here"));
  }

  // create payment method and confirm subscription
  Future<void> _createPaymentMethodAndSubscribe() async {
    PaymentMethod paymentMethod = await StripePayment.createPaymentMethod(
      PaymentMethodRequest(
        card: CreditCard(
          // add credit card details here
          number: '4242424242424242',
          expMonth: 08,
          expYear: 22,
          cvc: '123',
        ),
      ),
    );

    // add logic to confirm subscription here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SubscribePage'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Subscribe'),
          onPressed: () {
            _createPaymentMethodAndSubscribe();
          },
        ),
      ),
    );
  }
}
