import 'package:flutter/material.dart';
import 'package:listahan/database.dart';

class ViewLender extends StatelessWidget {
  final LenderWithProducts lenderWithProducts;
  final int totalAmountLended;

  const ViewLender({
    super.key,
    required this.lenderWithProducts,
    required this.totalAmountLended
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("View Lender"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "P$totalAmountLended", 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32)
                    )
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Name: ${lenderWithProducts.lender.name} - ${lenderWithProducts.lender.date}", 
                      style: const TextStyle(color: Colors.black, fontSize: 16)
                    )
                  ),
                  const Divider(
                    color: Colors.black
                  ),
                  Expanded(
                    child: Scrollbar(
                      child: ListView.builder(
                        itemExtent: 46,
                        itemCount: lenderWithProducts.products.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: ListTile(
                              visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
                              title: Text("${lenderWithProducts.products[index].quantity} pc(s) - ${lenderWithProducts.products[index].name}"),
                              trailing: Text("P${lenderWithProducts.products[index].amount}", style: const TextStyle(color: Colors.black)),
                            )
                          );
                        },
                      )
                    )
                  )
                ]
              )
            )
          )
        )
      )
    );
  }
}