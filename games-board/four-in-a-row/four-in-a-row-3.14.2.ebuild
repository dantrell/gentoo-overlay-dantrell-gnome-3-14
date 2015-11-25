# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"

inherit gnome-games

DESCRIPTION="Make lines of the same color to win"
HOMEPAGE="https://wiki.gnome.org/Apps/Four-in-a-row"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE=""

RDEPEND="
	dev-libs/glib:2
	>=gnome-base/librsvg-2.32
	>=media-libs/libcanberra-0.26[gtk3]
	>=x11-libs/gtk+-3.13.2:3
"
DEPEND="${RDEPEND}
	app-text/yelp-tools
	dev-util/appdata-tools
	>=dev-util/intltool-0.50
	virtual/pkgconfig
"

src_configure() {
	gnome-games_src_configure APPDATA_VALIDATE=$(type -P true)
}
