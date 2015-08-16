.PHONY: default
default: all

PANDOC := pandoc

PAGES :=		\
	api		\
	bindings	\
	books		\
	changes		\
	changes-unstable \
	digmid		\
	docs		\
	humor 		\
	index		\
	irc		\
	license		\
	links		\
	logos		\
	logos_02	\
	logos_03	\
	maillist	\
	mirrors		\
	news		\
	old		\
	oldnews		\
	readme		\
	git 	\
	webmasters	\
	download

SRCDIR := en
OUTDIR := OUT

# Note: before-body and after-body are converted to html
INCLUDES := \
	$(SRCDIR)/_include/before-body.html \
	$(SRCDIR)/_include/after-body.html \
	$(SRCDIR)/_include/in-header \
	$(SRCDIR)/_include/links

OUTPAGES := $(addsuffix .html,$(addprefix $(OUTDIR)/,$(PAGES)))

.PHONY: all
all: $(OUTPAGES) $(OUTDIR)/web_style.css $(OUTDIR)/feed_atom.xml $(OUTDIR)/images

$(OUTDIR)/index.html: $(OUTDIR)/news.html
	cp $< $@

$(OUTDIR)/%.html: $(SRCDIR)/% $(INCLUDES) $(OUTDIR)
	./make_page $< $(OUTDIR)

.SECONDARY: $(SRCDIR)/_include/%.html
$(SRCDIR)/_include/%.html: $(SRCDIR)/_include/% $(SRCDIR)/_include/links
	$(PANDOC) $^ --to html --output $@

$(OUTDIR):
	mkdir $(OUTDIR)

$(OUTDIR)/web_style.css: en/web_style.css
	cp $< $@

$(OUTDIR)/images: images
	cp -r $< $@

$(OUTDIR)/feed_atom.xml: $(sort $(wildcard $(SRCDIR)/news/news.*))
	./make_feed $^ > $(OUTDIR)/feed_atom.xml

.DELETE_ON_ERROR: $(OUTDIR)/feed_atom.xml

.PHONY: clean
clean:
	$(RM) -r $(OUTDIR)
