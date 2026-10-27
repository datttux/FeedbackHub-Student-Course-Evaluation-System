#!/usr/bin/env bash
# ====================================================================
# Student Feedback System - Easy Startup & Control Script
# ====================================================================

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$APP_DIR" || exit 1

PID_FILE="$APP_DIR/server.pid"
LOG_FILE="$APP_DIR/server.log"
PORT=${PORT:-8080}

start_server() {
    if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        echo "⚠️  Server is already running with PID $(cat "$PID_FILE") on http://localhost:$PORT"
        exit 0
    fi

    echo "🚀 Compiling and starting Student Feedback System on port $PORT..."
    mvn compile -q
    mvn exec:java > "$LOG_FILE" 2>&1 &
    SERVER_PID=$!
    echo $SERVER_PID > "$PID_FILE"

    echo "⏳ Waiting for server to initialize..."
    sleep 3

    if kill -0 "$SERVER_PID" 2>/dev/null; then
        echo "✅ Student Feedback System is RUNNING (PID: $SERVER_PID)"
        echo "🌐 Open in your browser:"
        echo "   • Home Page     : http://localhost:$PORT"
        echo "   • Student Portal: http://localhost:$PORT/student-login"
        echo "   • Admin Portal  : http://localhost:$PORT/admin-login"
        echo "📋 Logs: tail -f $LOG_FILE"
    else
        echo "❌ Server failed to start. Check $LOG_FILE for details."
        exit 1
    fi
}

stop_server() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if kill -0 "$PID" 2>/dev/null; then
            echo "🛑 Stopping server (PID: $PID)..."
            kill "$PID"
            rm -f "$PID_FILE"
            echo "✅ Server stopped successfully."
        else
            echo "⚠️  No running server found with PID $PID."
            rm -f "$PID_FILE"
        fi
    else
        echo "⚠️  PID file not found. Searching for running Tomcat process on port $PORT..."
        PID=$(lsof -ti :$PORT)
        if [ -n "$PID" ]; then
            kill "$PID"
            echo "✅ Stopped process $PID on port $PORT."
        else
            echo "ℹ️  No process running on port $PORT."
        fi
    fi
}

status_server() {
    if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
        echo "✅ Server is ACTIVE with PID $(cat "$PID_FILE") on http://localhost:$PORT"
    else
        PID=$(lsof -ti :$PORT)
        if [ -n "$PID" ]; then
            echo "✅ Process running on port $PORT with PID $PID"
        else
            echo "⭕ Server is NOT running."
        fi
    fi
}

case "$1" in
    start)
        start_server
        ;;
    stop)
        stop_server
        ;;
    restart)
        stop_server
        sleep 1
        start_server
        ;;
    status)
        status_server
        ;;
    *)
        echo "Usage: ./run.sh {start|stop|restart|status}"
        exit 1
        ;;
esac
