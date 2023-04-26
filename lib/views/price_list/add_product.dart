import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:listahan/database.dart';
import 'package:listahan/main.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;
import 'package:flutter_spinbox/material.dart';

class AddProduct extends HookWidget {
  final GlobalKey<ScaffoldMessengerState> messengerKey;

  const AddProduct({
    super.key,
    required this.messengerKey
  });

  final String formName = "name";
  final String formAmount = "amount";
  final String formQuantity = "quantity";

  @override
  Widget build(BuildContext context) {
    final quantity = useState(1);
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>(), []);
    final nameFocusNode = useMemoized(() => FocusNode(), []);

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: FormBuilder(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormBuilderTextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter the amount',
                  ),
                  name: formAmount,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                  ]),
                ),
                const Padding(
                  padding: EdgeInsets.all(10)
                ),
                SpinBox(
                  min: 1,
                  value: 1,
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
                const Padding(
                  padding: EdgeInsets.all(10)
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.saveAndValidate()) {   
                      String name = toBeginningOfSentenceCase(formKey.currentState!.fields[formName]!.value)!;
                      String amount = formKey.currentState!.fields[formAmount]!.value;

                      ProductsCompanion product = ProductsCompanion(
                        name: drift.Value(name),
                        amount: drift.Value(amount),
                        quantity: drift.Value(quantity.value.toString())
                      );

                      await db!.addProduct(product);

                      nameFocusNode.unfocus();
                      formKey.currentState!.reset();

                      messengerKey.currentState!.showSnackBar(
                        SnackBar(content: Text('The product $name was added successfully!')
                      ));

                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        )
      )
  );
  }
}