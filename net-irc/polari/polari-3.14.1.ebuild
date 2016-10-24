# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2

DESCRIPTION="An IRC client for Gnome"
HOMEPAGE="https://wiki.gnome.org/Apps/Polari"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

IUSE=""

COMMON_DEPEND="
	dev-libs/gjs
	>=dev-libs/glib-2.41:2
	>=dev-libs/gobject-introspection-0.9.6:=
	net-libs/telepathy-glib[introspection]
	>=x11-libs/gtk+-3.13.4:3[introspection]
"
RDEPEND="${COMMON_DEPEND}
	>=net-irc/telepathy-idle-0.2
"
DEPEND="${COMMON_DEPEND}
	dev-libs/appstream-glib
	>=dev-util/intltool-0.50
	virtual/pkgconfig
"
