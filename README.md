# Buscam

This is a project to use a raspberry pi camera to watch for a bus pulling up in front of my house.

# Build Process

```
cd web
mix deps.get
mix phx.digest
cd ../device
source bin/.env # this loads in sensitive config values like wifi passkeys
mix deps.get
mix firmware
bin/upload.sh buscam.riesd.com
```
