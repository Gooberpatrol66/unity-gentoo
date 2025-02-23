# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

URELEASE="disco"
inherit bash-completion-r1 python-r1 vala ubuntu-versionator versionator xdg

DIR_PV=$(get_version_component_range 1-2)

DESCRIPTION="Service to log activities and present to other apps"
HOMEPAGE="https://launchpad.net/zeitgeist/"
SRC_URI="${UURL}/${MY_P}.orig.tar.xz
	${UURL}/${MY_P}-${UVER}.debian.tar.xz"
#SRC_URI="https://launchpad.net/zeitgeist/${DIR_PV}/${PV}/+download/${P}.tar.xz
#	https://dev.gentoo.org/~eva/distfiles/${PN}/${P}.tar.xz"

LICENSE="LGPL-2+ LGPL-3+ GPL-2+"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE="+datahub downloads-monitor +fts introspection nls sql-debug telepathy"
RESTRICT="mirror"

REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	downloads-monitor? ( datahub )"

RDEPEND="
	${PYTHON_DEPS}
	dev-libs/json-glib
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/rdflib[${PYTHON_USEDEP}]
	media-libs/raptor:2
	>=dev-libs/glib-2.35.4:2
	>=dev-db/sqlite-3.7.11:3
	sys-apps/dbus
	datahub? ( x11-libs/gtk+:3 )
	fts? ( dev-libs/xapian:0=[inmemory] )
	introspection? ( dev-libs/gobject-introspection )
	telepathy? ( net-libs/telepathy-glib )
"
DEPEND="${RDEPEND}
	$(vala_depend)
	>=sys-devel/automake-1.15:1.15
	>=sys-devel/gettext-0.19
	virtual/pkgconfig
"

PATCHES=(
	# Fix direct invocation of python in configure
	"${FILESDIR}"/${PN}-1.0-python-detection.patch
)

src_prepare() {
	# Disable Ubuntu Touch patch
	sed -i \
		-e "/disable-fts-on-touch.patch/d" \
		"${WORKDIR}/debian/patches/series" || die

	# Fix pre-populator
	sed -i \
		-e "s/gcalctool/org.gnome.Calculator/" \
		-e "s/gedit/org.gnome.gedit/" \
		-e "s/totem/org.gnome.Totem/" \
		-e "s/yelp/unity-yelp/" \
		"${WORKDIR}/debian/patches/pre_populator.patch" || die

	ubuntu-versionator_src_prepare

	# pure-python module is better managed manually, see src_install
	sed -e 's:python::g' \
		-i Makefile.am || die

	# XDG autostart only in Unity
	echo "OnlyShowIn=Unity;" >> data/zeitgeist-datahub.desktop.in

	vala_src_prepare
	xdg_src_prepare
}

src_configure() {
	local myeconfargs=(
		--docdir="${EPREFIX}/usr/share/doc/${PF}"
		--without-dee-icu
		$(use_enable sql-debug explain-queries)
		$(use_enable datahub)
		$(use_enable downloads-monitor)
		$(use_enable telepathy)
		$(use_enable introspection)
	)

	use nls || myeconfargs+=( --disable-nls )
	use fts && myeconfargs+=( --enable-fts )

	python_setup
	econf "${myeconfargs[@]}"
}

src_test() {
	emake check TESTS_ENVIRONMENT="dbus-run-session"
}

src_install() {
	default

	dobashcomp data/completions/zeitgeist-daemon

	cd python || die
	python_moduleinto ${PN}
	python_foreach_impl python_domodule *py

	# Redundant NEWS/AUTHOR installation
	rm -r "${D}"/usr/share/zeitgeist/doc/ || die

	# perform VACUUM SQLite database on startups every 10 days
	exeinto /usr/libexec/${PN}
	doexe "${WORKDIR}/debian/zeitgeist-maybe-vacuum"

	prune_libtool_files
}
