import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:listahan/database.dart';
import 'package:listahan/main.dart';
import 'package:dropdown_search/dropdown_search.dart';

class EditLender extends HookWidget {
  final LenderWithProducts lenderWithProducts;
  final GlobalKey<ScaffoldMessengerState> messengerKey;

  const EditLender({
    super.key,
    required this.lenderWithProducts,
    required this.messengerKey
  });

  final String formName = "name";
  final String formDate = "date";
  final String formPaid = "paid";

  @override
  Widget build(BuildContext context) {
    final dropDownSearchList = useState<List<Widget>>([]);
    final containerHeight = useState(0.0);
    final containerUpdateListener = useState(true);
    final products = useState<List<Product>>([]);
    var initialContainerHeight = useMemoized(() => 0.0);
    final productNames = useMemoized<List<String>>(() => []);
    final selectedProductNames = useMemoized<List<String>>(() => []);
    final selectedProducts = useMemoized<List<Product>>(() => []);
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>(), []);

    final useDropDownSearch = useMemoized(() {
      return DropdownSearch<String>.multiSelection(
        dropdownDecoratorProps: const DropDownDecoratorProps(
          dropdownSearchDecoration: InputDecoration(labelText: "Lended Items"),
        ),
        asyncItems: (String filter) async {
          productNames.clear();
          products.value = await db!.getProductThatContains(filter);

          for (var product in products.value) {
            productNames.add(product.name);
          }

          return productNames;
        },
        onSaved: (List<String>? data) {
          if (data != null) {
            for (var i = 0; i < products.value.length; i++) {
              for (var j = 0; j < data.length; j++) {
                if(products.value[i].name.contains(data[j])) {
                  selectedProducts.add(products.value[i]);
                }
              }
            }
            data.clear();
          }
        },
        popupProps: const PopupPropsMultiSelection.modalBottomSheet(
          showSearchBox: true,
        ),
        selectedItems: selectedProductNames,
      );
    }, []);

    useEffect(() {
      bool shouldUpdate = true;

      fetchData() async {
        if (shouldUpdate) {
          products.value = await db!.getAllProducts();

          for (final p in lenderWithProducts.products) {
            selectedProductNames.add(p.name);
          }

          if (containerHeight.value == 0) containerHeight.value += 120;
          if (dropDownSearchList.value.isEmpty) dropDownSearchList.value.add(useDropDownSearch);

          formKey.currentState!.patchValue({
            formName: lenderWithProducts.lender.name,
            formDate: lenderWithProducts.lender.date,
            formPaid: lenderWithProducts.lender.paid
          });
        }
      }

      fetchData();

      return () {
        shouldUpdate = false;
      };
    }, [dropDownSearchList.value]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("Edit Lender"),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          initialContainerHeight = orientHeightWidth(context, 14, 10);

          return Center(
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
                                height: orientHeightWidth(context, 14, 16),
                                child: FormBuilderTextField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Enter the date',
                                  ),
                                  name: formDate,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(10)
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 6),
                                height: orientHeightWidth(context, 14, 16),
                                child: FormBuilderTextField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Enter your name',
                                  ),
                                  name: formName,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                )
                              ),
                              FormBuilderCheckbox(
                                name: formPaid, 
                                title: const Text(
                                  "Paid", 
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              Container(
                                height: (containerHeight.value == 0) ? initialContainerHeight : containerHeight.value,
                                child: Scrollbar(
                                  child: ListView(
                                    children: <Widget>[
                                      Visibility(visible: false, child: Text("${containerUpdateListener.value}"))
                                      ] + dropDownSearchList.value,
                                  )
                                )
                              )
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(6)
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.saveAndValidate()) {   
                              dynamic editedPaid = formKey.currentState!.fields[formPaid]?.value;

                              String name = formKey.currentState!.fields[formName]!.value;
                              String date = formKey.currentState!.fields[formDate]!.value;
                              bool paid = (editedPaid == null || editedPaid == false) ? false : true;

                              Lender newLender = Lender(
                                id: lenderWithProducts.lender.id,
                                name: name,
                                date: date,
                                paid: paid
                              );

                              await db!.updateLender(newLender);
                              
                              if (selectedProducts.isNotEmpty) {
                                LenderWithProducts entry = LenderWithProducts(newLender, selectedProducts);

                                await db!.updateLenderWithProducts(entry);

                                selectedProducts.clear();
                              }

                              formKey.currentState!.reset();

                              messengerKey.currentState!.showSnackBar(
                                const SnackBar(content: Text('Edited Successfully!')
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
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (containerHeight.value == 0) containerHeight.value = initialContainerHeight;

          if (MediaQuery.of(context).orientation == Orientation.portrait) {
            if (containerHeight.value < 90) {
              containerHeight.value += initialContainerHeight;
            }
          }

          containerUpdateListener.value = !containerUpdateListener.value;

          dropDownSearchList.value.add(
            DropdownSearch<String>.multiSelection(
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(labelText: "Lended Items"),
              ),
              asyncItems: (String filter) async {
                productNames.clear();
                products.value = await db!.getProductThatContains(filter);

                for (var product in products.value) {
                  productNames.add(product.name);
                }

                return productNames;
              },
              onSaved: (List<String>? data) {
                if (data != null) {
                  for (var i = 0; i < products.value.length; i++) {
                    for (var j = 0; j < data.length; j++) {
                      if(products.value[i].name.contains(data[j])) {
                        selectedProducts.add(products.value[i]);
                      }
                    }
                  }
                  data.clear();
                }
              },
              popupProps: const PopupPropsMultiSelection.modalBottomSheet(
                showSearchBox: true,
              ),
            )
          );
        },
        child: const Icon(Icons.add_box),
      )
    );
  }
}