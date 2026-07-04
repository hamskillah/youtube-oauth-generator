#!/bin/bash
# =============================================
#  YouTube OAuth TV Token Generator
#  Version: 1.0.0
#  License: MIT
# =============================================

clear
echo ""
echo "╔══════════════════════════════════════════╗"
echo "║      🔑 YOUTUBE OAUTH TV GENERATOR       ║"
echo "║              v1.0.0                      ║"
echo "╚══════════════════════════════════════════╝"
echo ""

read -p "  How many tokens to generate? [1-10]: " COUNT
if [ -z "$COUNT" ] || [ "$COUNT" -lt 1 ] || [ "$COUNT" -gt 10 ]; then
  echo "  ❌ Must be between 1-10!"
  exit 1
fi

declare -a CLIENT_IDS
declare -a CLIENT_SECRETS

for i in $(seq 1 $COUNT); do
  echo ""
  echo "  ─── ACCOUNT $i ───"
  read -p "  Client ID: " CID
  read -p "  Client Secret: " CSEC
  CLIENT_IDS+=("$CID")
  CLIENT_SECRETS+=("$CSEC")
done

echo ""
echo "  ─────────────────────────────────────"
echo "  📋 REVIEW:"
for i in $(seq 0 $((COUNT-1))); do
  echo "  Account $((i+1)): ${CLIENT_IDS[$i]:0:30}..."
done
echo "  ─────────────────────────────────────"
read -p "  Continue? [Y/n]: " CONFIRM
if [ "$CONFIRM" = "n" ]; then
  exit 0
fi

echo ""
echo "  🔑 GENERATING TOKENS..."
echo "  ═════════════════════════════════════"

declare -a REFRESH_TOKENS

for i in $(seq 0 $((COUNT-1))); do
  CID="${CLIENT_IDS[$i]}"
  CSEC="${CLIENT_SECRETS[$i]}"
  NUM=$((i+1))
  
  echo ""
  echo "  📱 Account $NUM:"
  
  RESPONSE=$(curl -s -X POST https://oauth2.googleapis.com/device/code \
    -d "client_id=$CID" \
    -d "scope=https://www.googleapis.com/auth/youtube")
  
  if echo $RESPONSE | grep -q "error"; then
    echo "  ❌ Error: $RESPONSE"
    REFRESH_TOKENS+=("ERROR")
    continue
  fi
  
  DEVICE_CODE=$(echo $RESPONSE | python3 -c "import sys,json; print(json.load(sys.stdin)['device_code'])")
  USER_CODE=$(echo $RESPONSE | python3 -c "import sys,json; print(json.load(sys.stdin)['user_code'])")
  VERIF_URL=$(echo $RESPONSE | python3 -c "import sys,json; print(json.load(sys.stdin)['verification_url'])")
  
  echo "  ┌─────────────────────────────────────"
  echo "  │ 🔗 $VERIF_URL"
  echo "  │ 📋 Code: $USER_CODE"
  echo "  │ ⏰ Open URL on your phone, enter code!"
  echo "  └─────────────────────────────────────"
  echo "  ⏳ Waiting for approval"
  
  GOT=0
  for j in $(seq 1 24); do
    sleep 5
    TOKEN_RES=$(curl -s -X POST https://oauth2.googleapis.com/token \
      -d "client_id=$CID" \
      -d "client_secret=$CSEC" \
      -d "device_code=$DEVICE_CODE" \
      -d "grant_type=urn:ietf:params:oauth:grant-type:device_code")
    
    REFRESH=$(echo $TOKEN_RES | python3 -c "import sys,json; print(json.load(sys.stdin).get('refresh_token',''))" 2>/dev/null)
    
    if [ -n "$REFRESH" ]; then
      echo ""
      echo "  ✅ ACCOUNT $NUM SUCCESS!"
      REFRESH_TOKENS+=("$REFRESH")
      GOT=1
      break
    fi
    echo -n "."
  done
  
  if [ $GOT -eq 0 ]; then
    echo ""
    echo "  ❌ Timeout! Account $NUM failed."
    REFRESH_TOKENS+=("TIMEOUT")
  fi
done

echo ""
echo "  ═════════════════════════════════════"
echo "  🎉 RESULTS:"
echo "  ═════════════════════════════════════"
echo ""
for i in $(seq 0 $((COUNT-1))); do
  echo "  ACCOUNT_$((i+1))=${REFRESH_TOKENS[$i]}"
done
echo ""
echo "  📋 Save these refresh tokens in your config!"
echo ""
