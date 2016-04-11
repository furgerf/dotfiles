#!/bin/bash

tmux new-session -s torrents -d 'qbittorrent-nox'
tmux split-window -v 'cd /var/www/tv-show-torrent-downloader && npm start'
tmux -2 attach-session -d

