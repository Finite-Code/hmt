class OAuthConfig {
  static const String clientId = 'FkIyeePbrPwPxL8QgUgWlvsGNz3VUkfgBaniusehD80';
  static const String redirectUri = 'theyhackedmytime://oauth-callback-v1';
  static const String authEndpoint =
      'https://hackatime.hackclub.com/oauth/authorize';
  static const String tokenEndpoint =
      'https://hackatime.hackclub.com/oauth/token';
  static const List<String> scopes = ['profile', 'read'];

  // Generates the PKCE login URL
  static String getLoginUrl({required String codeChallenge}) {
    final scopeStr = scopes.join('+');
    final encodedRedirect = Uri.encodeComponent(redirectUri);

    return '$authEndpoint'
        '?client_id=$clientId'
        '&redirect_uri=$encodedRedirect'
        '&response_type=code'
        '&scope=$scopeStr'
        '&code_challenge=$codeChallenge'
        '&code_challenge_method=S256';
  }
}
