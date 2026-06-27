(ns sage-clojure.runner
  "Test runner that PROPAGATES failures — exits nonzero on any fail/error so a
  red property can never be masked as a green build (§11 'no masked greens')."
  (:require [clojure.test :as t]
            [sage-clojure.json-test]
            [sage-clojure.taint-test]
            [sage-clojure.tools-test]
            [sage-clojure.providers-test]
            [sage-clojure.providers-chat-test]
            [sage-clojure.http-test]
            [sage-clojure.mcp-test]
            [sage-clojure.mcp-client-test]
            [sage-clojure.session-test]
            [sage-clojure.repl-test]))

(def test-namespaces
  '[sage-clojure.json-test
    sage-clojure.taint-test
    sage-clojure.tools-test
    sage-clojure.providers-test
    sage-clojure.providers-chat-test
    sage-clojure.http-test
    sage-clojure.mcp-test
    sage-clojure.mcp-client-test
    sage-clojure.session-test
    sage-clojure.repl-test])

(defn -main [& _]
  (let [summary (apply t/run-tests test-namespaces)
        failed (+ (:fail summary 0) (:error summary 0))]
    (println)
    (println (format "==> %d assertions, %d failures, %d errors"
                     (:pass summary 0) (:fail summary 0) (:error summary 0)))
    (shutdown-agents)
    (System/exit (if (pos? failed) 1 0))))
