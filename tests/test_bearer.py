#!/usr/bin/env python
# -*- coding: utf-8 -*-
import requests
import jwt

#  payload = "&".join(["{}={}".format(key, value) for key, value in data.items()])

url = "http://agents.wc.localhost/idp/oidc/token/"

payload = {
    "grant_type": "password",
    "client_id": "client-id-plone5-app",
    "client_secret": "client-secret-plone5-app",
    "username": "jdoe",
    "password": "jdoe",
    "scope": ["openid"],
}
headers = {
    "Content-Type": "application/x-www-form-urlencoded",
}

response = requests.post(url, headers=headers, data=payload).json()

access_token = response.get("access_token")
token_type = response.get("token_type")
id_token = response.get("id_token")

print(id_token)

# verify
#  url_check = "http://agents.wc.localhost/idp/oidc/certs/"
#
#  result = requests.get(url_check)
#  content = result.content
#  keyset = JWKSet.from_json(content)
#  __import__("ipdb").set_trace()
#  jwt = JWT(jwt=id_token, key=keyset, algs=["RS256"])

#  encoded = response2.json()["keys"][0]["n"]
payload_data = jwt.decode(
    id_token,
    algorithms=["RS256"],
    options={"verify_signature": False, "verify_aud": False},
)

#  url = "http://plone5.localhost/test/"
url = "http://localhost:8081/imio/test-1/"
response = requests.get(
    url,
    headers={
        "Accept": "application/json",
        "Authorization": "Bearer {0}".format(id_token),
    },
)
#  url2 = "http://localhost:8081/imio/"
#  response2 = requests.get(
#      url2,
#      headers={
#          "Accept": "application/json",
#          "Authorization": "Bearer: {0}".format(id_token),
#      },
#  )
__import__("ipdb").set_trace()


#  post_response = requests.post(
#      url,
#      headers={
#          "Accept": "application/json",
#          "Content-Type": "application/json",
#          "Authorization": "{}  {}".format(token_type, id_token),
#      },
#      json={"@type": "Document", "title": "My Document"},
#  )
#
