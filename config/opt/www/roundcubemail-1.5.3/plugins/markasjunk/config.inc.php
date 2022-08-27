<?php

// //
// This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
// please do __NOT__ modify it manually.
//

$config['markasjunk_learning_driver'] = null;
$config['markasjunk_ham_mbox'] = null;
$config['markasjunk_spam_mbox'] = null;
$config['markasjunk_read_spam'] = true;
$config['markasjunk_unread_ham'] = false;

// Add flag to messages marked as spam (flag will be removed when marking as ham)
// If you do not want to use message flags set this to false
$config['markasjunk_spam_flag'] = false;

// Add flag to messages marked as ham (flag will be removed when marking as spam)
// If you do not want to use message flags set this to false
$config['markasjunk_ham_flag'] = false;

// Write output from spam/ham commands to the log for debug
$config['markasjunk_debug'] = false;

// The mark as spam/ham icon can either be displayed on the toolbar or as part of the mark messages menu.
// Set to False to use Mark menu instead of the toolbar. Default: true.
$config['markasjunk_toolbar'] = true;

// Learn any message moved to the spam mailbox as spam (not just when the button is pressed)
//
// Note: iRedMail has Dovecot `imapsieve` plugin enabled to learn messages moved
//       to spam mailbox, this option is unnecessary.
$config['markasjunk_move_spam'] = false;

// Learn any message moved from the spam mailbox to the ham mailbox as ham (not just when the button is pressed)
$config['markasjunk_move_ham'] = false;

// Some drivers create new copies of the target message(s), in this case the original message(s) will be deleted
// Rather than deleting the message(s) (moving to Trash) setting this option true will cause the original message(s) to be permanently removed
$config['markasjunk_permanently_remove'] = false;

// Display only a mark as spam button
$config['markasjunk_spam_only'] = false;

// Activate markasjunk for selected mail hosts only. If this is not set all mail hosts are allowed.
// Example: $config['markasjunk_allowed_hosts'] = array('mail1.domain.tld', 'mail2.domain.tld');
$config['markasjunk_allowed_hosts'] = null;

// Load specific config for different mail hosts
// Example: $config['markasjunk_host_config'] = array(
//    'mail1.domain.tld' => 'mail1_config.inc.php',
//    'mail2.domain.tld' => 'mail2_config.inc.php',
// );
$config['markasjunk_host_config'] = null;

$config['markasjunk_spam_cmd'] = null;
$config['markasjunk_ham_cmd'] = null;
$config['markasjunk_spam_dir'] = null;
$config['markasjunk_ham_dir'] = null;
$config['markasjunk_filename'] = null;
$config['markasjunk_email_spam'] = null;
$config['markasjunk_email_ham'] = null;
// Should the spam/ham message be sent as an attachment
$config['markasjunk_email_attach'] = true;
$config['markasjunk_email_subject'] = 'learn this message as %t';
$config['markasjunk_sauserprefs_config'] = '../sauserprefs/config.inc.php';
$config['markasjunk_amacube_config'] = '../amacube/config.inc.php';

$config['markasjunk_spam_patterns'] = array(
    'patterns'     => array(),
    'replacements' => array()
);

$config['markasjunk_ham_patterns'] = array(
    'patterns'     => array(),
    'replacements' => array()
);

// Load extra config file.
require_once "/opt/iredmail/custom/roundcube/config_markasjunk.inc.php";

//
// This file is managed by iRedMail Team <support@iredmail.org> with Ansible,
// please do __NOT__ modify it manually.
//

// Please add your custom settings in file "/opt/iredmail/custom/roundcube/config_markasjunk.inc.php"
// WARNING: First line of "/opt/iredmail/custom/roundcube/config_markasjunk.inc.php" must be '<?php'.
