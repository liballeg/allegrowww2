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
	maillist	\
	mirrors		\
	news		\
	old		\
	oldnews		\
	readme      	\
	svn		\
	webmasters	\
	wip

INCLUDES := $(wildcard en/inc.*)

OUTDIR := OUT
OUTPAGES := $(addsuffix .html,$(addprefix $(OUTDIR)/,$(PAGES)))

all: $(OUTPAGES) $(OUTDIR)/web_style.css

$(OUTDIR)/index.html: $(OUTDIR)/news.html
	cp $< $@

$(OUTDIR)/%.html: en/% $(INCLUDES)
	./make_page $< $(OUTDIR)

$(OUTDIR)/web_style.css: en/web_style.css
	cp $< $@

.PHONY: clean
clean:
	$(RM) -r $(OUTDIR)
