# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 virtualx

DESCRIPTION="Libraries for the gnome desktop that are not part of the UI"
HOMEPAGE="https://gitlab.gnome.org/GNOME/gnome-desktop"

LICENSE="GPL-2+ FDL-1.1+ LGPL-2+"
SLOT="3/10" # subslot = libgnome-desktop-3 soname version
KEYWORDS="*"

IUSE="debug +introspection"

# cairo[X] needed for gnome-bg
COMMON_DEPEND="
	app-text/iso-codes
	>=dev-libs/glib-2.38:2[dbus]
	>=x11-libs/gdk-pixbuf-2.33.0:2[introspection?]
	>=x11-libs/gtk+-3.3.6:3[X,introspection?]
	>=x11-libs/libXext-1.1
	>=x11-libs/libXrandr-1.3
	x11-libs/cairo:=[X]
	x11-libs/libX11
	x11-misc/xkeyboard-config
	>=gnome-base/gsettings-desktop-schemas-3.5.91
	introspection? ( >=dev-libs/gobject-introspection-0.9.7:= )
"
RDEPEND="${COMMON_DEPEND}
	sys-apps/hwdata
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-xml-dtd:4.1.2
	dev-util/gdbus-codegen
	>=dev-build/gtk-doc-am-1.4
	>=dev-util/intltool-0.40.6
	dev-util/itstool
	sys-devel/gettext
	x11-base/xorg-proto
	virtual/pkgconfig
"

# Includes X11/Xatom.h in libgnome-desktop/gnome-bg.c which comes from xproto
# Includes X11/extensions/Xrandr.h that includes randr.h from randrproto (and
# eventually libXrandr shouldn't RDEPEND on randrproto)

PATCHES=(
	# From GNOME:
	# 	https://gitlab.gnome.org/GNOME/gnome-desktop/-/commit/f9b2c480e38de4dbdd763137709a523f206a8d1b
	# 	https://gitlab.gnome.org/GNOME/gnome-desktop/-/commit/70d46d5cd8bac0de99fed21ee2247ec74b03991b
	"${FILESDIR}"/${PN}-3.19.1-thumbnail-ignore-errors-when-not-all-frames-are-loaded.patch
	"${FILESDIR}"/${PN}-3.19.1-build-require-the-newest-gdk-pixbuf.patch
)

src_configure() {
	gnome2_src_configure \
		--disable-static \
		--with-gnome-distributor=Gentoo \
		--enable-desktop-docs \
		--with-pnp-ids-path=/usr/share/hwdata/pnp.ids \
		$(usex debug --enable-debug=yes ' ') \
		$(use_enable introspection)
}

src_test() {
	# Makes unittest fail without this locale installed
	rm "${S}"/tests/he_IL* || die

	virtx emake check
}
