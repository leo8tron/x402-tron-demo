#!/bin/bash
set -e

# X402 TRON Demo - Unified Startup Script
# Usage: ./start.sh [server|facilitator|client|client-ts]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

PYTHON_BIN="python"
if [ -x "$SCRIPT_DIR/.venv/bin/python" ]; then
    PYTHON_BIN="$SCRIPT_DIR/.venv/bin/python"
fi

COMPONENT=$1

if [ -z "$COMPONENT" ]; then
    echo "Usage: ./start.sh <component>"
    echo ""
    echo "Components:"
    echo "  server       - Protected resource server (Python/FastAPI)"
    echo "  facilitator  - Payment facilitator service (Python/FastAPI)"
    echo "  client       - Payment client (Python)"
    echo "  client-ts    - Payment client (TypeScript)"
    exit 1
fi

# Check if .env exists
if [ ! -f ".env" ]; then
    echo "❌ Error: .env file not found"
    echo ""
    echo "Please create .env file with:"
    echo "  TRON_PRIVATE_KEY=your_private_key"
    echo "  PAY_TO_ADDRESS=your_tron_address"
    exit 1
fi

case "$COMPONENT" in
    server)
        echo "=========================================="
        echo "Starting X402 Protected Resource Server"
        echo "=========================================="
        cd server
        "$PYTHON_BIN" main.py
        ;;
    facilitator)
        echo "=========================================="
        echo "Starting X402 Facilitator"
        echo "=========================================="
        cd facilitator
        "$PYTHON_BIN" main.py
        ;;
    client)
        echo "=========================================="
        echo "Starting X402 Client (Python)"
        echo "=========================================="
        cd client/python
        "$PYTHON_BIN" main.py
        ;;
    client-ts)
        echo "=========================================="
        echo "Starting X402 Client (TypeScript)"
        echo "=========================================="
        cd client/typescript
        if [ ! -d "node_modules" ]; then
            echo "Installing dependencies..."
            npm install
        fi
        npm start
        ;;
    *)
        echo "❌ Unknown component: $COMPONENT"
        echo "Valid: server, facilitator, client, client-ts"
        exit 1
        ;;
esac
