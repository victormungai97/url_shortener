import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:favicon/favicon.dart' as fav;
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart' as provider;

import '../constants.dart';
import '../blocs/bloc.dart';
import '../models/model.dart';

import '../widgets/radio.dart';
import '../widgets/textfield.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({Key? key}) : super(key: key);

  showSnackBar(BuildContext context, {bool isError = false, String? message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError ? Colors.red : Colors.green,
        content: Text(message ?? "No message received"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return provider.Consumer<Links>(
      builder: (context, links, child) {
        return Scaffold(
          body: BlocListener<LinkBloc, LinkState>(
            listener: (context, state) {
              if (state is LinkException) {
                showSnackBar(
                  context,
                  isError: true,
                  message: state.message ?? "Something went wrong",
                );
              }
              if (state is ShortenURLDone) {
                links.add(state.link);

                showSnackBar(context, message: 'URL Shortened Successfully');
              }
              if (state is RetrieveLinkDone) {
                final link = state.link;
                if (StringUtils.isNullOrEmpty(link)) {
                  showSnackBar(
                    context,
                    isError: true,
                    message: "Link not retrieved from alias",
                  );
                  return;
                }
                context.read<LinkBloc>().add(ShortenUrlEvent(link));
              }
            },
            child: Body(links: links.links),
          ),
          bottomSheet: const SizedBox(child: PrimaryBottomSheet(), width: 500),
          backgroundColor: Theme.of(context).canvasColor,
          appBar: AppBar(elevation: 0.0, title: const Text(title)),
        );
      },
    );
  }
}

class PrimaryBottomSheet extends HookWidget {
  const PrimaryBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final focusNode = useFocusNode();
    final option = useState<String?>("shorten");
    final textController = useTextEditingController();

    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: PrimaryTextField(
              value: option.value,
              controller: textController,
              focusNode: focusNode,
            ),
            flex: 2,
          ),
          Expanded(
            child: BlocConsumer<LinkBloc, LinkState>(
              listener: (context, state) {
                if (state is ShortenURLDone) textController.text = "";
              },
              builder: (context, state) {
                if (state is LinkLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  onPressed: () {
                    if (focusNode.hasFocus) focusNode.unfocus();
                    final value = textController.text;
                    context.read<LinkBloc>().add(
                          option.value == "shorten"
                              ? ShortenUrlEvent(value)
                              : RetrieveLinkEvent(value),
                        );
                  },
                  child: const Icon(Icons.send),
                );
              },
            ),
            flex: 1,
          ),
        ],
      ),
      subtitle: PrimaryRadioGroup(
        groupValue: option.value,
        onChanged: (value) => option.value = value,
      ),
    );
  }
}

class Body extends StatelessWidget {
  final List<Link?> links;

  const Body({Key? key, required this.links}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (links.isEmpty) return const Text("No links received");
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (context, index) {
        final link = links[index];
        String url = link?.original ?? "";
        url = !url.startsWith("http") ? 'http://$url' : url;
        return Card(
          child: SizedBox(
            height: 520,
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder<fav.Icon?>(
                    future: fav.Favicon.getBest(url),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return const CircularProgressIndicator();
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            debugPrint("ERROR!!\t${snapshot.error}");
                            return const Text('Error');
                          } else if (snapshot.hasData) {
                            return Image.network(snapshot.data?.url ?? "");
                          } else {
                            return const Placeholder();
                          }
                        default:
                          return const SizedBox.shrink();
                      }
                    },
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(link?.original ?? "Missing"),
                        ),
                        flex: 6,
                      ),
                      Expanded(
                          child: IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () => Share.share(
                          'Check out this shortened link:\n${link?.shortened ?? "Missing"}',
                        ),
                      )),
                    ],
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
        );
      },
      itemCount: links.length,
    );
  }
}
