#!/bin/bash
set -e

# Scarica il modello (se non già presente)
echo "⬇️ Scarico modello gemma:1b-it-qat..."
ollama pull gemma:1b-it-qat || true

# Avvia il server in foreground (così il container rimane attivo)
ollama serve
