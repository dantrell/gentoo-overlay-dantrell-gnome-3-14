# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2 pax-utils virtualx

DESCRIPTION="Javascript bindings for GNOME"
HOMEPAGE="https://wiki.gnome.org/Projects/Gjs https://gitlab.gnome.org/GNOME/gjs"

LICENSE="MIT || ( MPL-1.1 LGPL-2+ GPL-2+ )"
SLOT="0"
KEYWORDS="*"

IUSE="+cairo examples gtk test"

RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/glib-2.36:2
	>=dev-libs/gobject-introspection-1.41.4:=

	sys-libs/readline:0=
	dev-lang/spidermonkey:24=
	dev-libs/libffi:=
	cairo? ( x11-libs/cairo[X] )
	gtk? ( x11-libs/gtk+:3 )
"
DEPEND="${RDEPEND}
	gnome-base/gnome-common
	sys-devel/gettext
	virtual/pkgconfig
	test? ( sys-apps/dbus )
"

PATCHES=(
	# Disable broken unittests
	"${FILESDIR}"/${PN}-1.42.0-disable-unittest-{1,2,3}.patch
)

src_configure() {
	# Code Coverage support is completely useless for portage installs
	gnome2_src_configure \
		--disable-systemtap \
		--disable-dtrace \
		--disable-coverage \
		$(use_with cairo cairo) \
		$(use_with gtk)
}

src_test() {
	virtx emake check
}

src_install() {
	# Installation sometimes fails in parallel
	gnome2_src_install -j1

	if use examples; then
		dodoc -r examples
	fi

	# Required for gjs-console to run correctly on PaX systems
	pax-mark mr "${ED}/usr/bin/gjs-console"
}
