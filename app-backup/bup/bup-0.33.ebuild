# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} )

inherit python-single-r1

DESCRIPTION="A highly efficient backup system based on the git packfile format"
HOMEPAGE="https://bup.github.io/ https://github.com/bup/bup"
SRC_URI="https://github.com/bup/bup/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+doc test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	app-arch/par2cmdline
	sys-libs/readline:0
	dev-vcs/git
	$(python_gen_cond_dep '
		dev-python/fuse-python[${PYTHON_USEDEP}]
		dev-python/pylibacl[${PYTHON_USEDEP}]
		dev-python/pyxattr[${PYTHON_USEDEP}]
	')"
DEPEND="${RDEPEND}
	test? (
		dev-lang/perl
		net-misc/rsync
	)
	doc? (
		|| ( app-text/pandoc app-text/pandoc-bin )
	)
"

# unresolved sandbox issues
RESTRICT="test"

src_configure() {
	# only build/install docs if enabled
	export PANDOC=$(usex doc pandoc "")

	./configure || die
}

src_test() {
	emake test
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr DOCDIR="/usr/share/${PF}" \
		SITEDIR="$(python_get_sitedir)" install
	python_optimize "${ED}"
}

pkg_postinst() {
	if [[ -n ${REPLACING_VERSIONS} ]]; then
		ewarn "www-servers/tornado is no longer available in Gentoo."
		ewarn "If you need the web UI, please install it manually."
	fi

	einfo "To use the optional web UI, install tornado:"
	einfo "pip install tornado"
}