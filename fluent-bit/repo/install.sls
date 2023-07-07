# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "fluent-bit/map.jinja" import bit with context %}

{% if salt['grains.get']('os_family') == 'Debian' -%}

{{ bit.pkg }}_apt-transport-https:
  pkg.installed:
    - name: apt-transport-https

{{ bit.pkg }}_keyring:
    file.managed:
      - name: {{ bit.repo.keyring }}
      - source: salt://{{ slspath }}/fluentbit-keyring.gpg
      - require_in:
        - pkgrepo: {{ bit.pkg }}_repo

{{ bit.pkg }}_repo:
  pkgrepo.managed:
    - name: deb [ arch={{ grains.osarch }} signedby={{ bit.repo.keyring }} ]
        https://packages.fluentbit.io/{{ grains.os|lower }}/{{ grains.oscodename }} {{ grains.oscodename }} main
    - file: /etc/apt/sources.list.d/{{ bit.pkg }}.list
    - clean_file: True

{% elif salt['grains.get']('os_family') == 'RedHat' %}

{{ bit.pkg }}_repo:
  pkgrepo.managed:
    - name: {{ bit.pkg }}
    - humanname: Fluent Bit
    - baseurl: https://packages.fluentbit.io/centos/$releasever/{{ grains.osarch }}/
    - gpgcheck: 1
    - gpgkey: https://packages.fluentbit.io/fluentbit.key
    - gpgautoimport: True

{% endif %}
