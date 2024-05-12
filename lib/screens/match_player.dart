import 'dart:math';

import 'package:connect4/colors/app_colors.dart';
import 'package:connect4/main.dart';
import 'package:connect4/screens/game.dart';
import 'package:connect4/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MatchPlayerScreen extends StatefulWidget {
  const MatchPlayerScreen({super.key});

  @override
  State<MatchPlayerScreen> createState() => _MatchPlayerScreenState();
}

class _MatchPlayerScreenState extends State<MatchPlayerScreen> {
  List<Map<String, dynamic>> aiPlayers = [];
  PageController controller = PageController();

  final List<String> maleIgboNames = [
    'Chinonso',
    'Emeka',
    'Obinna',
    'Nnamdi',
    'Chukwudi',
    'Tochukwu',
    'Uchenna',
    'Ikenna',
    'Chinedu',
    'Ifeanyi',
    'Onyekachi',
    'Ugochukwu',
    'Ikechukwu',
    'Chijioke',
    'Kelechi',
    'Somto',
    'Okechukwu',
    'Obiora',
    'Nkem',
    'Olisa',
    'Oluoma',
    'Olamide',
    'Nnabuike',
    'Chimaobi',
    'Ozor',
    'Udochukwu',
    'Onyeka',
    'Ozuluonye',
    'Ozumba',
    'Chikezie',
    'Ugo',
    'Chibuike',
    'Udoka',
    'Nonso',
    'Ejike',
    'Chidiebere',
    'Igwe',
    'Onyedika',
    'Eze',
    'Ezeudo',
    'Ezennia',
    'Chidubem',
    'Ozioma',
    'Kenechukwu',
    'Chidumebi',
    'Chike',
    'Onyemachi',
    'Chigozie',
    'Chinedum',
    'Nnadi',
    'Ikemefuna'
  ];

  final List<String> femaleIgboNames = [
    'Ngozi',
    'Chiamaka',
    'Uche',
    'Chidinma',
    'Ifunanya',
    'Chioma',
    'Chinwe',
    'Nneka',
    'Obiageli',
    'Amara',
    'Oluchi',
    'Onyinyechi',
    'Adaobi',
    'Ijeoma',
    'Chinyere',
    'Nkechi',
    'Ogechi',
    'Ogonna',
    'Ginika',
    'Uzoamaka',
    'Chinaza',
    'Nkemjika',
    'Uzoma',
    'Olamma',
    'Chizoba',
    'Ulonma',
    'Chidera',
    'Nnenna',
    'Chinelo',
    'Uzoaku',
    'Ifeyinwa',
    'Obianuju',
    'Chinyelu',
    'Izuchukwu',
    'Kamso',
    'Oluebube',
    'Uchendu',
    'Nneoma',
    'Olanma',
    'Ulondu',
    'Ulonwa',
    'Olamipo',
    'Olisaemeka',
    'Uloma',
    'Chigozirim',
    'Ulunma',
    'Chinemerem',
    'Kenechukwu',
    'Onyekachukwu',
    'Ugochinyere',
    'Nnedimma',
    'Olayemi',
    'Oluwanifemi'
  ];

  final List<String> maleYorubaNames = [
    'Oluwaseun',
    'Adewale',
    'Oluwadamilare',
    'Oluwaseyi',
    'Adesola',
    'Oluwafemi',
    'Ayomide',
    'Oluwatobi',
    'Oluwadamilola',
    'Oluwafemi',
    'Oluwasegun',
    'Oluwatimilehin',
    'Oluwaseyi',
    'Adetayo',
    'Olamilekan',
    'Adedotun',
    'Oluwafunmilayo',
    'Ayodeji',
    'Ayomiposi',
    'Oluwadamisi',
    'Ademola',
    'Ayotunde',
    'Olumide',
    'Oluwaseun',
    'Oluwadamilola',
    'Oluwatosin',
    'Oluwadamilare',
    'Adeoluwa',
    'Adeyemi',
    'Ayokunle',
    'Adewunmi',
    'Oluwadamilola',
    'Oluwatosin',
    'Ayomide',
    'Adedayo',
    'Oluwafemi',
    'Adeyinka',
    'Oluwasegun',
    'Oluwaseyi',
    'Oluwatobiloba',
    'Oluwafemi',
    'Oluwaseun',
    'Ayomide',
    'Oluwatosin',
    'Oluwaseun',
    'Adeniyi',
    'Adebowale',
    'Oluwafemi',
    'Oluwagbemiga',
    'Oluwadamilola',
    'Oluwadamilare',
    'Oluwafunmilayo',
    'Ayodele',
    'Oluwafemi'
  ];

  final List<String> femaleYorubaNames = [
    'Oluwakemi',
    'Titilayo',
    'Oluwatosin',
    'Oluwadamilola',
    'Oluwabunmi',
    'Oluwabukola',
    'Omolara',
    'Oluwafunmilayo',
    'Oluwatobiloba',
    'Oluwadamilola',
    'Oluwaseun',
    'Oluwatoyin',
    'Oluwaseyi',
    'Olufunke',
    'Oluwadamilola',
    'Oluwabukunmi',
    'Oluwakemi',
    'Oluwaseun',
    'Oluwadamilola',
    'Oluwaseyi',
    'Oluwafunmilayo',
    'Oluwakemi',
    'Oluwatoyin',
    'Oluwatobi',
    'Oluwaseyi',
    'Oluwabunmi',
    'Oluwakemi',
    'Oluwaseun',
    'Oluwatoyin',
    'Oluwadamilola',
    'Oluwaseyi',
    'Oluwabunmi',
    'Oluwafunmilayo',
    'Oluwatoyin',
    'Oluwaseun',
    'Oluwadamilola',
    'Oluwaseyi',
    'Oluwabukola',
    'Oluwadamilola',
    'Oluwakemi',
    'Oluwafunmilayo',
    'Oluwatoyin',
    'Oluwatobiloba',
    'Oluwaseyi',
    'Oluwabunmi',
    'Oluwakemi',
    'Oluwafunmilayo',
    'Oluwaseun',
    'Oluwatoyin',
    'Oluwadamilola',
    'Oluwaseyi',
    'Oluwabukunmi'
  ];

  final List<String> maleHausaNames = [
    'Abubakar',
    'Yakubu',
    'Umar',
    'Ibrahim',
    'Usman',
    'Sani',
    'Aliyu',
    'Garba',
    'Muhammad',
    'Hassan',
    'Mustapha',
    'Ahmed',
    'Adamu',
    'Kabiru',
    'Nasir',
    'Bello',
    'Aminu',
    'Abdullahi',
    'Shehu',
    'Musa',
    'Jibril',
    'Tijjani',
    'Ismail',
    'Abdulrahman',
    'Salisu',
    'Zakari',
    'Yusuf',
    'Ibrahim',
    'Ismaila',
    'Musa',
    'Sani',
    'Abubakar',
    'Yahaya',
    'Abdulmalik',
    'Abubakar',
    'Aliyu',
    'Ibrahim',
    'Suleiman',
    'Auwal',
    'Yunusa',
    'Habibu',
    'Bashir',
    'Abdul',
    'Yahaya',
    'Umar',
    'Abdulahi',
    'Kabiru',
    'Mohammed',
    'Aminu',
    'Bello',
    'Ali',
    'Mohammed',
    'Shehu',
    'Musa',
    'Lawal',
    'Isa',
    'Yahaya',
    'Bashir',
    'Nasiru',
    'Umar',
    'Ahmed',
    'Zakari',
    'Haruna',
    'Abubakar',
    'Mustapha',
    'Abdul',
    'Zakari',
    'Usman',
    'Mohammed',
    'Ibrahim',
    'Yusuf',
    'Abubakar',
    'Abdullahi',
    'Salisu',
    'Muhammad',
    'Yusuf',
    'Ibrahim',
    'Abdullahi',
    'Shehu',
    'Sani',
    'Hassan',
    'Bello',
    'Ahmed'
  ];

  final List<String> femaleHausaNames = [
    'Fatima',
    'Aisha',
    'Nafisa',
    'Maryam',
    'Aisha',
    'Hauwa',
    'Zainab',
    'Falmata',
    'Zara',
    'Khadija',
    'Halima',
    'Hadiza',
    'Sadiya',
    'Asmau',
    'Rukayya',
    'Amina',
    'Fati',
    'Zuwaira',
    'Sa\'adatu',
    'Hajara',
    'Zuwaira',
    'Amina',
    'Aisha',
    'Hauwa',
    'Fatima',
    'Halima',
    'Maryam',
    'Asmau',
    'Khadija',
    'Rahma',
    'Aisha',
    'Amina',
    'Maryam',
    'Halima',
    'Hauwa',
    'Zainab',
    'Falmata',
    'Zara',
    'Rukayya',
    'Hajara',
    'Hadiza',
    'Fatima',
    'Sa\'adatu',
    'Asmau',
    'Zuwaira',
    'Khadija',
    'Fati',
    'Hauwa',
    'Maryam',
    'Amina',
    'Aisha',
    'Hajara',
    'Fatima',
    'Zainab',
    'Falmata',
    'Aisha',
    'Zuwaira',
    'Hauwa',
    'Khadija',
    'Maryam'
  ];

  void generateAIPlayers() {
    final random = Random();
    for (int i = 0; i < 500; i++) {
      String name = "";
      int avatar = 1;

      if (i % 2 == 0) {
        // Generate male name and avatar
        switch (random.nextInt(3)) {
          case 0:
            name = maleIgboNames[random.nextInt(maleIgboNames.length)];
            avatar = random.nextInt(12) + 1;
            break;
          case 1:
            name = maleYorubaNames[random.nextInt(maleYorubaNames.length)];
            avatar = random.nextInt(12) + 1;
            break;
          case 2:
            name = maleHausaNames[random.nextInt(maleHausaNames.length)];
            avatar = random.nextInt(12) + 13;
            break;
          /* case 3:
            name = maleHausaNames[random.nextInt(maleHausaNames.length)];
            avatar = random.nextInt(12) + 13;
            break; */
        }
      } else {
        // Generate female name and avatar
        switch (random.nextInt(3)) {
          case 0:
            name = femaleIgboNames[random.nextInt(femaleIgboNames.length)];
            avatar = random.nextInt(12) + 13;
            break;
          case 1:
            name = femaleYorubaNames[random.nextInt(femaleYorubaNames.length)];
            avatar = random.nextInt(12) + 13;
            break;
          case 2:
            name = femaleHausaNames[random.nextInt(femaleHausaNames.length)];
            avatar = random.nextInt(12) + 13;
            break;
          /* case 3:
            name = femaleHausaNames[random.nextInt(femaleHausaNames.length)];
            avatar = random.nextInt(12) + 13;
            break; */
        }
      }
      if (name.length <= 8) {
        aiPlayers.add({'name': name, 'avatar': avatar});
      }
    }
  }

  @override
  void initState() {
    generateAIPlayers();
    aiPlayers.shuffle();
    aiPlayers = aiPlayers.take(25).toList();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(2.seconds, () {
        controller.animateToPage(
          24,
          duration: 5.seconds,
          curve: Curves.easeInOutCubicEmphasized,
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          const Spacer(flex: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/images/player.png',
                    height: 80.h,
                    width: 80.w,
                  ).animate().scaleXY(
                        begin: 0,
                        end: 1,
                        curve: Curves.easeOut,
                        delay: .1.seconds,
                        duration: 1.seconds,
                      ),
                  SizedBox(height: 5.h),
                  Text(
                    "You",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                  ).animate().slideX(
                        begin: -100,
                        curve: Curves.easeInOutCubicEmphasized,
                        duration: 1.seconds,
                      ),
                ],
              ),
              SizedBox(width: 20.w),
              Text(
                "VS",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                ),
              ).animate().slideY(
                    begin: -20.h,
                    curve: Curves.bounceOut,
                    delay: 1.2.seconds,
                    duration: 1.seconds,
                  ),
              SizedBox(width: 20.w),
              Column(
                children: [
                  SizedBox(height: 7.h),
                  SizedBox(
                    height: 60.h,
                    width: 60.w,
                    child: PageView(
                      controller: controller,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      children: List.generate(
                        25,
                        (index) => Image.asset(
                          'assets/images/computer.png',
                          height: 60.h,
                          width: 60.w,
                        ),
                      ),
                    ),
                  ).animate().fadeIn(
                        delay: 2.2.seconds,
                        duration: 1.seconds,
                      ),
                  SizedBox(height: 13.h),
                  Text(
                    aiPlayers.last['name'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ),
                  ).animate().slideX(
                        delay: 6.seconds,
                        duration: 1.seconds,
                        begin: 100.w,
                        curve: Curves.easeInOutCubicEmphasized,
                      ),
                ],
              ),
            ],
          ),
          const Spacer(flex: 2),
          GameButton(
            text: 'CONTINUE',
            onPressed: () {
              playTap(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GameScreen(
                    gameMode: GameMode.twoPlayersOnline,
                    secondPlayer: aiPlayers.last,
                  ),
                ),
              );
            },
          ).animate().moveY(
                begin: 200.h,
                delay: 7.2.seconds,
                duration: 1.seconds,
                curve: Curves.bounceOut,
              ),
          const Spacer(),
        ],
      ),
    );
  }
}
