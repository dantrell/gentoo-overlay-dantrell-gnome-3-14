# Distributed under the terms of the GNU General Public License v2

EAPI="6"
VALA_MAX_API_VERSION="0.50"

inherit gnome2 vala

DESCRIPTION="Clocks application for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Clocks"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE=""

RDEPEND="
	>=app-misc/geoclue-1.99.3:2.0
	>=dev-libs/glib-2.39:2
	>=media-libs/libcanberra-0.30
	>=dev-libs/libgweather-3.13.91:2=
	>=gnome-base/gnome-desktop-3.7.90:3=
	>=sci-geosciences/geocode-glib-0.99.4:0
	>=x11-libs/gtk+-3.12:3
"
DEPEND="${RDEPEND}
	$(vala_depend)
	>=dev-util/intltool-0.40
	dev-util/itstool
	>=sys-devel/gettext-0.17
	virtual/pkgconfig
"

src_prepare() {
	vala_src_prepare
	gnome2_src_prepare
}
