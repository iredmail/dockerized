<?php

// //
// This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
// please do __NOT__ modify it manually.
//

// Please add your custom settings in file /opt/iredmail/custom/roundcube/custom.inc.php.
//
// WARNING: First line of /opt/iredmail/custom/roundcube/custom.inc.php
//          must be '<?php'.

// SQL DATABASE
$config['db_dsnw'] = 'mysqli://roundcube:PH_ROUNDCUBE_DB_PASSWORD@PH_SQL_SERVER_ADDRESS:PH_SQL_SERVER_PORT/roundcubemail';

// use persistent db-connections
// beware this will not "always" work as expected
// see: http://www.php.net/manual/en/features.persistent-connections.php
$config['db_persistent'] = false;

// LOGGING
$config['log_driver'] = 'syslog';
$config['syslog_facility'] = LOG_LOCAL5;
// Log successful/failed logins
$config['log_logins'] = true;

// IMAP
// Local connection is considered as secure by Dovecot. If you have issue with
// TLS enabled, try to remove the `tls://` prefix.
$config['imap_host'] = 'tls://127.0.0.1:143';
$config['imap_auth_type'] = 'LOGIN';
$config['imap_delimiter'] = '/';
$config['imap_vendor'] = 'dovecot';
// Required if you're running PHP 5.6 or later
$config['imap_conn_options'] = array(
    'ssl' => array(
        'verify_peer'  => false,
        'verify_peer_name' => false,
    ),
);
// Cache
// Type of IMAP indexes cache.
$config['imap_cache'] = null;   // Supported values: 'db', 'apc' and 'memcache'.
// Enables messages cache.
$config['messages_cache'] = false;  // Only 'db' cache is supported.
// Lifetime of IMAP indexes cache. Possible units: s, m, h, d, w
$config['imap_cache_ttl'] = '10d';
// Lifetime of messages cache. Possible units: s, m, h, d, w
$config['messages_cache_ttl'] = '10d';
// Maximum cached message size in kilobytes.
// Note: On MySQL this should be less than (max_allowed_packet - 30%)
$config['messages_cache_threshold'] = 100;

// SMTP
$config['smtp_host'] = 'tls://127.0.0.1:587';
$config['smtp_user'] = '%u';
$config['smtp_pass'] = '%p';
$config['smtp_auth_type'] = 'LOGIN';
// Required if you're running PHP 5.6 or later
$config['smtp_conn_options'] = array(
    'ssl' => array(
        'verify_peer'      => false,
        'verify_peer_name' => false,
    ),
);

// Message size limit. Note that SMTP server(s) may use a different value.
$config['max_message_size'] = '50M';

// Use user's identity as envelope sender for 'return receipt' responses,
// otherwise it will be rejected by iRedAPD plugin `reject_null_sender`.
$config['mdn_use_from'] = true;

// SYSTEM
$config['auto_create_user'] = true;
$config['force_https'] = true;
$config['login_autocomplete'] = 2;
$config['ip_check'] = false;
$config['des_key'] = 'PH_ROUNDCUBE_DES_KEY';
$config['cipher_method'] = 'AES-256-CBC';
$config['useragent'] = 'Roundcube Webmail'; // Hide version number
$config['mime_types'] = '/etc/mime.types';

// USER INTERFACE
$config['create_default_folders'] = true;
$config['quota_zero_as_unlimited'] = true;
$config['timezone'] = 'UTC';
$config['spellcheck_engine'] = 'pspell';

// USER PREFERENCES
$config['default_charset'] = 'UTF-8';
//$config['addressbook_sort_col'] = 'name';
$config['draft_autosave'] = 60;
$config['default_list_mode'] = 'threads';
$config['autoexpand_threads'] = 2;
$config['check_all_folders'] = true;
$config['default_font_size'] = '12pt';
$config['message_show_email'] = true;
$config['layout'] = 'widescreen';   // three columns
//$config['skip_deleted'] = true;

// PLUGINS
$config['plugins'] = array('managesieve', 'password', 'markasjunk');


// Load extra config file.
require_once "/opt/iredmail/custom/roundcube/custom.inc.php";

//
// This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
// please do __NOT__ modify it manually.
//

// Please add your custom settings in file /opt/iredmail/custom/roundcube/custom.inc.php.
//
// WARNING: First line of /opt/iredmail/custom/roundcube/custom.inc.php
//          must be '<?php'.
