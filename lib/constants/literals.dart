library literals;

// ===== General =====
const String appName = 'Song Reads';
const String songCommentHeader = 'Song Comments';
const String albumCommentHeader = 'Album Comments';
const String atGeniusString = '@ Genius';
const String nowPlayingCardHeader = 'Now Playing';

// ===== API =====
//Better searches vs using api.genius.com
//Cant get comments via baseGeniusApiUrl
const String baseGeniusApiUrl = 'https://genius.com/api';
const String baseYoutubeApiUrl = 'https://youtube.googleapis.com/youtube/v3';
const String baseRedditApiUrl = 'https://reddit.com';
const String baseSpotifyApiUrl = 'https://api.spotify.com/v1';
const String spotifyAuthTokenUrl = 'https://accounts.spotify.com/api/token/';
const String spotifyAuthUrl = 'https://accounts.spotify.com/authorize/';
const String redirectUrl = 'songreads:/';
const String webRedirectUrl = 'http://localhost:59889/preferences/callback';

// ===== Preferences =====
//Besides maxResults, sources are all just the toString'd version of the CommentSource enums
const String maxResultsPreferenceKey = 'max_results';

// ===== Token Store =====
const String spotifyAccessTokenKey = 'spotify_access_token';
const String spotifyAccessTokenExpiryKey = 'spotify_access_token_expiry';
const String spotifyRefreshTokenKey = 'spotify_refresh_token_expiry';
const String spotifyAuthCodeKey = 'spotify_auth_code_key';
const String spotifyCodeVerifierKey = 'spotify_code_verifier_key';
const String spotifyUserDisplayNameKey = 'spotify_user_display_name_key';
const String currentAlbumKey = 'current_album_key';

// ===== Secrets =====
const String spotifyClientKey = 'spotify_client_id';
const String spotifySecretKey = 'spotify_client_secret';