import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(Perplexity());
}

class Perplexity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // UI 구성
    return MaterialApp(
      title: 'Perplexity',
      theme: ThemeData(
        primarySwatch: Colors.blue, // 다양한 음영을 자동으로 생성하여 앱 전체에 일관된 색상 테마를 적용
        visualDensity: VisualDensity
            .adaptivePlatformDensity, // 다양한 화면 크기와 플랫폼에서 최적화된 레이아웃을 제공
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  // 상태를 가지는 위젯으로, 사용자 상호작용에 따라 내용이 변경 가능
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // HomePage의 상태 관리
  int _currentIndex = 0; // 현재 선택된 페이지의 인덱스

  final List<Widget> _pages = [
    MainPage(),
    SearchPage(),
    Threadpage(),
  ]; // 표시할 페이지들의 리스트

  void _onItemTapped(int index) {
    // 하단 네비게이션 바의 아이템이 탭될 때 호출되어 상태를 업데이트
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Flutter에서 매우 중요한 위젯으로 기본적인 머터리얼 디자인 레이아웃 구조를 구현 (Appbar, Body, BottomNavigationBar, BottomSheet, ...)
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Thread'),
        ],
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final TextEditingController _searchController =
      TextEditingController(); // 검색 입력 필드 제어

  final List<String> _suggestedSearches = [
    // 추천 검색어 리스트
    '초밥 에티켓',
    '슬롯머신의 승률',
    '펜싱 연습 세트 가격',
    '알덴테는 무슨 뜻인가요?',
    '집에서 빵 굽는 법',
    '가장 방문객이 적은 나라'
  ];

  void _showAttachmentOptions() {
    // 첨부 옵션을 보여주는 모달 바텀 시트 (이미지 선택, 사진찍기, 파일 업로드)
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '첨부',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.image),
                title: Text('이미지를 선택하세요'),
                onTap: () {
                  // 이미지 선택 로직
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('사진 찍기'),
                onTap: () {
                  // 카메라 실행 로직
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.file_present),
                title: Text('파일을 올리다'),
                onTap: () {
                  // 파일 선택 로직
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.person, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserProfilePage()),
            );
          },
        ),
        title: Text(
          'Perplexity Pro',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add, color: Colors.black),
            onPressed: () {
              print('친구 초대');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.psychology, size: 80, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              "지식이 시작되는 곳",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              runSpacing: 10,
              children: _suggestedSearches
                  .map((search) => SizedBox(
                        width: 150, // 버튼의 고정 너비
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SearchResultPage(query: search),
                              ),
                            );
                          },
                          child: Text(
                            search,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.attach_file),
                onPressed: _showAttachmentOptions,
              ),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '무엇이든 질문하기...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  ),
                  onSubmitted: (value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResultPage(query: value),
                      ),
                    );
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.mic),
                onPressed: () {
                  print('음성 인식 시작');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('검색'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // 설정 페이지로 이동하는 로직
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: Text('주요뉴스'),
                    onPressed: () {},
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    child: Text('테크 & 과학'),
                    onPressed: () {},
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    child: Text('예술 & 문화'),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10, // 예시로 10개의 게시글을 표시
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: Icon(Icons.image,
                                size: 50, color: Colors.grey[600]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.bookmark_border),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: Icon(Icons.volume_up),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Threadpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.search, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SearchResultPage(query: '')),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () {
              // 새 스레드 추가 기능 구현
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    child: Text('스레드'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    child: Text('컬렉션'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildThreadItem('프로이트 꿈의 해석은 무엇인가?', 1),
                _buildThreadItem('세상에서 가장 작은 동물은 무엇일까?', 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThreadItem(String title, int imageCount) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: List.generate(
                imageCount,
                (index) => Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, color: Colors.grey[600]),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text(
                  imageCount == 1 ? '1h' : '9m',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('계정관리'),
        actions: [
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () async {
              const url = 'https://github.com/incheonQ';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw '계정관리 페이지를 열 수 없습니다: $url';
              }
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.person),
            ),
            title: Text('ID'),
            subtitle: GestureDetector(
              onTap: () async {
                const url = 'https://www.example.com/account-management';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw '계정관리 페이지를 열 수 없습니다: $url';
                }
              },
              child: Text('계정관리'),
            ),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Perplexity Pro'),
          ),
          ListTile(
            leading: Icon(Icons.psychology),
            title: Text('AI 모델'),
          ),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('테마 & 앱 아이콘'),
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('앱 언어'),
          ),
          ListTile(
            leading: Icon(Icons.volume_up),
            title: Text('음성 & 언어'),
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('위치'),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('푸시 알림'),
            trailing: Switch(
              value: true,
              onChanged: (bool value) {
                // 푸시 알림 설정 변경 로직
              },
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('도움말 & 지원', style: TextStyle(color: Colors.grey)),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('시작하기'),
          ),
        ],
      ),
    );
  }
}

// 새로운 SearchResultPage 클래스 추가
class SearchResultPage extends StatefulWidget {
  final String query;

  const SearchResultPage({Key? key, required this.query}) : super(key: key);

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.query,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '무엇이든 질문하기...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.attach_file),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.mic),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text('검색 결과가 여기에 표시됩니다.'),
            ),
          ),
        ],
      ),
    );
  }
}
