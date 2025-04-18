# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit gnome2

DESCRIPTION="GNOME Flashback window manager"
HOMEPAGE="https://gitlab.gnome.org/GNOME/metacity"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="*"

IUSE="+libcanberra xinerama"

# TODO: libgtop could be optional, but no knob
RDEPEND="
	>=dev-libs/glib-2.25.2:2
	>=x11-libs/gtk+-3.12.0:3[X]
	>=x11-libs/pango-1.2.0[X]
	>=x11-libs/libXcomposite-0.2
	>=gnome-base/gsettings-desktop-schemas-3.3.0
	x11-libs/libXfixes
	x11-libs/libXrender
	x11-libs/libXdamage
	libcanberra? ( media-libs/libcanberra[gtk3] )
	>=x11-libs/startup-notification-0.7
	x11-libs/libXcursor
	gnome-base/libgtop:2=
	x11-libs/libX11
	xinerama? ( x11-libs/libXinerama )
	x11-libs/libXrandr
	x11-libs/libXext
	x11-libs/libICE
	x11-libs/libSM
	gnome-extra/zenity
"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	sys-devel/gettext
	>=dev-util/intltool-0.34.90
	dev-util/itstool
	virtual/pkgconfig
" # autoconf-archive for eautoreconf

src_configure() {
	gnome2_src_configure \
		--disable-static \
		$(use_enable libcanberra canberra) \
		--enable-compositor \
		--enable-render \
		--enable-shape \
		--enable-sm \
		--enable-startup-notification \
		--enable-xsync \
		--enable-themes-documentation \
		$(use_enable xinerama)
}
