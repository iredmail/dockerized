<?php

// //
// This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
// please do __NOT__ modify it manually.
//

// Please add your custom settings in file "/opt/iredmail/custom/roundcube/config_password.inc.php"
//
// WARNING: First line of "/opt/iredmail/custom/roundcube/config_password.inc.php"
//          must be '<?php'.

// Password Plugin options
// -----------------------
// A driver to use for password change. Default: "sql".
// See README file for list of supported driver names.
$config['password_driver'] = 'sql';

// A driver to use for checking password strength. Default: null.
// Set password_check_strength to true to enable
// See README file for list of supported driver names.
$config['password_strength_driver'] = null;

// Determine whether current password is required to change password.
// Default: false.
$config['password_confirm_current'] = true;

// Require the new password to be a certain length.
// set to blank to allow passwords of any length
$config['password_minimum_length'] = "8";

// Require the new password to have at least the specified strength score.
// Note: Password strength is scored from 1 (week) to 5 (strong).
$config['password_minimum_score'] = 3;

// Enables logging of password changes into logs/password
$config['password_log'] = true;

// Comma-separated list of login exceptions for which password change
// will be not available (no Password tab in Settings)
$config['password_login_exceptions'] = null;

// Array of hosts that support password changing. Default is NULL.
// Listed hosts will feature a Password option in Settings; others will not.
// Example: array('mail.example.com', 'mail2.example.org');
$config['password_hosts'] = null;

// Enables saving the new password even if it matches the old password. Useful
// for upgrading the stored passwords after the encryption scheme has changed.
$config['password_force_save'] = false;

// Enables forcing new users to change their password at their first login.
$config['password_force_new_user'] = false;

// Default password hashing/crypting algorithm.
// Possible options: des-crypt, ext-des-crypt, md5-crypt, blowfish-crypt,
// sha256-crypt, sha512-crypt, md5, sha, smd5, ssha, samba, ad, dovecot, clear.
// For details see password::hash_password() method.
$config['password_algorithm'] = 'ssha512';

// Password prefix (e.g. {CRYPT}, {SHA}) for passwords generated
// using password_algorithm above. Default: empty.
$config['password_algorithm_prefix'] = '{SSHA512}';

// Path for dovecotpw/doveadm-pw (if not in the $PATH).
// Used for password_algorithm = 'dovecot'.
$config['password_dovecotpw'] = '/usr/bin/doveadm pw';

// Dovecot password scheme.
// Used for password_algorithm = 'dovecot'.
$config['password_dovecotpw_method'] = 'SSHA512';

// Iteration count parameter for Blowfish-based hashing algo.
// It must be between 4 and 31. Default: 12.
// Be aware, the higher the value, the longer it takes to generate the password hashes.
$config['password_blowfish_cost'] = 12;

// Number of rounds for the sha256 and sha512 crypt hashing algorithms.
// Must be at least 1000. If not set, then the number of rounds is left up
// to the crypt() implementation. On glibc this defaults to 5000.
// Be aware, the higher the value, the longer it takes to generate the password hashes.
//$config['password_crypt_rounds'] = 50000;

// This option temporarily disables the password change functionality.
// Use it when the users database server is in maintenance mode or sth like that.
// You can set it to TRUE/FALSE or a text describing the reason
// which will replace the default.
$config['password_disabled'] = false;


// SQL Driver options
// ------------------
// PEAR database DSN for performing the query. By default
// Roundcube DB settings are used.
$config['password_db_dsn'] = 'mysqli://roundcube:PH_ROUNDCUBE_DB_PASSWORD@PH_SQL_SERVER_ADDRESS:PH_SQL_SERVER_PORT/vmail';

// The SQL query used to change the password.
// The query can contain the following macros that will be expanded as follows:
//      %p is replaced with the plaintext new password
//      %P is replaced with the crypted/hashed new password
//         according to configured password_method
//      %o is replaced with the old (current) password
//      %O is replaced with the crypted/hashed old (current) password
//         according to configured password_method
//      %h is replaced with the imap host (from the session info)
//      %u is replaced with the username (from the session info)
//      %l is replaced with the local part of the username
//         (in case the username is an email address)
//      %d is replaced with the domain part of the username
//         (in case the username is an email address)
// Deprecated macros:
//      %c is replaced with the crypt version of the new password, MD5 if available
//         otherwise DES. More hash function can be enabled using the password_crypt_hash
//         configuration parameter.
//      %D is replaced with the dovecotpw-crypted version of the new password
//      %n is replaced with the hashed version of the new password
//      %q is replaced with the hashed password before the change
// Escaping of macros is handled by this module.
// Default: "SELECT update_passwd(%c, %u)"
$config['password_query'] = "UPDATE mailbox SET password=%P,passwordlastchange=NOW() WHERE username=%u";

// By default the crypt() function which is used to create the %c
// parameter uses the md5 algorithm (deprecated, use %P).
// You can choose between: des, md5, blowfish, sha256, sha512.
$config['password_crypt_hash'] = 'md5';

// By default domains in variables are using unicode.
// Enable this option to use punycoded names
$config['password_idn_ascii'] = false;

// Enables use of password with crypt method prefix in %D, e.g. {MD5}$1$LUiMYWqx$fEkg/ggr/L6Mb2X7be4i1/
// when using the %D macro (deprecated, use %P)
$config['password_dovecotpw_with_method'] = true;

// Using a password hash for %n and %q variables (deprecated, use %P).
// Determine which hashing algorithm should be used to generate
// the hashed new and current password for using them within the
// SQL query. Requires PHP's 'hash' extension.
$config['password_hash_algorithm'] = 'sha1';

// You can also decide whether the hash should be provided
// as hex string or in base64 encoded format.
$config['password_hash_base64'] = false;


// Load extra config file.
require_once "/opt/iredmail/custom/roundcube/config_password.inc.php";

//
// This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
// please do __NOT__ modify it manually.
//

// Please add your custom settings in file "/opt/iredmail/custom/roundcube/config_password.inc.php".
// WARNING: First line of "/opt/iredmail/custom/roundcube/config_password.inc.php" must be '<?php'.
