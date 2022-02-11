This repo is used to package [authenitc](https://authentic2.readthedocs.io/en/stable/) single sign on app (SSO).
Authentic app is developped by [entr'ouvert](https://www.entrouvert.com). 

It's a docker-compose based project to allow locally usage of authentic project.

## Badges

[![CI](https://github.com/IMIO/docker-authentic/actions/workflows/ci.yml/badge.svg)](https://github.com/IMIO/docker-authentic/actions/workflows/ci.yml)

## Requirements

docker-compose 1.6 or above and docker

## Authentic usage

- Compose and run the container image

  docker-compose up

You can now go to agents.wc.localhost but if you want Wallonie Connect dev env, you have to configure authenitc, combo and hobo. Use this command:

  make configure-wc

- Go to http://agents.wc.localhost with you favorite browser, an admin account is
  setup, username is "admin" and password is "admin" (without the quotes).

## Authentic and other app usage

- To set complete testing environment (Plone 4, Plone 5 and Authentic apps at this moment), you can created test env with data with this command:

  make testing-env

- After you can start Plone 4, Plone 5 and Authentic with this command:

  docker-compose -f docker-compose.yml -f docker-compose.test.yml up

# Docker image

https://hub.docker.com/r/imiobe/authentic
