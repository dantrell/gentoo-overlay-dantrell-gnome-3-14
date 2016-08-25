# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit gnome2

DESCRIPTION="GNOME Flashback session and helper application"
HOMEPAGE="https://git.gnome.org/browse/gnome-flashback"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="*"

IUSE=""

RDEPEND="
	>=dev-libs/glib-2.39.9
	>=x11-libs/gtk+-3.12.0:3
	>=x11-wm/metacity-3.14.0
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40.6
	virtual/pkgconfig
"
