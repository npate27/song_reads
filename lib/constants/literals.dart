library literals;

// ===== General =====
const String appName = 'Song Reads';
const String songCommentHeader = 'Song Comments';
const String albumCommentHeader = 'Album Comments';
const String atGeniusString = '@ Genius';
const String nowPlayingCardHeader = 'Now Playing';

// ===== API =====
const String baseGeniusApiUrl = 'https://api.genius.com';
const String baseYoutubeApiUrl = 'https://youtube.googleapis.com/youtube/v3';
const String baseRedditApiUrl = 'https://reddit.com';
const String baseSpotifyApiUrl = 'https://api.spotify.com/v1';
const String spotifyAuthTokenUrl = 'https://accounts.spotify.com/api/token/';

// ===== Preferences =====
//Besides maxResults, sources are all just the toString'd version of the CommentSource enums
const String maxResultsPreferenceKey = "max_results";