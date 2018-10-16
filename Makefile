OUTDIR = site_build
MD_PAGES = $(wildcard content/*.md)
HTML_PAGES = $(patsubst content/%.md,$(OUTDIR)/%,$(MD_PAGES))

STATIC_SOURCE = static
STATIC_DEST = static

PANDOC_FLAGS = -s -f markdown -t html5 -c static/css/solarized-light.css

.PHONY: all
all: pages static

.phony: static
static: $(OUTDIR)/$(STATIC_DEST)

.PHONY: pages
pages: $(HTML_PAGES)

$(OUTDIR):
	mkdir -p $(OUTDIR)

$(OUTDIR)/%: content/%.md | $(OUTDIR)
	pandoc $(PANDOC_FLAGS) --toc --toc-depth=4 --mathjax \
		-M sourcefilename:"$<" \
		-o "$@" "$<"

.PHONY: $(OUTDIR)/$(STATIC_DEST)
$(OUTDIR)/$(STATIC_DEST): $(OUTDIR)
	rsync -rup --delete $(STATIC_SOURCE)/* $(OUTDIR)/$(STATIC_DEST)

.PHONY: clean
clean:
	rm -rf $(OUTDIR)
