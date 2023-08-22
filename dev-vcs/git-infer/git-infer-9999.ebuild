# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Commit your changes with an auto-generated message"
HOMEPAGE="https://github.com/moondewio/git-infer"

EGIT_REPO_URI="https://github.com/moondewio/git-infer"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~arm ~x86 ~amd64-linux"
IUSE=""

DEPEND=""

src_install() {
	dobin git-infer
	einstalldocs
}
