enum ButtonAction { submit, update }

class Status {
  static String get created => "Submitted";
  static String get drafted => "Drafted";
  static String get published => "Published";
  static String get all => "All";
  static String get approved => "Approved";
  static String get submitted => "Submitted";
}

class Language {
  static int get hindi => 1;
  static int get english => 2;
}

class Location {
  static String get varanasi => 'Varanasi';
  static String get agra => 'Agra';
}

class AppFontFamily {
  static String get hindiFontStyle => 'Poppins';
  static String get englishFontStyle => 'domine';
}

class NewsTypeEnum {
  static String get news => 'News';
  static String get newsHindi => 'समाचार';
  static int get newsId => 1;
  static String get editorial => 'Editorial';
  static String get editorialHindi => 'संपादकीय';
  static int get editorialId => 2;
  static String get breakingNews => 'Breaking News';
  static String get breakingNewsHindi => 'ब्रेकिंग न्यूज़';
  static int get breakingNewsId => 3;
}
