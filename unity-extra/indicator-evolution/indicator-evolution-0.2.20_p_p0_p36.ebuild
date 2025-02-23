# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

URELEASE="cosmic"
inherit autotools gnome2-utils ubuntu-versionator

MY_PN="evolution-indicator"

DESCRIPTION="Indicator for the Evolution mail client used by the Unity desktop"
HOMEPAGE="https://launchpad.net/evolution-indicator"
SRC_URI="${UURL}/${MY_PN}_${PV}.orig.tar.gz
	${UURL}/${MY_PN}_${PV}-${UVER}.debian.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="dev-libs/dee:=
	dev-libs/glib:2
	dev-libs/libdbusmenu:=
	dev-libs/libunity:=
	dev-libs/libappindicator
	dev-libs/libindicate[gtk,introspection]
	gnome-base/gconf
	gnome-extra/evolution-data-server
	gnome-extra/gtkhtml
	mail-client/evolution
	media-libs/libcanberra
	unity-indicators/indicator-messages
	x11-libs/libnotify"

S="${WORKDIR}/${MY_PN}-${PV}"

src_prepare() {
	ubuntu-versionator_src_prepare
	eautoreconf
}

src_configure() {
	econf --disable-static \
		--disable-schemas-install
}

src_install() {
	emake DESTDIR="${ED}" install
	prune_libtool_files --modules
}

pkg_preinst() {
	gnome2_gconf_savelist
}

pkg_postinst() {
	gnome2_gconf_install
}
