# Launch in single mode to embrace process-wide Google queries limit.
# Could be tuned if paid Google version is used
# workers 0
threads 0, 32
port ENV.fetch('PORT') { 8000 }

preload_app!
