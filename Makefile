.PHONY: default
default: all

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
	wip

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

INCLUDES := $(wildcard $(SRCDIR)/inc.*)
OUTPAGES := $(addsuffix .html,$(addprefix $(OUTDIR)/,$(PAGES)))

.PHONY: all
all: $(OUTPAGES) $(OUTDIR)/web_style.css $(OUTDIR)/feed_atom.xml

$(OUTDIR)/index.html: $(OUTDIR)/news.html
	cp $< $@

$(OUTDIR)/%.html: $(SRCDIR)/% $(INCLUDES)
	./make_page $< $(OUTDIR)

$(OUTDIR)/web_style.css: en/web_style.css
	cp $< $@

$(OUTDIR)/feed_atom.xml: $(wildcard $(SRCDIR)/news/news.*)
	./make_feed $^ > $(OUTDIR)/feed_atom.xml

.PHONY: clean
clean:
	$(RM) -r $(OUTDIR)
