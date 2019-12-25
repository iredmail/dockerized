-- Always create this global admin account and set password.
USE vmail;

DELETE FROM admin WHERE username='${POSTMASTER_EMAIL}';
DELETE FROM domain_admins WHERE username='${POSTMASTER_EMAIL}';

INSERT INTO admin (username, password, active) VALUES ('${POSTMASTER_EMAIL}', '${POSTMASTER_PASSWORD}', 1);
INSERT INTO domain_admins (username, domain, active) VALUES ('${POSTMASTER_EMAIL}', 'ALL', 1);
