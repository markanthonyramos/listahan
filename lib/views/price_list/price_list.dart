import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:listahan/database.dart';
import 'package:listahan/main.dart';
import 'package:listahan/views/price_list/edit_product.dart';
import 'package:listahan/search_bar.dart';

enum SampleItem { edit, delete }

class PriceList extends HookWidget {
  const PriceList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final products = useState<List<Product>>([]);
    final searchQuery = useState("");
    final searchProduct = useCallback((String search) async {
      searchQuery.value = search;
      products.value = await db!.getProductThatContains(search);
    }, []);

    useEffect(() {
      bool shouldUpdate = true;

      fetchData() async {
        if (shouldUpdate) {
          if (searchQuery.value.isNotEmpty) {  
            return products.value = await db!.getProductThatContains(searchQuery.value);
          }

          if (searchQuery.value.isEmpty) {
            List<Product> query = await db!.getAllProducts();

            products.value = query;
          }
        }
      }

      fetchData();

      return () {
        shouldUpdate = false;
      };
    }, [products.value, searchQuery.value]);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(6),
          child: SearchBar(
            onSearch: (val) {
              searchProduct(val);
            },
            onSubmit: (val) {
              searchProduct(val);
            },
          )
        ),
        Expanded(
          child: ListView.builder(
            itemCount: products.value.length,
            prototypeItem: const ListTile(
              trailing: Icon(Icons.menu),
              title: Text("P1000"),
              subtitle: Text("Name - Mar 10, 2023"),
            ),
            itemBuilder: (context, index) {
              final product = products.value[index];

                return Padding(
                  padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: ListTile(
                      visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
                      title: Text(product.name),
                      subtitle: Text("P${product.amount} - ${product.quantity} pc(s)", style: const TextStyle(color: Colors.black)),
                      trailing: PopupMenuButton(
                        onSelected: (SampleItem item) async {
                          switch(item) { 
                            case SampleItem.edit: { 
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EditProduct(product: product, messengerKey: messengerKey,)),
                              );
                            } 
                            break; 
                            
                            case SampleItem.delete: { 
                              await db!.deleteProduct(product.id);
                            } 
                            break; 
                          }
                        },
                        icon: const Icon(Icons.menu, color: Colors.black),
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<SampleItem>>[
                          PopupMenuItem<SampleItem>(
                            value: SampleItem.edit,
                            child: Row(children: const [
                              Icon(Icons.edit),
                              Padding(padding: EdgeInsets.all(4)),
                              Text("Edit"),
                            ]),
                          ),
                          PopupMenuItem<SampleItem>(
                            value: SampleItem.delete,
                            child: Row(children: const [
                              Icon(Icons.delete),
                              Padding(padding: EdgeInsets.all(4)),
                              Text("Delete"),
                            ]),
                          ),
                        ],
                      ),
                    )
                  )
                );
            }
          )
        )
      ]
    );
  }
}