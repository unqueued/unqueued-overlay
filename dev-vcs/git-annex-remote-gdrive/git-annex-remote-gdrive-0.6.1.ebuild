# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="git-annex special remote for Google Drive"
HOMEPAGE="https://github.com/Lykos153/git-annex-remote-gdrive"
SRC_URI="https://github.com/Lykos153/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
net-misc/drive
|| (
	dev-vcs/git-annex
	dev-vcs/git-annex-bin
)
"
RDEPEND="${DEPEND}"

src_prepare() {
	default
}

src_install() {
	dodoc README.md LICENSE
	dobin git-annex-remote-gdrive
	insinto /usr/share/${PN}/migrations
	doins migrations/*
}

pkg_postinst() {
    elog "NOTE: git-annex-remote-gdrive has been superseded by git-annex-remote-googledrive"
    elog "Consider using git-annex-remote-googledrive for newer features and updates"
    elog ""
    elog "This package includes a migration script for converting any folder structure"
    elog "To use it, refer to the detailed instructions provided in /usr/share/${PN}/migrations/README.md."
}

