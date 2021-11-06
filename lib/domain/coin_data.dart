import 'package:coind/domain/market_data.dart';

class Coin {
  final String id;
  final String symbol;
  final String name;
  final DateTime? lastUpdated;
  final Map<String, String> description;
  final List<String> categories;
  final Links links;
  final MarketData marketData;

  Coin(
      {required this.id,
      required this.symbol,
      required this.name,
      required this.lastUpdated,
      required this.description,
      required this.categories,
      required this.links,
      required this.marketData});

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
        id: json['id'],
        symbol: json['symbol'],
        name: json['name'],
        lastUpdated: DateTime.tryParse(json['last_updated']),
        description: Map<String, String>.from(json['description']),
        categories: List<String>.from(json['categories']),
        links: Links.from(json['links']),
        marketData: MarketData.fromJson(
            Map<String, dynamic>.from(json['market_data'])));
  }
}

class Links {
  final List<String> homepage;
  final List<String> blockchainSites;
  final List<String> forums;
  final List<String> chatUrls;
  final List<String> announcements;
  final String? twitterName;
  final String? facebookUsername;
  final String? bitcoinTalkThreadId;
  final String? telegramChannelId;
  final String? subredditUrl;
  final Repositories repositories;

  static const String facebook = "Facebook";
  static const String reddit = "Reddit";
  static const String twitter = "Twitter";
  static const String telegram = "Telegram";
  static const String bitcoinTalk = "BitcoinTalk";

  Links(
      {required this.homepage,
      required this.blockchainSites,
      required this.forums,
      required this.chatUrls,
      required this.announcements,
      required this.twitterName,
      required this.facebookUsername,
      required this.bitcoinTalkThreadId,
      required this.telegramChannelId,
      required this.subredditUrl,
      required this.repositories});

  Map<String, String> getCommunities() {
    Map<String, String> communities = {};
    if (facebookUsername != null) {
      communities[facebookUsername!] = facebook;
    }
    if (twitterName != null) communities[twitterName!] = twitter;
    if (subredditUrl != null) communities[subredditUrl!] = reddit;
    if (telegramChannelId != null) communities[telegramChannelId!] = telegram;
    if (bitcoinTalkThreadId != null) {
      communities[bitcoinTalkThreadId!] = bitcoinTalk;
    }

    return communities;
  }

  factory Links.from(Map<String, dynamic> json) {
    return Links(
        homepage: List<String>.from(json['homepage']),
        blockchainSites: List<String>.from(json['blockchain_site']),
        forums: List<String>.from(json['official_forum_url']),
        chatUrls: List<String>.from(json['chat_url']),
        announcements: List<String>.from(json['announcement_url']),
        twitterName: json['twitter_screen_name'],
        facebookUsername: json['facebook_username'],
        bitcoinTalkThreadId: json['bitcointalk_thread_identifier'],
        telegramChannelId: json['telegram_channel_identifier'],
        subredditUrl: json['subreddit_url'],
        repositories: Repositories.from(json['repos_url']));
  }
}

class Repositories {
  final List<String> github;
  final List<String> bitbucket;

  Repositories({required this.github, required this.bitbucket});

  factory Repositories.from(Map<String, dynamic> json) {
    return Repositories(
        github: List<String>.from(json['github']),
        bitbucket: List<String>.from(json['bitbucket']));
  }
}
