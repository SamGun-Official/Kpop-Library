import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  static const routeName = '/search';

  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: InputType(),
    );
  }
}

class InputType extends StatefulWidget {
  const InputType({Key? key}) : super(key: key);

  @override
  State<InputType> createState() => _InputTypeState();
}

class _InputTypeState extends State<InputType> {
  final TextEditingController _controller = TextEditingController();

  String keyword = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search", style: TextStyle(fontWeight: FontWeight.bold)),
        titleSpacing: 16.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              child: Row(children: [
                Flexible(
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "IU",
                          labelText: "What do you want to search?",
                        ),
                        onChanged: (String value) {
                          setState(() {
                            keyword = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: ElevatedButton(
                    child: const Text("Search"),
                    onPressed: () {},
                  ),
                ),
              ]),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.black38,
                  ),
                  child: const Center(child: Text("Your search result will appear here!", style: TextStyle(fontWeight: FontWeight.w500))),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
