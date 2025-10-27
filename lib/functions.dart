import 'package:flutter/material.dart';
import 'package:homefe/podo/rss/news_item.dart';
import 'package:html/parser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import 'package:flutter/services.dart';

Future<String?> readBaseUrl() async {
  try {
    final api = await rootBundle.loadString('assets/.api');
    return api.trim();
  } catch (e) {
    return null;
  }
}

openItem(BuildContext context, NewsItem item) async {
  bool hasContent = item.content != null;

  if (hasContent) {
    String documentString = parse(item.content).documentElement!.text;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Text('${item.title}\n\n$documentString'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context, true);

                if (await canLaunchUrl(Uri.parse(item.link))) {
                  await launchUrl(Uri.parse(item.link));
                }
              },
              child: const Text('Open', style: TextStyle(fontSize: 18)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Close', style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  } else {
    if (await canLaunchUrl(Uri.parse(item.link))) {
      await launchUrl(Uri.parse(item.link));
    }
  }
}

// explainItem(BuildContext context, NewsItem item) async {
//   String documentString = parse(item.description).documentElement!.text;
//   final QuestionBloc bloc = QuestionBloc();
//   bloc.add(
//     QuestionEvent(
//       "Summarize TITLE and CONTENT in 3 sentences. TITLE: ${item.title} , CONTENT:  $documentString .",
//     ),
//   );
//   DateTime startTime = DateTime.now();

//   showDialog(
//     context: context,
//     builder: (context) {
//       return BlocProvider<QuestionBloc>(
//         create: (context) => bloc,
//         child: BlocBuilder<QuestionBloc, RssState>(
//           builder: (context, state) {
//             if (state is AnswerSuccess) {
//               DateTime endTime = DateTime.now();
//               Duration elapsedTime = endTime.difference(startTime);
//               return AlertDialog(
//                 content: SingleChildScrollView(
//                   child: SelectableText(
//                     'AI summary (time to process ${elapsedTime.inSeconds} seconds):\n\n${state.answer.trim()}',
//                   ),
//                 ),
//                 actions: [
//                   TextButton(
//                     onPressed: () async {
//                       Navigator.pop(context, true);

//                       if (await canLaunchUrl(Uri.parse(item.link))) {
//                         await launchUrl(Uri.parse(item.link));
//                       }
//                     },
//                     child: const Text('Open', style: TextStyle(fontSize: 18)),
//                   ),
//                   TextButton(
//                     onPressed: () => Navigator.pop(context, true),
//                     child: const Text('Close', style: TextStyle(fontSize: 18)),
//                   ),
//                 ],
//               );
//             } else if (state is Failure) {
//               return AlertDialog(
//                 content: Center(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text('Error: ${state.error}'),
//                   ),
//                 ),
//               );
//             } else {
//               return Center(child: Spinner());
//             }
//           },
//         ),
//       );
//     },
//   );
// }

DateTime parsePublishedParsed(String? str) {
  if (str == null) {
    return DateTime.now();
  }

  return DateFormat('yyyy-MM-ddTHH:mm:ssZ').parse(str, true);
}
