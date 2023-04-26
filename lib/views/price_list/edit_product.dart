import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:listahan/database.dart';
import 'package:listahan/main.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:flutter_spinbox/material.dart';

class EditProduct extends HookWidget {
  final Product product;
  final GlobalKey<ScaffoldMessengerState> messengerKey;

  const EditProduct({
    super.key,
    required this.product,
    required this.messengerKey
  });

  final String formName = "name";
  final String formAmount = "amount";
  final String formQuantity = "quantity";

  @override
  Widget build(BuildContext context) {
    final quantity = useState(1);
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>(), []);
    FocusNode nameFocusNode = useMemoized(() => FocusNode(), []);

    useEffect(() {
      bool shouldUpdate = true;

      fetchData() async {
        if (shouldUpdate) {
          await Future.delayed(const Duration(microseconds: 1));

          formKey.currentState!.patchValue({
            formName: product.name,
            formAmount: product.amount,
            formQuantity: product.quantity
          });
        }
      }

      fetchData();

      return () {
        shouldUpdate = false;
      };
    }, []);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("Edit Product"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            child: FormBuilder(
              key: formKey,
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 20, 14, 14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 6),
                            child: FormBuilderTextField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter the amount',
                              ),
                              name: formAmount,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                              ]),
                            )
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10)
                          ),
                          SpinBox(
                            min: 1,
                            value: double.parse(product.quantity),
                            onChanged: (value) => quantity.value = value.toInt(),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(10)
                          ),
                          FormBuilderTextField(
                            focusNode: nameFocusNode,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter the name of product',
                            ),
                            name: formName,
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                        ]
                      )
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10)
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.saveAndValidate()) {   
                          String name = toBeginningOfSentenceCase(formKey.currentState!.fields[formName]!.value)!;
                          String amount = formKey.currentState!.fields[formAmount]!.value;

                          Product newProduct = Product(
                            id: product.id,
                            name: name,
                            amount: amount,
                            quantity: quantity.value.toString()
                          );

                          await db!.updateProduct(newProduct);

                          nameFocusNode.unfocus();
                          formKey.currentState!.reset();

                          messengerKey.currentState!.showSnackBar(
                            SnackBar(content: Text('The product $name was edited successfully!')
                          ));

                          if (context.mounted) Navigator.pop(context);
                        }
                      },
                      child: const Text('Edit'),
                    ),
                  ],
                ),
              ),
            )
          )
        )
      )
    );
  }
}