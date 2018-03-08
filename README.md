This repo is a package of some [entr'ouvert](https://www.entrouvert.com) products.
It's a docker-compose based project to allow locally usage of e-guichet project.

### Requirements

docker-compose 1.6 or above

### Usage

* Add required host names to your /etc/hosts file, for example:

    sudo sh -c "echo '127.0.0.1 local-hobo.example.net local-auth.example.net local.example.net local-portail-agent.example.net' >> /etc/hosts"

* Compose and run the container image

    docker-compose up

* Create superuser

    docker-compose exec localauthentic bash
    authentic2-multitenant-manage createsuperuser


* Sometimes, you need to init data multitimes (into container) with command :

    sudo -u hobo hobo-manage cook /etc/hobo/recipe.json

* Go to http://local.example.net with you favorite browser, an admin account is
  setup, username is "admin" and password is "password" (without the quotes).

### Development

You can clone modules into the src/ directory and they will automatically be
used in the container environment.

Supported modules are:

* combo
* imio-publik-themes (hence publik-base-theme)
* passerelle
* passerelle-imio-tax-compute

Services will be run in django-runserver mode, and can be seen in a screen
session running in the container.

    docker exec -ti dockerauthentic_localauthentic_1 bash
    script -c "screen -r"


### settings.json file


{
    "DEBUG": true,
    "A2_AUTH_SAML_ENABLE": false,
    "A2_AUTH_FEDICT_ENABLE": true,
    "A2_EMAIL_IS_UNIQUE" : true,
    "A2_PROFILE_DISPLAY_EMPTY_FIELDS": true,
    "A2_OPENED_SESSION_COOKIE_DOMAIN": "parent",
    "A2_NUMHOUSE_ERROR_MESSAGE":"Rentrez un format valide.",
    "MELLON_LOGIN_URL": "fedict-login",
    "MELLON_PUBLIC_KEYS": ["/var/lib/authentic2-multitenant/tenants/auth-staging.imio.be/saml.crt"],
    "MELLON_PRIVATE_KEY": "/var/lib/authentic2-multitenant/tenants/auth-staging.imio.be/saml.key",
    "MELLON_IDENTITY_PROVIDERS": [
        {
            "METADATA_URL": "https://idp.iamfas.int.belgium.be/fas/saml2/jsp/exportmetadata.jsp"
        }
    ],
    "MELLON_ATTRIBUTE_MAPPING": {
        "last_name": "{attributes[surname][0]}",
        "first_name": "{attributes[givenName][0]}"
    },
    "A2_USERNAME_LABEL": "Adresse e-mail",
    "A2_IDP_OIDC_JWKSET": {
        "keys":
        [
            {
                "d":"Y9GJV37oeFlqz2vuZZDsBVfu4u6YLGbMR7ONhedvn3YTMvFxzmeSwjHd2pdoY05TBjgNbDk6QaCKVtqRrHsbbrmYN_6aRIoZk9KiZqLPvnrRUbe0_lLaozJxZjPa4urb8-vsq_Y040DhUEiBog0xjq2RDg7qtcpi5nf0NRNhXbEm2dzIutH22e8WDoUMma8b64NeZgciSmvdu24UUG_eoAt7fsy8xfL81nxA6qk0mWFrjyCpvxmjEotuCBQ79JLzStWeiKkBx80mokNnMTD3bZm-coJRXEPTcKzmtG_NTmNGi1_IZwZslr5cB6F3cyMIsA1y4mYgYu46JNVvUlwIYQ",
                "dp":"OSokOYunlOqOFxOXuMNfdxTyxi2itS5dW2M4S0PBzwlfOU-fD7JWft94sRTOXCP65No_vmw-V2AHnRRj-GgcHdjyIgHkMV4bgtgUkV7HtAmsC_VAdYwnEWOfeaq-izl34DRUt-qN_m6HzNVziC2JtiPum2ifFuS2vrvO4FTPMgE",
                "dq":"QwnEqx3W1MOa5dRhboSwPu4_J5vgwqofjeKrQD1OmEjeowwzJmj5aYiRysZW6IzV5L7XpW081EdxDXI6ddBGWRq-QFlpF9hGxGYQ9qmmohz_ZcVuw5qUdoF113tUA_9aPujG3LPV7S9Jt-R1piN8b7HGUkz_DSVMLzgArlQ4F8k",
                "e":"AQAB",
                "kty":"RSA",
                "n":"yDIt_sOfAY7h5kcyQLimct2R-4PF5K6Fb90xtEAQmZiXzfW2LzhUX4Uow-XLU_shMrAwixAqc-P8A_Sg-IpCHqvcEaIt0tylGThaguN6e6kJxgTU22Oqx4QBCgejm9xMW9kNf15OvudBiuxn5vveR8VFts_pWU-wCNwBw1AHx67E6dszP0C2G7ZN_7v9AI3f3fTj9S1AGzaJHX5bu9aSRFkmVk-K_VBOyovJYYXb3rhFoy16fJWGsxSTLHD9LS_OvpN3_EIj82ziTB2pEAhMAN4uuB8QmhYvevBin96TbECNMCuIbxenbZYyn1FslXWn29-UA03f8-jau5PubcyEDQ",
                "p":"-Rh3WQ2i3ona_U4kKMR_XGYF6JXwQJAcfUlSfkx6VBI3mmW5uXzWWj8KFgRZEklhGoEq57GCyPWiRARgFOdLRHGQzJidvZaNFqpWw96oFP5eDaOdmLmtthr59l6kUqfQgUwRF_QeHEOlgQrmXBG7-j2hNt0L-YdQIHO0OUEU0Fk",
                "q":"zb67UTECBXKtRfrDoyOvxOc1g7FcUSwGI15Qc_VXIG8ktRtJtj-6ZsnHymO3MXYE3L0ucjxmivj9ow6yVvj6C9uMLmo8AUNhzzF6_FCgHTMERu7pNeRU5ArLMMJA-A5dcMyLCPnGCVFKxhMCEbVeAMs0DfJA6CW1Gk4E61GfOtU",
                "qi":"d4R9BfJKsnOA3ZHpTXtn7mR0uvxPK-mGiYVVLmk0Ko7OSCQxjzYscfle8L3d0iwTPXVVVhazT5ZUN-jOEzmtJ4XQxnfgYqdfxgAXIwducaoz4aptW3GOWcwK9sK_q89IdV3HRQdeJhwUG4IJINBtC7QYvwE9FNhWvC9DsB5VAEo"
            }
        ]
    },
    "LDAP_AUTH_SETTINGS": [
        {
            "url": "ldap://ldap-url/",
            "basedn": "ou=users,dc=xxx,dc=xxx",
            "user_filter": "uid=%s",
            "username_template": "{uid[0]}@{realm}",
            "binddn": "cn=xxx,dc=xxx.dc=xxx",
            "bindpw": "password",
            "attributes": [ "uid" ],
            "use_tls": false
         }
    ]
}
