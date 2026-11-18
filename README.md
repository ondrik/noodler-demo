# Finding bugs with Z3-Noodler

A static page that shows how the [Z3-Noodler](https://github.com/VeriFIT/z3-noodler) string solver
finds exploits in string-handling code: path traversal filters, XSS sanitizers, open redirect checks,
URL allow-lists and SQL escaping. It also proves that the fixed versions are safe.

```
cases/*.smt2           the SMT-LIB queries (one per code version)
cases/results.json     recorded solver answers, models and times
scripts/run-cases.sh   re-runs all queries:  scripts/run-cases.sh path/to/z3-noodler
build.py               the stories (prose + code); renders template.html -> index.html
template.html, style.css
```

Rebuild after changing a query or a story:

```shell
scripts/run-cases.sh ~/z3-noodler/build/z3
python3 build.py
```

`index.html` is generated but committed, so GitHub Pages can serve the repository as it is
(*Settings → Pages → Deploy from a branch → main, / (root)*). Every case links to the
[Z3-Noodler playground](https://verifit.github.io/z3-noodler/playground/) with the query in the URL.
