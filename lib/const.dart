class PrefKeys {
  static const npubOrNsecKey = "npubOrNsecKey";
  static const servAddr = "servAddr";
}

const EVENT_DATA_GETTING_INTERVAL_SEC = 10;
const FIRST_GETTING_DATA_PERIOD = 60 * 60 * 24 * 7; // 1 week ago
const NO_PROFILE_USER_PICTURE_URL = 'https://image.nostr.build/fc9f5d58c897b303f468ec5e608a297a1068d3acf250a68c0b2b2d64933f1ab4.jpg';
const POSTS_PER_PAGE = 200;
const FIRTST_EVENT_DATA_GETTING_NUM_MAX = POSTS_PER_PAGE + 100;

enum POST_KIND {
  NORMAL,
  REPLY,
  MENTION,
  REPOST,
  QUOTE_REPOST,
  INVALID
}