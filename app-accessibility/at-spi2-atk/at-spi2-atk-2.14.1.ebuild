# Distributed under the terms of the GNU General Public License v2

EAPI="6"
GNOME2_LA_PUNT="yes"

inherit gnome2 multilib-minimal virtualx

DESCRIPTION="Gtk module for bridging AT-SPI to Atk"
HOMEPAGE="https://wiki.gnome.org/Accessibility"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="*"

IUSE=""

COMMON_DEPEND="
	>=app-accessibility/at-spi2-core-2.11.2[${MULTILIB_USEDEP}]
	>=dev-libs/atk-2.11.90[${MULTILIB_USEDEP}]
	>=dev-libs/glib-2.32:2[${MULTILIB_USEDEP}]
	>=sys-apps/dbus-1.5[${MULTILIB_USEDEP}]
"
RDEPEND="${COMMON_DEPEND}
	!<gnome-extra/at-spi-1.32.0-r1
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig
"

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--enable-p2p
}

multilib_src_test() {
	virtx emake check TESTS_ENVIRONMENT="dbus-run-session"
}

multilib_src_compile() { gnome2_src_compile; }
multilib_src_install() { gnome2_src_install; }
