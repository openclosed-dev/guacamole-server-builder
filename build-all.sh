#!/bin/bash

rm -rf work/*.deb

OS_CODENAME=focal docker compose up --build
OS_CODENAME=jammy docker compose up --build
OS_CODENAME=noble docker compose up --build
