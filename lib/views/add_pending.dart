import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:listahan/database.dart';
import 'package:listahan/main.dart';
import 'package:dropdown_search/dropdown_search.dart';

class AddPending extends HookWidget {
  final GlobalKey<ScaffoldMessengerState> messengerKey;

  const AddPending({
    super.key,
    required this.messengerKey
  });

  final String formName = "name";
  final String formPaid = "paid";

  @override
  Widget build(BuildContext context) {
    final dropDownSearchList = useState<List<Widget>>([]);
    final containerHeight = useState(0.0);
    final containerUpdateListener = useState(true);
    final products = useState<List<Product>>([]);
    var initialContainerHeight = useMemoized(() => 0.0);
    final productNames = useMemoized<List<String>>(() => []);
    final selectedProducts = useMemoized<List<Product>>(() => []);
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>(), []);
    final nameFocusNode = useMemoized(() => FocusNode(), []);

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
      );
    }, []);

    useEffect(() {
      bool shouldUpdate = true;

      if (shouldUpdate) {      
        if (dropDownSearchList.value.isEmpty) dropDownSearchList.value.add(useDropDownSearch);
      }

      return () {
        shouldUpdate = false;
      };
    }, [dropDownSearchList.value, containerHeight.value]);

    return Scaffold(
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
                                  focusNode: nameFocusNode,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Enter the name',
                                  ),
                                  name: formName,
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                  ]),
                                ),
                              ),
                              FormBuilderCheckbox(
                                name: formPaid, 
                                title: const Text(
                                  "Paid", 
                                  style: TextStyle(fontSize: 16),
                                )
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
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.saveAndValidate()) {       
                              var now = DateTime.now();
                              var formatter = DateFormat('yMMMd');
                              String formattedDate = formatter.format(now);

                              dynamic editedPaid = formKey.currentState!.fields[formPaid]?.value;

                              String name = formKey.currentState!.fields[formName]!.value;
                              String date = formattedDate;
                              bool paid = (editedPaid == null || editedPaid == false) ? false : true;

                              LendersCompanion lenderEntry = LendersCompanion(
                                name: drift.Value(name),
                                date: drift.Value(date),
                                paid: drift.Value(paid)
                              );

                              Lender lender = await db!.addLender(lenderEntry);
                              
                              if (selectedProducts.isNotEmpty) {
                                LenderWithProducts entry = LenderWithProducts(lender, selectedProducts);

                                await db!.addLenderWithProducts(entry);

                                selectedProducts.clear();
                              }

                              nameFocusNode.unfocus();
                              formKey.currentState!.reset();

                              messengerKey.currentState!.showSnackBar(
                                const SnackBar(content: Text('Added Successfully!')
                              ));
                            }
                          },
                          child: const Text('Save'),
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
          dropDownSearchList.value.add(useDropDownSearch);
        },
        child: const Icon(Icons.add_box),
      )
    );
  }
}