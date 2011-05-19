.PHONY: default
default: all

PANDOC := pandoc

PAGES :=		\
	api		\
	bindings	\
	books		\
	changes		\
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
	svn		\
	webmasters	\
	download        \
        donations

# To be overridden.
LNG = en

ifeq ($(LNG),en)

SRCDIR := en
OUTDIR := OUT

.PHONY: prepare
prepare:

else
    
SRCDIR := IN.$(LNG)
OUTDIR := OUT/$(LNG)

.PHONY: prepare
prepare:
	$(RM) -r $(SRCDIR)
	./mklndir $(LNG) $(SRCDIR)
	./mklndir en $(SRCDIR)

endif

INCLUDES := \
	$(SRCDIR)/INC.bodystart.html \
	$(SRCDIR)/INC.bodyend.html \
	$(SRCDIR)/INC.head \
	$(SRCDIR)/INC.links

OUTPAGES := $(addsuffix .html,$(addprefix $(OUTDIR)/,$(PAGES)))

.PHONY: all
all: $(OUTPAGES) $(OUTDIR)/web_style.css $(OUTDIR)/feed_atom.xml

$(OUTDIR)/index.html: $(OUTDIR)/news.html
	cp $< $@

$(OUTDIR)/%.html: $(SRCDIR)/% $(INCLUDES) $(OUTDIR)
	./make_page $< $(OUTDIR)

.SECONDARY: $(SRCDIR)/INC.%.html
$(SRCDIR)/INC.%.html: $(SRCDIR)/INC.% $(SRCDIR)/INC.links
	$(PANDOC) $^ --to html --output $@

$(OUTDIR):
	mkdir $(OUTDIR)

$(OUTDIR)/web_style.css: en/web_style.css
	cp $< $@

$(OUTDIR)/feed_atom.xml: $(sort $(wildcard $(SRCDIR)/news/news.*))
	./make_feed $^ > $(OUTDIR)/feed_atom.xml

.DELETE_ON_ERROR: $(OUTDIR)/feed_atom.xml

.PHONY: clean
clean:
	$(RM) -r $(OUTDIR)
