# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 virtualx

DESCRIPTION="GNOME power management service"
HOMEPAGE="https://projects.gnome.org/gnome-power-manager/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="*"

IUSE="test"

RESTRICT="!test? ( test )"

COMMON_DEPEND="
	>=dev-libs/glib-2.36:2
	>=x11-libs/gtk+-3.3.8:3
	>=x11-libs/cairo-1
	>=sys-power/upower-0.99:=
"
RDEPEND="${COMMON_DEPEND}
	x11-themes/adwaita-icon-theme
"
DEPEND="${COMMON_DEPEND}
	app-text/docbook-sgml-dtd:4.1
	app-text/docbook-sgml-utils
	>=dev-util/intltool-0.50
	sys-devel/gettext
	x11-base/xorg-proto
	virtual/pkgconfig
	test? ( sys-apps/dbus )
"

# docbook-sgml-utils and docbook-sgml-dtd-4.1 used for creating man pages
# (files under ${S}/man).
# docbook-xml-dtd-4.4 and -4.1.2 are used by the xml files under ${S}/docs.

src_prepare() {
	# Drop debugger CFLAGS from configure
	# Touch configure.ac only if running eautoreconf, otherwise
	# maintainer mode gets triggered -- even if the order is correct
	sed -e 's:^CPPFLAGS="$CPPFLAGS -g"$::g' \
		-i configure || die "debugger sed failed"
	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		$(use_enable test tests)
}

src_test() {
	virtx emake check
}
