# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit ubuntu-versionator

DESCRIPTION="Unity Desktop - merge this to pull in all Unity packages"
HOMEPAGE="http://unity.ubuntu.com/"

URELEASE="cosmic"

LICENSE="metapackage"
SLOT="0/${URELEASE}"
KEYWORDS="~amd64 ~x86"
IUSE="accessibility +chat gnome gnome-extras +nocsd +unity-extras +xdm"
RESTRICT="mirror"

DEPEND="gnome-base/gnome-core-libs
	gnome-base/nautilus
	gnome-extra/activity-log-manager
	gnome-extra/nm-applet
	unity-base/hud
	unity-base/unity
	unity-base/unity-build-env
	unity-base/unity-control-center
	unity-extra/ehooks
	unity-indicators/unity-indicators-meta
	unity-lenses/unity-lens-meta
	x11-misc/notify-osd
	x11-themes/ubuntu-wallpapers
	accessibility? (
		app-accessibility/at-spi2-atk
		app-accessibility/at-spi2-core
		app-accessibility/caribou
		app-accessibility/orca
		gnome-extra/mousetweaks )
	chat? (
		net-im/empathy
		net-libs/telepathy-indicator )
	gnome? ( gnome-base/gnome-core-apps )
	gnome-extras? ( gnome-base/gnome-extra-apps )
	nocsd? ( x11-misc/gtk3-nocsd )
	unity-extras? (
		app-backup/deja-dup[nautilus]
		unity-extra/unity-tweak-tool )
	xdm? ( || ( unity-extra/unity-greeter gnome-base/gdm ) )"
