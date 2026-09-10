#!/usr/bin/env bash
# rebrand.sh — Reapplies Verse Panel branding on top of upstream JTG Panel code.
# Run this automatically after every upstream sync (see .github/workflows/sync-upstream.yml)
# and it's safe to run multiple times (idempotent seds).

set -e
cd "$(dirname "$0")"

REPO_URL="https://github.com/kidscartoonverse-dotcom/Verse-Panel"

echo "==> Applying Verse Panel branding..."

# UI default panel name text
sed -i "s/'JTG PANEL'/'VERSE PANEL'/g" src/components/Layout.tsx src/pages/Dashboard.tsx 2>/dev/null || true

# Notification welcome text
sed -i 's/Welcome to JTG Panel/Welcome to Verse Panel/g' src/components/NotificationsDropdown.tsx 2>/dev/null || true

# Generated-app comments/descriptions written into hosted apps
sed -i 's/on JTG Panel/on Verse Panel/g; s/hosted on JTG Panel/hosted on Verse Panel/g; s/app on JTG Panel/app on Verse Panel/g; s/Server on JTG Panel/Server on Verse Panel/g' \
  src/server/controllers/servers.ts src/server/services/docker.ts src/server/services/local.ts 2>/dev/null || true

# User-Agent string
sed -i "s#JTG-Panel/2.0 (https://github.com/jtg-panel; admin@jtgpanel.internal)#VersePanel/2.0 (${REPO_URL})#g" src/server/services/jarDownloader.ts 2>/dev/null || true

# Wings description
sed -i 's/JTG Managed Server/Verse Panel Managed Server/g' src/server/services/wings.ts 2>/dev/null || true

# API/system route panel name defaults
sed -i 's/"JTG Panel"/"Verse Panel"/g' src/server/routes/api.ts src/server/routes/system.ts 2>/dev/null || true

# CreateServer.tsx hardcoded JSX brand text
sed -i 's/JTG <span className="text-\[#8f8f8f\] font-medium">PANEL<\/span>/VERSE <span className="text-[#8f8f8f] font-medium">PANEL<\/span>/g' src/pages/CreateServer.tsx 2>/dev/null || true

# public/node.sh banner + description
sed -i 's/JTG Panel/Verse Panel/g' public/node.sh 2>/dev/null || true

# createuser.ts console banner
sed -i 's/=== JTG Panel Owner User Creation ===/=== Verse Panel Owner User Creation ===/g' scripts/createuser.ts 2>/dev/null || true

# server.ts console log tags + startup banner
sed -i 's/\[JTG\] Owner user/[Verse] Owner user/g; s/\[JTG\] Failed/[Verse] Failed/g' server.ts 2>/dev/null || true
grep -q "Verse Panel (based on JTG Panel" server.ts 2>/dev/null || \
  sed -i "s#console.log(\`.*running on port \${PORT}\`);#console.log(\`Verse Panel (based on JTG Panel by Jishnu, modified by Verseedit) running on port \${PORT}\`);#" server.ts 2>/dev/null || true

# CRITICAL: install.sh / update.sh health checks must match the renamed API text
sed -i 's/grep -q "JTG Panel"/grep -q "Verse Panel"/g' install.sh update.sh 2>/dev/null || true

# Sidebar footer credit (kept — required by MIT attribution clause)
grep -q "Modified by Verseedit" src/components/Sidebar.tsx 2>/dev/null || \
  echo "  [!] Sidebar.tsx credit line missing — check manually" 

# index.html title
sed -i 's#<title>.*</title>#<title>Verse Panel</title>#' index.html 2>/dev/null || true

# metadata.json / package.json name fields
sed -i 's/"name": *"[Jj]tg[^"]*"/"name": "verse-panel"/' package.json 2>/dev/null || true

# README manual-install clone target -> our own repo
sed -i "s#git clone https://github.com/JishnuTheGamer/Jtg.git#git clone ${REPO_URL}.git#" README.md 2>/dev/null || true
sed -i '/git clone.*Verse-Panel.git/{n;s/cd Jtg/cd Verse-Panel/}' README.md 2>/dev/null || true

# install.sh self-clone placeholder -> our own repo (in case upstream resets it)
sed -i "s#git clone https://github.com/<your-username>/<your-repo> Jtg#git clone ${REPO_URL} Jtg#" install.sh 2>/dev/null || true
sed -i "s#git clone https://github.com/JishnuTheGamer/Jtg Jtg#git clone ${REPO_URL} Jtg#" install.sh 2>/dev/null || true

echo "==> Rebrand pass complete."
