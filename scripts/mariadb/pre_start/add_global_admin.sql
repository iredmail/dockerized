-- Always create this global admin account and set password.
USE vmail;

DELETE FROM admin WHERE username='${GLOBAL_ADMIN_EMAIL}';
DELETE FROM domain_admins WHERE username='${GLOBAL_ADMIN_EMAIL}';

INSERT INTO admin (username, password, active) VALUES ('${GLOBAL_ADMIN_EMAIL}', '${GLOBAL_ADMIN_PASSWORD}', 1);
INSERT INTO domain_admins (username, domain, active) VALUES ('${GLOBAL_ADMIN_EMAIL}', 'ALL', 1);
