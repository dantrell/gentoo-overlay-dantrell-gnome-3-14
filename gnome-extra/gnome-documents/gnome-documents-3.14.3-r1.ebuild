# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools gnome2

DESCRIPTION="A document manager application for GNOME"
HOMEPAGE="https://wiki.gnome.org/Apps/Documents"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE=""

# cairo-1.14 for cairo_surface_set_device_scale check and usage
COMMON_DEPEND="
	>=app-text/evince-3.13.3[introspection]
	>=net-libs/webkit-gtk-2.6:4[introspection]
	dev-libs/gjs
	>=dev-libs/glib-2.39.3:2
	>=dev-libs/gobject-introspection-1.31.6:=
	>=x11-libs/gtk+-3.13.2:3[introspection]
	>=net-libs/libsoup-2.41.3:2.4
	gnome-base/gnome-desktop:3=[introspection]
	>=app-misc/tracker-1:0=[miner-fs]
	>=x11-libs/cairo-1.14
	>=dev-libs/libgdata-0.13.3:=[crypt,gnome-online-accounts,introspection]
	x11-libs/gdk-pixbuf:2[introspection]
	>=net-libs/gnome-online-accounts-3.2.0:=[introspection]
	x11-libs/pango[introspection]
	>=net-libs/libzapojit-0.0.2[introspection]
"
RDEPEND="${COMMON_DEPEND}
	net-misc/gnome-online-miners
	sys-apps/dbus
	x11-themes/adwaita-icon-theme
"
DEPEND="${COMMON_DEPEND}
	dev-libs/libxslt
	>=dev-util/intltool-0.50.1
	dev-util/itstool
	virtual/pkgconfig

	app-text/yelp-tools
"
# eautoreconf requires yelp-tools

src_prepare() {
	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gnome-documents/-/commit/7d3af4e4a3452a8ed8e7b3f42216b3460321ec93
	# 	https://gitlab.gnome.org/GNOME/gnome-documents/-/commit/9fd8bfaf78b9c1bcc4cb7e9ad75e1708f6727198
	# 	https://gitlab.gnome.org/GNOME/gnome-documents/-/commit/103595481ef7135b172965c4c3e7e27cc735b5f6
	eapply "${FILESDIR}"/${PN}-3.15.2-port-to-webkit2.patch
	eapply "${FILESDIR}"/${PN}-3.15.2-edit-dont-use-undeclared-variables.patch
	eapply "${FILESDIR}"/${PN}-3.16.2-edit-prevent-webkit2-from-blowing-away-our-cache.patch

	eautoreconf
	gnome2_src_prepare
}
