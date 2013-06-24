# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit base gnome2-utils qt5-build ubuntu-versionator

UURL="mirror://ubuntu/pool/universe/u/${PN}"
URELEASE="saucy"
UVER_PREFIX="daily13.06.20"

DESCRIPTION="Qt Components for the Unity desktop - QML plugin"
HOMEPAGE="https://launchpad.net/ubuntu-ui-toolkit"
SRC_URI="${UURL}/${MY_P}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtjsbackend:5
	dev-qt/qtnetwork:5
	dev-qt/qtsvg:5"

S="${WORKDIR}/${PN}-${PV}${UVER_PREFIX}"
QT5_BUILD_DIR="${S}"
MAKEOPTS="${MAKEOPTS} -j1"

src_prepare() {
	# Docs don't build - full of segfaults and incorrect paths #
	sed -e '/documentation\/documentation.pri/d' \
		-i ubuntu-sdk.pro
	qt5-build_src_prepare
}

src_configure() {
	bin/qmake PREFIX=/usr
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
