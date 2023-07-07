# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "fluent-bit/map.jinja" import bit with context %}

{{ bit.pkg }}_repo-absent:
{%- if salt['grains.get']('os_family') == 'RedHat' %}
  pkgrepo.absent:
    - name: {{ bit.pkg }}

{%- elif salt['grains.get']('os_family') == 'Debian' %}
  file.absent:
    - name: /etc/apt/sources.list.d/{{ bit.pkg }}.list

{{ bit.pkg }}_repo-keyring-absent:
  file.absent:
    - name: {{ bit.repo.keyring }}

{%- endif %}
