import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:listahan/database.dart';
import 'package:listahan/main.dart';
import 'package:listahan/views/edit_lender.dart';
import 'package:listahan/views/view_lender.dart';

enum SampleItem { edit, delete }

class LendersListView extends HookWidget {
  final AsyncSnapshot<List<LenderWithProducts>>? snapshot;

  const LendersListView({
    super.key,
    this.snapshot
  });

  @override
  Widget build(BuildContext context) {
    return snapshot!.hasData ? 
      ListView.builder(
        itemCount: snapshot!.data!.length,
        prototypeItem: const ListTile(
          trailing: Icon(Icons.menu),
          title: Text("P1000"),
          subtitle: Text("Name - Mar 10, 2023"),
        ),
        itemBuilder: (context, index) {
          int totalAmountLended = 0;

          for (var p in snapshot!.data![index].products) {
            totalAmountLended += int.parse(p.amount);
          }

          return Padding(
            padding: EdgeInsets.fromLTRB(6, (index == 0) ? 6 : 0, 6, 6),
            child:
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: ListTile(
                visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewLender(lenderWithProducts: snapshot!.data![index], totalAmountLended: totalAmountLended)),
                  );
                },
                title: Text("P$totalAmountLended", style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Name: ${snapshot!.data![index].lender.name} - ${snapshot!.data![index].lender.date}", style: const TextStyle(color: Colors.black)),
                minLeadingWidth : 12,
                leading: 
                Container(
                  height: double.infinity,
                  child: Icon(Icons.article, color: Theme.of(context).primaryColor),
                ),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: const <Widget>[
                //     Icon(Icons.article),
                //   ],
                // ),
                trailing: PopupMenuButton(
                  onSelected: (SampleItem item) async {
                    switch(item) { 
                      case SampleItem.edit: { 
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EditLender(lenderWithProducts: snapshot!.data![index], messengerKey: messengerKey,)),
                        );
                      } 
                      break; 
                      
                      case SampleItem.delete: { 
                        await db!.deleteLender(snapshot!.data![index].lender.id);
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
      ) : const Center(
            child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator()
              ),
          );
  }
}