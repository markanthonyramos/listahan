import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:listahan/database.dart';
import 'package:listahan/views/add_pending.dart';
import 'package:listahan/views/paid_view.dart';
import 'package:listahan/views/pending_view.dart';
import 'package:listahan/views/price_list/add_product.dart';
import 'package:listahan/views/price_list/price_list.dart';
import 'create_material_color.dart';

MyDatabase? db;
GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  db = MyDatabase();

  runApp(const MainApp());
}

double orientHeightWidth(BuildContext context, int heightDivider, int widthDivider) {
  switch (MediaQuery.of(context).orientation) {
    case Orientation.portrait:
      return MediaQuery.of(context).size.height / heightDivider;
    case Orientation.landscape:
      return MediaQuery.of(context).size.width / widthDivider;
  }
}

class MainApp extends HookWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final viewIndex = useState(0);

    List<Widget> viewListWidget = useMemoized(() {
      return [
        const PendingView(),
        const PaidView(),
        const PriceList(),
        AddPending(messengerKey: messengerKey)
      ];
    }, []);

    final onItemTapped = useCallback((int index) {
      viewIndex.value = index;
    }, []);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: createMaterialColor(const Color(0xFF008080)),
        scaffoldBackgroundColor: const Color(0xFFEEEEEE)
      ),
      scaffoldMessengerKey: messengerKey,
      home: Builder(builder: (context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Overview", style: TextStyle(color: Colors.black)),
        ),
        body: viewListWidget.elementAt(viewIndex.value),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance),
              label: 'Pending',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              label: 'Paid',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Price List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add Pending',
            ),
          ],
          currentIndex: viewIndex.value,
          onTap: onItemTapped,
        ),
        floatingActionButton: (viewIndex.value == 2) ? FloatingActionButton(
          onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddProduct(messengerKey: messengerKey)),
            );
          },
          child: const Icon(Icons.add),
        ) : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
      ))
    );
  }
}
