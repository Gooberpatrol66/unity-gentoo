# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="cosmic"
inherit autotools eutils flag-o-matic gnome2-utils ubuntu-versionator

UVER_PREFIX="+16.10.${PVR_MICRO}"

DESCRIPTION="Indicator for application menus used by the Unity desktop"
HOMEPAGE="https://launchpad.net/indicator-appmenu"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/libdbusmenu:=
	dev-libs/libappindicator:3=
	unity-base/bamf:=
	x11-libs/gtk+:3
	x11-libs/libwnck:1
	x11-libs/libwnck:3"

S="${WORKDIR}"

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
	append-cflags -Wno-error=incompatible-pointer-types
}

src_install() {
	default
	prune_libtool_files --modules
}
