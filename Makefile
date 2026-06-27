# sage-clojure-v2 — GNU Makefile (use gmake; BSD make mis-parses this).
# Clojure 1.12 CLI (clj). JSON is hand-rolled; test.check via deps.edn :test.

CLJ ?= clj

.DEFAULT_GOAL := help

.PHONY: help build check run print mcp-server clean

help: ## Show this help
	@awk 'BEGIN{FS=":.*##"} /^[a-zA-Z0-9_-]+:.*##/ {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## AOT-free compile check: load every namespace
	$(CLJ) -M -e "(doseq [n '[sage-clojure.version sage-clojure.json sage-clojure.config sage-clojure.http sage-clojure.providers sage-clojure.tools sage-clojure.taint sage-clojure.mcp-server sage-clojure.mcp-client sage-clojure.repl sage-clojure.session]] (require n)) (println \"build ok\")"

check: ## Run property + boundary + surface tests (nonzero exit on failure)
	$(CLJ) -M:test

run: ## Start the interactive agent REPL (needs a provider via env)
	$(CLJ) -M -m sage-clojure.repl

print: ## One-shot: gmake print P="your prompt"
	$(CLJ) -M -m sage-clojure.repl -p "$(P)"

mcp-server: ## Serve the tool registry over stdio JSON-RPC 2.0
	$(CLJ) -M:mcp-server

clean: ## Remove build caches
	rm -rf .cpcache target
