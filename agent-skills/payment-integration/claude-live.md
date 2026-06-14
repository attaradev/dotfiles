## Detected Payment Integration Context

!`find . \( -name "*.go" -o -name "*.ts" -o -name "*.js" -o -name "*.py" \) -not -path "*/node_modules/*" -not -path "*/.git/*" 2>/dev/null | xargs grep -l -i "stripe\|paystack\|flutterwave\|mpesa\|daraja\|paypal\|checkout\|billing\|subscription" 2>/dev/null | head -10 | sed 's|^\./||' || echo "none"`
