#!/bin/bash

echo "cinead-d status:"
systemctl is-active cinead-d.service

echo "cinemataztic-player:"
systemctl is-active cinemataztic-player.service

echo "cinematazticio24 status:"
systemctl is-active cinematazticio24.service