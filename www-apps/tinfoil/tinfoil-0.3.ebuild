# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A minimalist tool to manage multiple profiles for web browsers"
HOMEPAGE="https://github.com/dyne/tinfoil"

ZUPER_COMMIT="d8e9350523ae0e8ad903a3a85bccc8afc97cda31"
SRC_URI="https://github.com/dyne/tinfoil/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
https://github.com/dyne/zuper/archive/${ZUPER_COMMIT}.tar.gz -> zuper-${ZUPER_COMMIT}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-ma
cos ~x64-macos ~x64-solaris"
IUSE=""

RDEPEND="
	app-shells/zsh
"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}"

src_unpack() {
	default
	unpack zuper-${ZUPER_COMMIT}.tar.gz

	mv "${WORKDIR}/zuper-${ZUPER_COMMIT}/"* "${S}/zuper/"
}

src_install() {

	dodir /usr/share/tinfoil
	dodir /usr/bin

	insinto /usr/share/tinfoil

	doins -r templates
	doins -r zuper

	# Replicate what was done by Makefile
	sed "s/^basedir=./basedir=\/usr\/share\/tinfoil/g" "${S}/tinfoil" > "${D}/usr/bin/tinfoil" || die "Failed to patch tinfoil script"
	fperms +x /usr/bin/tinfoil

	insinto /usr/bin
	doins "${S}/tinfoil-firejail" "${S}/tinfoil-dmenu"
	fperms +x /usr/bin/tinfoil-firejail /usr/bin/tinfoil-dmenu

	einstalldocs
}

pkg_postinst() {
	optfeature "sandboxing" "sys-apps/firejail"
	optfeature "browsers" "www-client/firefox" "www-client/firefox:esr" "www-client/icecat" "www-client/palemoon" "www-client/chromium" "www-client/ungoogled-chromium" "www-client/chrome"
	optfeature "dmenu" "x11-misc/dmenu"
}

