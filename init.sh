#!/usr/bin/env bash
set -e

# ============================================
# init.sh — инициализация worktree
# Запускается после создания git worktree
# С флагом -v показывает время каждого шага
# ============================================

VERBOSE=${VERBOSE:-0}
[[ "$1" == "-v" ]] && VERBOSE=1

profile() {
    if [[ "$VERBOSE" == "1" ]]; then
        local name="$1"
        shift
        local start=$(date +%s.%N)
        "$@"
        local end=$(date +%s.%N)
        local duration=$(echo "$end - $start" | bc 2>/dev/null || echo "?")
        echo "✓ $name: ${duration}s"
    else
        shift
        "$@"
    fi
}

# Mise
profile "mise trust" mise trust 2>/dev/null || true
profile "mise install" mise install

# Copy .envrc from main/master worktree
BASE_DIR=$(git worktree list | grep -E '\[(main|master)\]' | head -1 | awk '{print $1}')
CURRENT_DIR=$(pwd -P)
BASE_DIR_RESOLVED=$(cd "$BASE_DIR" 2>/dev/null && pwd -P)

if [ -n "$BASE_DIR" ] && [ "$BASE_DIR_RESOLVED" != "$CURRENT_DIR" ] && [ -f "$BASE_DIR/.envrc" ]; then
  cp "$BASE_DIR/.envrc" .envrc
  echo "Copied .envrc from $BASE_DIR"
elif [ "$BASE_DIR_RESOLVED" = "$CURRENT_DIR" ]; then
  [[ "$VERBOSE" == "1" ]] && echo "Skipping .envrc copy (already in main/master worktree)"
else
  echo "Warning: Could not find .envrc in main/master worktree"
fi

profile "direnv allow" direnv allow

# ============================================
# Параллельная установка bundle и yarn
# с условной проверкой необходимости
# ============================================

install_bundle() {
    if bundle check &>/dev/null; then
        [[ "$VERBOSE" == "1" ]] && echo "✓ bundle: dependencies satisfied (skipped install)"
        return 0
    fi
    bundle install --jobs=$(nproc)
}

install_yarn() {
    if [ -f "node_modules/.yarn-integrity" ] && [ -f "yarn.lock" ]; then
        if [ "node_modules/.yarn-integrity" -nt "yarn.lock" ]; then
            [[ "$VERBOSE" == "1" ]] && echo "✓ yarn: node_modules up to date (skipped install)"
            return 0
        fi
    fi
    yarn install --frozen-lockfile 2>/dev/null || yarn install
}

if [[ "$VERBOSE" == "1" ]]; then
    echo "Installing dependencies (bundle + yarn in parallel)..."
fi

install_bundle &
BUNDLE_PID=$!

install_yarn &
YARN_PID=$!

BUNDLE_EXIT=0
YARN_EXIT=0

wait $BUNDLE_PID || BUNDLE_EXIT=$?
wait $YARN_PID || YARN_EXIT=$?

if [ $BUNDLE_EXIT -ne 0 ]; then
    echo "❌ bundle install failed with exit code $BUNDLE_EXIT"
    exit $BUNDLE_EXIT
fi

if [ $YARN_EXIT -ne 0 ]; then
    echo "❌ yarn install failed with exit code $YARN_EXIT"
    exit $YARN_EXIT
fi

if [[ "$VERBOSE" == "1" ]]; then
    echo "✓ All dependencies installed successfully"
fi
