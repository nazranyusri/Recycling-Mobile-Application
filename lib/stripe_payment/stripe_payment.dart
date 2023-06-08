import 'package:flutter/material.dart';
import 'package:recytrack/SubscribePage.dart';
import 'package:stripe_payment/stripe_payment.dart';
// import 'package:stripe_payment/stripe_payment.dart';

class MyCheckoutForm extends StatefulWidget {
  @override
  _MyCheckoutFormState createState() => _MyCheckoutFormState();
}

class _MyCheckoutFormState extends State<MyCheckoutForm> {
  @override
  void initState() {
    super.initState();
    StripePayment.setOptions(
        StripeOptions(publishableKey: "your_publishable_key_here"));
  }

  void _createPaymentMethod() async {
    PaymentMethod paymentMethod = await StripePayment.createPaymentMethod(
      PaymentMethodRequest(
        card: CreditCard(
          number: '4242424242424242',
          expMonth: 08,
          expYear: 22,
          cvc: '123',
        ),
      ),
    );
    // add logic to save payment method here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Pay with card'),
          onPressed: () {
            _createPaymentMethod();
          },
        ),
      ),
    );
  }
}
