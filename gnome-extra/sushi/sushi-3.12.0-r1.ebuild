# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools gnome2

DESCRIPTION="A quick previewer for Nautilus, the GNOME file manager"
HOMEPAGE="https://git.gnome.org/browse/sushi"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="office"

# Optional app-office/unoconv support (OOo to pdf)
# freetype needed for font loader
# gtk+[X] optionally needed for sushi_create_foreign_window(); when wayland is more widespread, might want to not force it
COMMON_DEPEND="
	>=x11-libs/gdk-pixbuf-2.23[introspection]
	>=dev-libs/gjs-1.40
	>=dev-libs/glib-2.29.14:2
	>=dev-libs/gobject-introspection-0.9.6:=
	>=media-libs/clutter-1.11.4:1.0[introspection]
	>=media-libs/clutter-gtk-1.0.1:1.0[introspection]
	>=x11-libs/gtk+-3.13.2:3[X,introspection]

	>=app-text/evince-3.0[introspection]
	media-libs/freetype:2
	media-libs/gstreamer:1.0[introspection]
	media-libs/gst-plugins-base:1.0[introspection]
	media-libs/clutter-gst:2.0[introspection]
	media-libs/musicbrainz:5=
	net-libs/webkit-gtk:4[introspection]
	x11-libs/gtksourceview:3.0[introspection]

	office? ( app-office/unoconv )
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.40
	virtual/pkgconfig
"
RDEPEND="${COMMON_DEPEND}
	>=gnome-base/nautilus-3.1.90
"

src_prepare() {
	# From GNOME:
	# 	https://git.gnome.org/browse/sushi/commit/?id=f4b6c1c5ca62d82ad139066a09da3da4922fd65e
	# 	https://git.gnome.org/browse/sushi/commit/?id=f63ee725482eb6527b43707a2b4c0ab77990eab1
	# 	https://git.gnome.org/browse/sushi/commit/?id=6a77fa85b07059835713a469aa23629b5b5529d0
	# 	https://git.gnome.org/browse/sushi/commit/?id=49d625b7ee38b395c2d493430d6aa2d2c81fd7c5
	# 	https://git.gnome.org/browse/sushi/commit/?id=27c0c4def6311606e3b1ba6bdc4320fa6a3cb368
	# 	https://git.gnome.org/browse/sushi/commit/?id=f814446e9032d64f34f2b02e4f8b899db31688e6
	eapply "${FILESDIR}"/${PN}-3.15.90-build-require-gtk-3-13-2.patch
	eapply "${FILESDIR}"/${PN}-3.15.90-evince-viewer-fix-the-icons-in-rtl.patch
	eapply "${FILESDIR}"/${PN}-3.15.90-audio-fix-the-icons-in-rtl.patch
	eapply "${FILESDIR}"/${PN}-3.15.90-gst-fix-the-icons-in-rtl.patch
	eapply "${FILESDIR}"/${PN}-3.15.90-use-margin-startend-instead-of-margin-leftright.patch
	eapply "${FILESDIR}"/${PN}-3.15.90-port-html-viewer-to-webkit.patch

	eautoreconf
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure --disable-static
}
