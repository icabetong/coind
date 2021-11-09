import 'package:coind/domain/market_data.dart';

class Coin {
  final String id;
  final String symbol;
  final String name;
  final DateTime? lastUpdated;
  final Map<String, String> description;
  final List<String> categories;
  final Links? links;
  final MarketData? marketData;

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
        lastUpdated: json['last_updated'] != null
            ? DateTime.tryParse(json['last_updated'])
            : null,
        description: json['description'] != null
            ? Map<String, String>.from(json['description'])
            : {},
        categories: json['categories'] != null
            ? List<String>.from(json['categories'])
            : [],
        links: json['links'] != null ? Links.from(json['links']) : null,
        marketData: json['market_data'] != null
            ? MarketData.fromJson(
                Map<String, dynamic>.from(json['market_data']))
            : null);
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
  final int bitcoinTalkThreadId;
  final String? telegramChannelId;
  final String? subredditUrl;
  final Repositories repositories;

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

  List<String> getForumsAndChats() {
    List<String> data = [...forums, ...chatUrls];
    return data.where((forum) => forum.isNotEmpty).toList();
  }

  List<String> getWebsites() {
    List<String> websites = [];
    for (var element in homepage) {
      if (element.isNotEmpty) {
        websites.add(element);
      }
    }
    for (var element in announcements) {
      if (element.isNotEmpty) {
        websites.add(element);
      }
    }

    return websites;
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
        bitcoinTalkThreadId: json['bitcointalk_thread_identifier'] != null
            ? int.parse(json['bitcointalk_thread_identifier'].toString())
            : 0,
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
