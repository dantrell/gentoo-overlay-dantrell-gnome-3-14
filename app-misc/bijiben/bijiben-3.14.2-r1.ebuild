# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="no"

inherit gnome2

DESCRIPTION="Note editor designed to remain simple to use"
HOMEPAGE="https://wiki.gnome.org/Apps/Bijiben"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="*"
IUSE=""

# zeitgeist is optional but automagic
RDEPEND="
	>=app-misc/tracker-1:=
	>=dev-libs/glib-2.28:2
	dev-libs/libxml2
	>=gnome-extra/evolution-data-server-3.13.90:=
	>=mail-client/evolution-3
	gnome-extra/zeitgeist
	net-libs/gnome-online-accounts
	net-libs/webkit-gtk:3
	sys-apps/util-linux
	>=x11-libs/gtk+-3.11.4:3
"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35.0
	sys-devel/gettext
	virtual/pkgconfig
"
#	app-text/yelp-tools

src_prepare() {
	# From GNOME
	# 	https://git.gnome.org/browse/bijiben/commit/?id=2c5a80bdc6a469153a7e8ca34ee6f4fa72e6a34a
	epatch "${FILESDIR}"/${PN}-3.15.3-fix-build-with-evolution-data-server-3.13.90.patch

	gnome2_src_prepare
}

src_configure() {
	gnome2_src_configure \
		ITSTOOL="$(type -P true)" \
		--disable-update-mimedb
}
