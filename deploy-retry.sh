#!/bin/bash
# Retry deploy for casino-ranking-jp and cajikomi
for i in {1..12}; do
  echo "=== Attempt $i at $(date) ==="
  
  cd ~/projects/casino-ranking-jp
  if npx wrangler pages deploy dist --project-name=casino-ranking-jp --commit-dirty=true 2>&1; then
    echo "✅ casino-ranking-jp deployed!"
    
    cd ~/projects/cajikomi
    if npx wrangler pages deploy dist --project-name=cajikomi --commit-dirty=true 2>&1; then
      echo "✅ cajikomi deployed!"
      echo "BOTH_DEPLOYED"
      exit 0
    fi
  fi
  
  echo "❌ Still failing, retry in 60s..."
  sleep 60
done
echo "GAVE_UP"
exit 1
