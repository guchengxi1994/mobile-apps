import 'dart:math';

List<String> sentenses = [
  "生命中真正重要的，不是你遭遇了什么，而是你记住了哪些事，又是如何铭记的。",
  "世界上最宽阔的是海洋，比海洋更宽阔的是天空，比天空更宽阔的是人的心灵。",
  "人都是为希望而活，因为有了希望，人才有生活的勇气。",
];

List<String> fromWhere = [
  "——《百年孤独》",
  "——《悲惨世界》",
  "——《安娜 卡列尼娜》",
];

List<String> wildes = [
  "爱，始于自我欺骗，终于欺骗他人。%这就是所谓的浪漫。",
  "浪漫的本质是不确定性。",
  "美好的肉体是为了享乐，%美好的灵魂是为了痛苦。",
  "真相很少纯粹，%也决不简单。",
  "生活中只有两个悲剧：%一个是没有得到你想要的，%另外一个是得到了你想要的。",
  "永远宽恕你的敌人，%没有什么能比这个更让他们恼怒的了。"
];

String getRandomSentence(List<String> l) {
  final Random _random = Random();
  return l[_random.nextInt(l.length)];
}
