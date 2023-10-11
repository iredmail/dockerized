<?php

// //
// This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
// please do __NOT__ modify it manually.
//

// Please add your custom settings in file "/opt/iredmail/custom/roundcube/config_managesieve.inc.php"
//
// WARNING: First line of "/opt/iredmail/custom/roundcube/config_managesieve.inc.php"
//          must be '<?php'.

// Managesieve server host (and optional port). Default: localhost.
// Replacement variables supported in host name:
// %h - user's IMAP hostname
// %n - http hostname ($_SERVER['SERVER_NAME'])
// %d - domain (http hostname without the first part)
// For example %n = mail.domain.tld, %d = domain.tld
// If port is omitted it will be determined automatically using getservbyname()
// function, with 4190 as a fallback.
// Note: Add tls:// prefix to enable explicit STARTTLS
// or add ssl:// prefix to enable implicit SSL.
$config['managesieve_host'] = 'tls://127.0.0.1:4190';

// authentication method. Can be CRAM-MD5, DIGEST-MD5, PLAIN, LOGIN, EXTERNAL
// or none. Optional, defaults to best method supported by server.
$config['managesieve_auth_type'] = "LOGIN";

// Optional managesieve authentication identifier to be used as authorization proxy.
// Authenticate as a different user but act on behalf of the logged in user.
// Works with PLAIN and DIGEST-MD5 auth.
$config['managesieve_auth_cid'] = null;

// Optional managesieve authentication password to be used for imap_auth_cid
$config['managesieve_auth_pw'] = null;

// use or not TLS for managesieve server connection
// Note: tls:// prefix in managesieve_host is also supported
$config['managesieve_usetls'] = false;

// Connection scket context options
// See http://php.net/manual/en/context.ssl.php
// The example below enables server certificate validation
//$config['managesieve_conn_options'] = array(
//  'ssl'         => array(
//     'verify_peer'  => true,
//     'verify_depth' => 3,
//     'cafile'       => '/etc/openssl/certs/ca.crt',
//   ),
// );
$config['managesieve_conn_options'] = array("ssl" => array("verify_peer" => false, "verify_peer_name" => false));

// default contents of filters script (eg. default spam filter)
$config['managesieve_default'] = '';

// The name of the script which will be used when there's no user script
$config['managesieve_script_name'] = 'managesieve';

// Sieve RFC says that we should use UTF-8 endcoding for mailbox names,
// but some implementations does not covert UTF-8 to modified UTF-7.
// Defaults to UTF7-IMAP
$config['managesieve_mbox_encoding'] = 'UTF-8';

// I need this because my dovecot (with listescape plugin) uses
// ':' delimiter, but creates folders with dot delimiter
$config['managesieve_replace_delimiter'] = '';

// disabled sieve extensions (body, copy, date, editheader, encoded-character,
// envelope, environment, ereject, fileinto, ihave, imap4flags, index,
// mailbox, mboxmetadata, regex, reject, relational, servermetadata,
// spamtest, spamtestplus, subaddress, vacation, variables, virustest, etc.
// Note: not all extensions are implemented
$config['managesieve_disabled_extensions'] = array();

// Enables debugging of conversation with sieve server. Logs it into <log_dir>/sieve
$config['managesieve_debug'] = false;

// Enables features described in http://wiki.kolab.org/KEP:14
$config['managesieve_kolab_master'] = false;

// Script name extension used for scripts including. Dovecot uses '.sieve',
// Cyrus uses '.siv'. Doesn't matter if you have managesieve_kolab_master disabled.
$config['managesieve_filename_extension'] = '.sieve';

// List of reserved script names (without extension).
// Scripts listed here will be not presented to the user.
$config['managesieve_filename_exceptions'] = array();

// List of domains limiting destination emails in redirect action
// If not empty, user will need to select domain from a list
$config['managesieve_domains'] = array();

// Enables separate management interface for vacation responses (out-of-office)
// 0 - no separate section (default),
// 1 - add Vacation section,
// 2 - add Vacation section, but hide Filters section
$config['managesieve_vacation'] = 1;

// Enables separate management interface for setting forwards (redirect to and copy to)
// 0 - no separate section (default),
// 1 - add Forward section,
// 2 - add Forward section, but hide Filters section
$config['managesieve_forward'] = 1;

// Default vacation interval (in days).
// Note: If server supports vacation-seconds extension it is possible
// to define interval in seconds here (as a string), e.g. "3600s".
$config['managesieve_vacation_interval'] = 0;

// Some servers require vacation :addresses to be filled with all
// user addresses (aliases). This option enables automatic filling
// of these on initial vacation form creation.
$config['managesieve_vacation_addresses_init'] = false;

// Supported methods of notify extension. Default: 'mailto'
$config['managesieve_notify_methods'] = array('mailto');

// Load extra config file.
require_once "/opt/iredmail/custom/roundcube/config_managesieve.inc.php";

//
// This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
// please do __NOT__ modify it manually.
//

// Please add your custom settings in file "/opt/iredmail/custom/roundcube/config_managesieve.inc.php"
// WARNING: First line of "/opt/iredmail/custom/roundcube/config_managesieve.inc.php" must be '<?php'.
