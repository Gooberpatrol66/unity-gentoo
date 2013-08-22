# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools gnome2-utils ubuntu-versionator

MY_PN="webapps-applications"
URELEASE="saucy"
UURL="mirror://ubuntu/pool/main/w/${MY_PN}"
UVER_PREFIX="+13.10.20130715"
S="${WORKDIR}/${MY_PN}-${PV}${UVER_PREFIX}"

DESCRIPTION="WebApps: Initial set of Apps for the Unity desktop"
HOMEPAGE="https://launchpad.net/webapps-applications"
SRC_URI="${UURL}/${MY_PN}_${PV}${UVER_PREFIX}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

RDEPEND="!<unity-base/webapps-2.4.16_p0_p01-r1"
DEPEND=">=dev-libs/glib-2.32.3
	dev-libs/json-glib
	dev-libs/libindicate[gtk,introspection]
	dev-libs/libunity
	dev-libs/libunity-webapps
	dev-python/polib
	x11-libs/gtk+:3
	x11-themes/unity-asset-pool"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf
}

src_compile() {
	emake
}

src_install() {
	emake DESTDIR="${ED}" install
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
