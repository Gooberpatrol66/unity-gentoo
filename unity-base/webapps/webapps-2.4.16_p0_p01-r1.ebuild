# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils gnome2-utils ubuntu-versionator

URELEASE="saucy"
UVER_PREFIX="daily13.06.20"
UURL="mirror://ubuntu/pool/universe/u"

DESCRIPTION="WebApps: Complete set of Apps for the Unity desktop"
HOMEPAGE="https://launchpad.net/webapps-applications"

LICENSE="GPL-3"
SLOT="0"
#KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="mirror"

DEPEND="unity-base/webapps-base"
S="${WORKDIR}"

## Neat and efficient way of bundling and tracking all available webapps into one ebuild ##
## Borrowed from chenxiaolong's Unity-for-Arch-Extra overlay at https://github.com/chenxiaolong/Unity-for-Arch-Extra ##
setvar() {
	eval "_ver_${1/-/_}=${2}"
	eval "_rel_${1/-/_}=${3}"
	packages+=(${1})
}
setvar amazon			2.4.16daily13.06.20	0ubuntu1
setvar amazoncloudreader	2.4.16daily13.06.20	0ubuntu1
setvar angrybirds		2.2
setvar bbcnews			2.4.16daily13.06.20	0ubuntu1
setvar cnn-news			2.4.16daily13.06.20	0ubuntu1
setvar cuttherope		2.2
setvar deezer			2.4.16daily13.06.20	0ubuntu1
setvar deviantart		2.4.16daily13.06.20	0ubuntu1
setvar facebookmessenger	2.4.16daily13.06.20	0ubuntu1
setvar gmail			2.4.16daily13.06.20	0ubuntu1
setvar googlecalendar		2.4.16daily13.06.20	0ubuntu1
setvar googledocs		2.4.16daily13.06.20	0ubuntu1
setvar googlenews		2.4.16daily13.06.20	0ubuntu1
setvar googleplus		2.4.17daily13.06.21	0ubuntu1
setvar googleplusgames		2.4.16daily13.06.20	0ubuntu1
setvar grooveshark		2.4.16daily13.06.20	0ubuntu1
##setvar hulu-player		2.4.16daily13.06.20	0ubuntu1	# Corrupt tarball authored by upstream
setvar lastfm-radio		2.4.16daily13.06.20	0ubuntu1
setvar launchpad		2.4.16daily13.06.20	0ubuntu1
setvar librefm			2.4.16daily13.06.20	0ubuntu1
setvar linkedin			2.4.16daily13.06.20	0ubuntu1
setvar livemail			2.4.16daily13.06.20	0ubuntu1
setvar lordofultima		2.4.16daily13.06.20	0ubuntu1
setvar mail-ru			2.4.16daily13.06.20	0ubuntu1
setvar newsblur			2.4.16daily13.06.20	0ubuntu1
setvar pandora			2.4.16daily13.06.20	0ubuntu1
setvar pandora-com		2.2ubuntu1
##setvar qml
setvar qq-mail			2.4.16daily13.06.20	0ubuntu1
setvar reddit			2.4.16daily13.06.20	0ubuntu1
setvar tiberiumalliances	2.4.16daily13.06.20	0ubuntu1
setvar tumblr			2.4.16daily13.06.20	0ubuntu1
setvar twitter			2.4.16daily13.06.20	0ubuntu1
setvar vkcom			2.4.16daily13.06.20	0ubuntu1
setvar wordpress		2.4.16daily13.06.20	0ubuntu1
setvar wordpress-com		2.2
setvar yahoomail		2.4.16daily13.06.20	0ubuntu1
setvar yahoonews		2.4.16daily13.06.20	0ubuntu1
setvar yandex-music		2.3
setvar yandexmail		2.4.16daily13.06.20	0ubuntu1
setvar yandexmusic		2.4.16daily13.06.20	0ubuntu1
setvar yandexnews		2.4.16daily13.06.20	0ubuntu1
setvar youtube			2.4.16daily13.06.20	0ubuntu1

for i in ${packages[@]}; do
	unset _rel
	eval "_name=${i}; _ver=\${_ver_${i/-/_}}; _rel=\${_rel_${i/-/_}}"
	if [ ! -z "${_rel}" ]; then
		SRC_URI_array+=("${UURL}/unity-webapps-${_name}/unity-webapps-${_name}_${_ver}.orig.tar.gz"
		"${UURL}/unity-webapps-${_name}/unity-webapps-${_name}_${_ver}-${_rel}.diff.gz")
	else
		SRC_URI_array+=("${UURL}/unity-webapps-${_name}/unity-webapps-${_name}_${_ver}.tar.gz")
	fi
done
SRC_URI="${SRC_URI_array[@]}"
S="${WORKDIR}"


src_prepare() {
	for i in ${packages[@]}; do
		unset _rel
		eval "_name=${i}; _ver=\${_ver_${i/-/_}}; _rel=\${_rel_${i/-/_}}"
		cd "${S}/unity-webapps-${_name}-${_ver}"
		if [ ! -z "${_rel}" ]; then
			epatch -p1 "${S}/unity-webapps-${_name}_${_ver}-${_rel}.diff"
		fi
	done
}

src_install() {
	for i in ${packages[@]}; do
		unset _rel
		eval "_name=${i}; _ver=\${_ver_${i/-/_}}; _rel=\${_rel_${i/-/_}}"
		cd "${S}/unity-webapps-${_name}-${_ver}"
		cat debian/install | while read SOURCE DEST; do
			if [ -f "${SOURCE}" ]; then
				insinto "${DEST}"
				doins "${SOURCE}"
			fi
		done
	done
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	elog
	elog "You my need to restart your browser for it to see these newly installed webapps"
	elog
}

pkg_postrm() {
	gnome2_icon_cache_update
}
