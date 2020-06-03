Create vars.yml file on this project root
Generate random base64 string `openssl rand -base64 32` which will be used by MLMMJADMIN_API_TOKEN bellow
Generate random base64 string `openssl rand -base64 24` which will be used by ROUNDCUBE_DES_KEY bellow

```
HOSTNAME: mail.domain-name.com
FIRST_MAIL_DOMAIN: domain-name.com
FIRST_MAIL_DOMAIN_ADMIN_PASSWORD: my-secret-key
VOLUMES_PATH: /iredmail
MLMMJADMIN_API_TOKEN: FaxewEJDJ1DRugn6qIwQtZ9haON2BU9vhgqCTn6+XQE=
ROUNDCUBE_DES_KEY: 72neDbKMUfkoMvncqoe0OKy6jeSV5Rlc
```

Create hosts file on this project root with bellow content
`deploy ansible_host=IP_OF_MACHINE_WHERE_THIS_SERVICE_WILL_BE_DEPLOYED ansible_user=USER_OF_THAT_MACHINE ansible_python_interpreter=/usr/bin/python3`

Deploy container using ansible-playbook cmd
`ansible-playbook -i hosts playbook.yml`
