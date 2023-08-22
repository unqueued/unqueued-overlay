# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="manage files with git, without checking their contents into git"
HOMEPAGE="https://git-annex.branchable.com/"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="bundled-git-symlink"

case "${ARCH}" in
	arm64) ARCHIVE_URL="http://archive.org/download/git-annex-builds/SHA256E-s66738845--4efc0636eae3a8e55ccbdd638339b00f39d5691a8f44874dcb0b90ce1425cc47.tar.gz" ;;
	x86) ARCHIVE_URL="http://archive.org/download/git-annex-builds/SHA256E-s53023753--502e4ac3f45d7aa3cfe527ac704bfef77c0867d080e1b37556516a904348c49b.tar.gz" ;;
	amd64) ARCHIVE_URL="http://archive.org/download/git-annex-builds/SHA256E-s54263192--5c322c5c5b35e5835bb94c97be143d2717de1e8fb66f7b037720f7dd1d9cc71f.tar.gz" ;;
esac

SRC_URI="${ARCHIVE_URL} -> ${P}-${ARCH}.tar.gz"

DEPEND=""
RDEPEND="!dev-vcs/git-annex"

INSTALL_PREFIX="/opt"

QA_PREBUILT="${INSTALL_PREFIX}/${PN}/* ${INSTALL_PREFIX}/${PN}/*/*"

S="${WORKDIR}/${PN}-${PV}"

src_unpack() {
	default
	mkdir ${P}
	mv git-annex.linux/* ${P}
}

src_install() {
	insinto "${INSTALL_PREFIX}"
	doman "${S}"/usr/share/man/man1/*
	rm -rf "${S}/usr/share/man"
	cp -r "${S}" "${ED}${INSTALL_PREFIX}/${PN}"
	mkdir -p "${ED}/usr/bin"

	# As long as env is updated, these symlinks shouldn't be needed
	ln -s "${INSTALL_PREFIX}/${PN}/git-annex" "${ED}/usr/bin/"
	ln -s "${INSTALL_PREFIX}/${PN}/git-annex-shell" "${ED}/usr/bin/"
	ln -s "${INSTALL_PREFIX}/${PN}/bin/git-remote-tor-annex" "${ED}/usr/bin/"
	ln -s "${INSTALL_PREFIX}/${PN}/git-annex-webapp" "${ED}/usr/bin/"

	echo "PATH='${INSTALL_PREFIX}/${PN}'" >> "${T}/99git_annex"

	if use bundled-git-symlink; then
		ln -s "${INSTALL_PREFIX}/${PN}/git" "${ED}/usr/bin/"
	fi

	doenvd "${T}"/99git_annex

	einstalldocs
}

pkg_postinst() {
    einfo "git-annex has installed its own version of git at ${INSTALL_PREFIX}/git-annex/bin"
	if use bundled-git-symlink; then
		elog "The bundled git-binary has been symlinked to /usr/bin/git"
		elog "This will prevent dev-vcs/git from being installed"
	fi
}
