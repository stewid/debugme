# Determine package name and version from DESCRIPTION file
PKG_VERSION=$(shell grep -i ^version DESCRIPTION | cut -d : -d \  -f 2)
PKG_NAME=$(shell grep -i ^package DESCRIPTION | cut -d : -d \  -f 2)

# Name of built package
PKG_TAR=$(PKG_NAME)_$(PKG_VERSION).tar.gz

# Install package
.PHONY: install
install:
	cd .. && R CMD INSTALL $(PKG_NAME)

# Build documentation with roxygen
# 1) Remove old doc
# 2) Generate documentation
.PHONY: roxygen
roxygen:
	rm -f man/*.Rd
	cd .. && Rscript -e "roxygen2::roxygenize('$(PKG_NAME)')"

# Generate PDF output from the Rd sources
# 1) Rebuild documentation with roxygen
# 2) Generate pdf, overwrites output file if it exists
.PHONY: pdf
pdf: roxygen
	cd .. && R CMD Rd2pdf --force $(PKG_NAME)

# Build package
.PHONY: build
build: clean
	cd .. && R CMD build --compact-vignettes=both $(PKG_NAME)

# Check package
.PHONY: check
check: build
	cd .. && OMP_THREAD_LIMIT=2 _R_CHECK_CRAN_INCOMING_=FALSE R CMD check \
        --no-stop-on-test-error --as-cran --run-dontrun $(PKG_TAR)

clean:
	./cleanup
