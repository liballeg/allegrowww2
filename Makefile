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

INCLUDES := $(wildcard en/inc.*)

OUTDIR := OUT
OUTPAGES := $(addsuffix .html,$(addprefix $(OUTDIR)/,$(PAGES)))

all: $(OUTPAGES) $(OUTDIR)/web_style.css $(OUTDIR)/feed_atom.xml

$(OUTDIR)/index.html: $(OUTDIR)/news.html
	cp $< $@

$(OUTDIR)/%.html: en/% $(INCLUDES)
	./make_page $< $(OUTDIR)

$(OUTDIR)/web_style.css: en/web_style.css
	cp $< $@

$(OUTDIR)/feed_atom.xml: $(wildcard en/news/news.*)
	./make_feed $^ > $(OUTDIR)/feed_atom.xml

.PHONY: clean
clean:
	$(RM) -r $(OUTDIR)
