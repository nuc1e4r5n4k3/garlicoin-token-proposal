
BASENAME=whitepaper

TAG := $(shell [ -d .git ] && git tag --points-at HEAD | tail -n 1)
VERSION := $(shell if [ ! -z "${TAG}" ]; then echo "${TAG}" | sed 's/draft_/Draft /'; else echo "Unknown version"; fi)
DATE := $(shell if [ ! -z "${TAG}" ]; then git log -n 1 --date format:'%d %B %Y' | grep '^Date' | awk -F: '{ print $$2 }'; else echo '\\today'; fi)

all: ${BASENAME}.pdf

${BASENAME}.pdf: ${BASENAME}.versioned.tex
	latex2pdf $^ > $@

${BASENAME}.versioned.tex: ${BASENAME}.tex
	sed 's/@VERSION@/${VERSION}/g' < $^ | sed 's/@DATE@/${DATE}/g' > $@

clean:
	rm -f ${BASENAME}.versioned.tex ${BASENAME}.pdf
