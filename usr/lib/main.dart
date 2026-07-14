import 'package:flutter/material.dart';

import 'paper_content.dart';

void main() {
  runApp(const TermPaperApp());
}

class TermPaperApp extends StatelessWidget {
  const TermPaperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Term Paper: Piracy & IP Protection',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2C3E50),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
          titleLarge: TextStyle(fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const PaperReaderScreen(),
      },
    );
  }
}

class PaperReaderScreen extends StatefulWidget {
  const PaperReaderScreen({super.key});

  @override
  State<PaperReaderScreen> createState() => _PaperReaderScreenState();
}

class _PaperReaderScreenState extends State<PaperReaderScreen> {
  int _selectedChapterIndex = 0;
  final ScrollController _scrollController = ScrollController();

  void _selectChapter(int index) {
    setState(() {
      _selectedChapterIndex = index;
    });
    if (MediaQuery.of(context).size.width < 800) {
      Navigator.of(context).pop(); // Close drawer on mobile
    }
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 800;
    final paper = TermPaperData.paper;
    final currentChapter = paper.chapters[_selectedChapterIndex];

    final drawer = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.menu_book, size: 40, color: Color(0xFF2C3E50)),
                const SizedBox(height: 12),
                Text(
                  'Contents',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
          ),
          for (int i = 0; i < paper.chapters.length; i++)
            ListTile(
              selected: i == _selectedChapterIndex,
              selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
              leading: CircleAvatar(
                radius: 12,
                backgroundColor: i == _selectedChapterIndex
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey.shade300,
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    color: i == _selectedChapterIndex ? Colors.white : Colors.black,
                  ),
                ),
              ),
              title: Text(
                paper.chapters[i].title,
                style: TextStyle(
                  fontWeight: i == _selectedChapterIndex ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onTap: () => _selectChapter(i),
            ),
        ],
      ),
    );

    return Scaffold(
      appBar: isDesktop
          ? null
          : AppBar(
              title: const Text('Term Paper Reader'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
      drawer: isDesktop ? null : drawer,
      body: Row(
        children: [
          if (isDesktop)
            SizedBox(
              width: 300,
              child: drawer,
            ),
          if (isDesktop) const VerticalDivider(width: 1),
          Expanded(
            child: SelectionArea(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  SliverToBoxAdapter(
                    child: Center(
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 800),
                        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_selectedChapterIndex == 0) ...[
                              Text(
                                paper.title,
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      fontSize: 32,
                                      height: 1.3,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'By: Anonymous Author',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.grey.shade700,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 48),
                            ],
                            Text(
                              currentChapter.title,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              currentChapter.content,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 60),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (_selectedChapterIndex > 0)
                                  ElevatedButton.icon(
                                    onPressed: () => _selectChapter(_selectedChapterIndex - 1),
                                    icon: const Icon(Icons.arrow_back),
                                    label: const Text('Previous Chapter'),
                                  )
                                else
                                  const SizedBox.shrink(),
                                if (_selectedChapterIndex < paper.chapters.length - 1)
                                  ElevatedButton.icon(
                                    onPressed: () => _selectChapter(_selectedChapterIndex + 1),
                                    icon: const Icon(Icons.arrow_forward),
                                    label: const Text('Next Chapter'),
                                  )
                                else
                                  const SizedBox.shrink(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
