# BigBlueButton
Ansible role for a bigbluebutton installation (following the documentation on http://docs.bigbluebutton.org/install/install.html)

## Role Variables
| Variable Name | Function | Default value | Comment |
| ------------- | -------- | ------------- | ------- |
| `bbb_hostname` | Hostname for this BigBlueButton instance _(required)_ | `{{ ansible_fqdn }}` |
| `bbb_state` | Install BigBlueButton to state | `present` | for updating BigBlueButton with this role use `latest`
| `bbb_apt_mirror` | apt repo server for BigBlueButton packages | `https://ubuntu.bigbluebutton.org` | other value would be e.g. `https://packages-eu.bigbluebutton.org` |
| `bbb_letsencrypt_enable` | Enable letsencrypt/HTTPS | `yes` |
| `bbb_letsencrypt_email` | E-mail for use with letsencrypt | |
| `bbb_nginx_privacy` | only log errors not access | `yes` |
| `bbb_default_welcome_message` | Welcome Message in the client | Welcome to <b>%%CONFNAME%%</b>!<br><br>For help on using BigBlueButton see these (short) <a href="https://www.bigbluebutton.org/html5"><u>tutorial videos</u></a>.<br><br>To join the audio bridge click the phone button.  Use a headset to avoid causing background noise for others. | Needs to be encoded with `native2ascii -encoding UTF8`! |
| `bbb_default_welcome_message_footer` | Footer of the welcome message | This server is running <a href="https://docs.bigbluebutton.org/" target="_blank"><u>BigBlueButton</u></a>. | Encoded as the welcome message |
| `bbb_coturn_enable` | enable installation of the TURN-server | `yes` |
| `bbb_coturn_server` | server name on coturn (realm) | `{{ bbb_hostname }}` |
| `bbb_coturn_port` | the port for the TURN-Server to use | `3443` |
| `bbb_coturn_port_tls` | the port for tls for the TURN-Server to use | `3443` |
| `bbb_coturn_secret` | Secret for the TURN-Server  _(required)_ | | can be generated with `openssl rand -hex 16`
| `bbb_turn_enable` | enable the use uf TURN in general | `yes` |
| `bbb_stun_servers` | a list of STUN-Server to use | `{{ bbb_hostname }}` | an array with key `server` - take a look in defaults/main.yml
| `bbb_ice_servers` | a list of RemoteIceCandidate for STUN | `[]` | in array with key `server`
| `bbb_turn_servers` | a list of TURN-Server to use | `{{ bbb_hostname }}` with `{{ bbb_coturn_secret }}` | take a look in defaults/main.yml
| `bbb_greenlight_enable` | enable installation of the greenlight client | `yes` |
| `bbb_greenlight_hosts` | the hostname that greenlight is accessible from | `{{ bbb_hostname }}` |
| `bbb_greenlight_secret` | Secret for greenlight _(required when using greenlight)_ |  | can be generated with `openssl rand -hex 64`
| `bbb_greenlight_db_password` | Password for greenlight's database  _(required when using greenlight)_ | | can be generated with `openssl rand -hex 16`
| `bbb_greenlight_default_registration` | Registration option open(default), invite or approval
| `bbb_allow_mail_notifications`  | Set this to true if you want GreenLight to send verification emails upon the creation of a new account | `true` |
| `bbb_disable_recordings` | Disable options in gui to have recordings | `no` | [Recordings are running constantly in background](https://github.com/bigbluebutton/bigbluebutton/issues/9202) which is relevant as privacy relevant user data is stored
| `bbb_api_demos_enable` | enable installation of the api demos | `no` |
| `bbb_mute_on_start:` | start with muted mic on join | `no` |
| `bbb_app_log_level:` | set bigbluebutton log level | `DEBUG` |
| `bbb_meteor:` | overwrite settings in meteor | `{}` |
| `bbb_nodejs_version` | version of nodejs to be installed | `8.x` |
| `bbb_system_locale` | the system locale to use | `en_US.UTF-8` |
| `bbb_secret` | define the secret for bbb | `none` | `set this if you want to define the bbb-conf -secret. Otherwise the secret is generated by bbb`  
| `bbb_cpuschedule` | CPUSchedulingPolicy | `true` | Disable to fix [FreeSWITCH SETSCHEDULER error][bbb_cpuschedule], needed for LXD/LXC Compatibility |
| `bbb_freeswitch_ioschedule_realtime` | [IOSchedulingClass](https://www.freedesktop.org/software/systemd/man/systemd.exec.html#IOSchedulingClass=) | `true` | Set this to `false` for LXD/LXC Compatibility |
| `bbb_freeswitch_ipv6` | Enable IPv6 support in FreeSWITCH | `true` | Disable to fix [FreeSWITCH IPv6 error][bbb_freeswitch_ipv6] |
| `bbb_freeswitch_external_ip` | Set stun server for sip and rtp on FreeSWITCH | `stun:{{ (bbb_stun_servers \| first).server }}` | WARNING: the value of the default freeswitch installation is `stun:stun.freeswitch.org` |
| `bbb_dialplan_quality` | Set quality of dailplan for FreeSWITCH | `cdquality` |
| `bbb_dialplan_energy_level` | Set energy level of dailplan for FreeSWITCH | `100` | only for selected profile `bbb_dialplan_quality`
| `bbb_dialplan_comfort_noise` | Set comfort noise of dailplan for FreeSWITCH | `1400` | only for selected profile `bbb_dialplan_quality`
| `bbb_webhooks_enable` | install bbb-webhooks | `no` |
| `bbb_monitoring_all_in_one_enable` | deploy [all in one monitoring stack](https://bigbluebutton-exporter.greenstatic.dev/installation/all_in_one_monitoring_stack/) (docker) | `no` |
| `bbb_monitoring_all_in_one_version` | Version of the `greenstatic/bigbluebutton-exporter` docker image | `latest` |
| `bbb_monitoring_all_in_one_directory` | Directory for the docker compose files | `/root/bbb-monitoring` |
| `bbb_monitoring_all_in_one_port` | Internal Port for the monitoring werbservice | `3001` |
| `bbb_monitoring_recordings_from_disk` | Collect recordings metrics by querying the disk instead of the API. See [this](https://bigbluebutton-exporter.greenstatic.dev/exporter-user-guide/#optimizations) for details. | `true`

### Extra options for Greenlight
The Web-Frontend has some extra configuration options, listed below:
#### SMTP
The notifications are sent using sendmail, unless the `bbb_greenlight_smtp.server` variable is set.
In that case, make sure the rest of the variables are properly set.

The default value for `bbb_greenlight_smtp.sender` is `bbb@{{ bbb_hostname }}`

Example Setup:
```yaml
bbb_greenlight_smtp:
  server: smtp.gmail.com
  port: 587
  domain: gmail.com
  username: youremail@gmail.com
  password: yourpassword
  auth: plain
  starttls_auto: true
  sender: youremail@gmail.com
```

#### LDAP
You can enable LDAP authentication by providing values for the variables below.
Configuring LDAP authentication will take precedence over all other providers.
For information about setting up LDAP, see: https://docs.bigbluebutton.org/greenlight/gl-config.html#ldap-auth

Example Setup:
```yaml
bbb_greenlight_ldap:
  server: ldap.example.com
  port: 389
  method: plain
  uid: uid
  base: dc=example,dc=com
  bind_dn: cn=admin,dc=example,dc=com
  password: password
  role_field: ou
```

#### GOOGLE_OAUTH2
For in-depth steps on setting up a Google Login Provider, see:  https://docs.bigbluebutton.org/greenlight/gl-config.html#google-oauth2
The `bbb_greenlight_google_oauth2.hd` variable is used to limit sign-ins to a particular set of Google Apps hosted domains. This can be a string with separating commas such as, 'domain.com, example.com' or a string that specifies a single domain restriction such as, 'domain.com'. If left blank, GreenLight will allow sign-in from all Google Apps hosted domains.

```yaml
bbb_greenlight_google_oauth2:
  id:
  secret:
  hd:
```

#### OFFICE365
For in-depth steps on setting up a Office 365 Login Provider, see: https://docs.bigbluebutton.org/greenlight/gl-config.html#office365-oauth2

```yaml
bbb_greenlight_office365:
    id:
    secret:
    hd:
```

#### In Application Authentication
By default, the ability for anyone to create a Greenlight account is enabled. To disable this, use `false`.
For more information see: https://docs.bigbluebutton.org/greenlight/gl-config.html#in-application-greenlight
```yaml
bbb_greenlight_accounts: 'false'
```

#### RECAPTCHA
To enable reCaptcha on the user sign up, define these 2 keys.
You can obtain these keys by registering your domain using the following url: https://www.google.com/recaptcha/admin

```yaml
bbb_greenlight_recaptcha:
  site_key:
  secret_key:
```
#### METEOR
With settings `bbb_meteor` it is possible to overwrite / change settings of meteor.

```yaml
bbb_meteor:
  public:
    app:
      skipCheck: true
    kurento:
      cameraProfiles:
      - id: low
        name: Low quality
        default: true
        bitrate: 20
      - id: medium
        name: Medium quality
        default: false
        bitrate: 200
      - id: high
        name: High quality
        default: false
        bitrate: 500
      - id: hd
        name: High definition
        default: false
        bitrate: 800
```

### LXD/LXC compatibility
To run BigBlueButton in unprivileged LXD/LXC containers, you have to set `bbb_cpuschedule` and `bbb_freeswitch_ioschedule_realtime` to `false`.

## Dependencies
- [geerlingguy.nodejs](https://github.com/geerlingguy/ansible-role-nodejs)
- [geerlingguy.docker](https://github.com/geerlingguy/ansible-role-docker)

## Example Playbook
This is an example, of how to use this role. Warning: the value of the Variables should be changed!

    - hosts: servers
      roles:
         - { role: n0emis.bigbluebutton, bbb_turn_secret: ee8d093109a9b273, bbb_greenlight_secret: 107308d54ff4a5f, bbb_greenlight_db_password: 2585c27c785e8895ec, bbb_letsencrypt_email: mail@example.com }

## License
MIT

[bbb_cpuschedule]: https://docs.bigbluebutton.org/2.2/troubleshooting.html#freeswitch-fails-to-start-with-a-setscheduler-error
[bbb_freeswitch_ipv6]: https://docs.bigbluebutton.org/2.2/troubleshooting.html#freeswitch-fails-to-bind-to-port-8021
