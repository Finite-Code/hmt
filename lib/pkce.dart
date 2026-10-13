import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/*

NOTE: ORIGINAL PKCE CONCEPT AND IDEA WAS GENERATED USING A LLM. SINCE BEEN SLIGHTLY MODIFIED BY A HUMAN.

 */

class PkceHelper {
  // Generates a cryptographically secure random string (43-128 chars)
  static String generateCodeVerifier() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64UrlEncode(values)
        .replaceAll('=', '')
        .replaceAll('+', '-')
        .replaceAll('/', '_');
  }

  // Hashes the verifier with SHA-256 for the authorization request
  static String generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes)
        .replaceAll('=', '')
        .replaceAll('+', '-')
        .replaceAll('/', '_');
  }
}
